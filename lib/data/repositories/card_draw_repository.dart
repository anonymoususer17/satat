import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_draw_model.dart';
import '../models/card_model.dart';
import '../models/lobby_model.dart';
import '../../domain/services/card_draw_service.dart';

/// Repository for card draw operations
class CardDrawRepository {
  final FirebaseFirestore _firestore;
  final CardDrawService _cardDrawService;

  CardDrawRepository({
    FirebaseFirestore? firestore,
    CardDrawService? cardDrawService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _cardDrawService = cardDrawService ?? CardDrawService();

  /// Start card draw phase for a lobby
  Future<void> startCardDraw(String lobbyId) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      if (lobby.status != LobbyStatus.waiting) {
        throw Exception('Lobby is not in waiting state');
      }

      if (lobby.cardDrawStarted) {
        throw Exception('Card draw already started');
      }

      // Initialize card draw with shuffled deck
      final cardDraw = _cardDrawService.initializeCardDraw();

      await lobbyRef.update({
        'cardDrawStarted': true,
        'cardDraw': _cardDrawToMap(cardDraw),
      });
    } catch (e) {
      throw Exception('Failed to start card draw: ${e.toString()}');
    }
  }

  /// Pick a card for a player position
  Future<void> pickCard({
    required String lobbyId,
    required int position,
    required CardModel card,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);

      // Use transaction to prevent concurrent picks
      await _firestore.runTransaction((transaction) async {
        final lobbyDoc = await transaction.get(lobbyRef);

        if (!lobbyDoc.exists) {
          throw Exception('Lobby not found');
        }

        final lobby = _lobbyFromFirestore(lobbyDoc);

        if (lobby.cardDraw == null) {
          throw Exception('Card draw not started');
        }

        if (lobby.cardDraw!.isComplete) {
          throw Exception('Card draw already complete');
        }

        // Check if player already picked
        if (lobby.cardDraw!.playerPicks[position] != null) {
          throw Exception('Player already picked a card');
        }

        // Check if card is available
        final isCardAvailable = lobby.cardDraw!.availableCards.any(
          (c) => c.id == card.id,
        );

        if (!isCardAvailable) {
          throw Exception('Card not available');
        }

        // Update state
        final updatedAvailableCards = lobby.cardDraw!.availableCards
            .where((c) => c.id != card.id)
            .toList();

        final updatedPlayerPicks = Map<int, CardModel?>.from(
          lobby.cardDraw!.playerPicks,
        );
        updatedPlayerPicks[position] = card;

        // Check if all players have picked
        final allPicked = updatedPlayerPicks.values.every((c) => c != null);

        int? winningPosition;
        int? winningTeam;

        if (allPicked) {
          // Determine winner
          final picksMap = updatedPlayerPicks.map(
            (pos, card) => MapEntry(pos, card!),
          );
          final result = _cardDrawService.determineWinner(
            picksMap,
            lobby.players,
          );
          winningPosition = result.$1;
          winningTeam = result.$2;
        }

        final updatedCardDraw = lobby.cardDraw!.copyWith(
          availableCards: updatedAvailableCards,
          playerPicks: updatedPlayerPicks,
          isComplete: allPicked,
          winningPosition: winningPosition,
          winningTeam: winningTeam,
        );

        transaction.update(lobbyRef, {
          'cardDraw': _cardDrawToMap(updatedCardDraw),
        });
      });
    } catch (e) {
      throw Exception('Failed to pick card: ${e.toString()}');
    }
  }

  /// Complete card draw (mark as complete)
  Future<void> completeCardDraw({
    required String lobbyId,
    required int winningPosition,
    required int winningTeam,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      if (lobby.cardDraw == null) {
        throw Exception('Card draw not started');
      }

      final updatedCardDraw = lobby.cardDraw!.copyWith(
        isComplete: true,
        winningPosition: winningPosition,
        winningTeam: winningTeam,
      );

      await lobbyRef.update({
        'cardDraw': _cardDrawToMap(updatedCardDraw),
      });
    } catch (e) {
      throw Exception('Failed to complete card draw: ${e.toString()}');
    }
  }

  /// Convert CardDrawModel to Firestore map
  Map<String, dynamic> _cardDrawToMap(CardDrawModel cardDraw) {
    return {
      'availableCards': cardDraw.availableCards
          .map((c) => _cardToMap(c))
          .toList(),
      'playerPicks': cardDraw.playerPicks.map(
        (position, card) => MapEntry(
          position.toString(),
          card != null ? _cardToMap(card) : null,
        ),
      ),
      'isComplete': cardDraw.isComplete,
      'winningPosition': cardDraw.winningPosition,
      'winningTeam': cardDraw.winningTeam,
    };
  }

  /// Convert CardModel to Firestore map
  Map<String, dynamic> _cardToMap(CardModel card) {
    return {
      'suit': card.suit.name,
      'rank': card.rank.name,
    };
  }

  /// Convert Firestore map to CardDrawModel
  CardDrawModel _cardDrawFromMap(Map<String, dynamic> map) {
    final availableCards = (map['availableCards'] as List<dynamic>)
        .map((c) => _cardFromMap(c as Map<String, dynamic>))
        .toList();

    final playerPicksMap = map['playerPicks'] as Map<String, dynamic>;
    final playerPicks = <int, CardModel?>{};

    for (int i = 0; i < 4; i++) {
      final cardMap = playerPicksMap[i.toString()];
      playerPicks[i] = cardMap != null
          ? _cardFromMap(cardMap as Map<String, dynamic>)
          : null;
    }

    return CardDrawModel(
      availableCards: availableCards,
      playerPicks: playerPicks,
      isComplete: map['isComplete'] as bool,
      winningPosition: map['winningPosition'] as int?,
      winningTeam: map['winningTeam'] as int?,
    );
  }

  /// Convert Firestore map to CardModel
  CardModel _cardFromMap(Map<String, dynamic> map) {
    return CardModel(
      suit: CardSuit.values.firstWhere((e) => e.name == map['suit']),
      rank: CardRank.values.firstWhere((e) => e.name == map['rank']),
    );
  }

  /// Convert Firestore document to LobbyModel
  LobbyModel _lobbyFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final playersData = data['players'] as List<dynamic>? ?? [];
    final players = playersData.map((p) {
      final playerMap = p as Map<String, dynamic>;
      return PlayerSlot(
        position: playerMap['position'] as int,
        userId: playerMap['userId'] as String?,
        username: playerMap['username'] as String?,
        displayName: playerMap['displayName'] as String?,
        isBot: playerMap['isBot'] as bool? ?? false,
        isReady: playerMap['isReady'] as bool? ?? false,
      );
    }).toList();

    final cardDrawData = data['cardDraw'] as Map<String, dynamic>?;
    final cardDraw = cardDrawData != null
        ? _cardDrawFromMap(cardDrawData)
        : null;

    // Handle playerSuitClaims - convert string keys to int
    final playerSuitClaimsData = data['playerSuitClaims'] as Map<String, dynamic>?;
    final playerSuitClaims = <int, List<String>>{};
    if (playerSuitClaimsData != null) {
      playerSuitClaimsData.forEach((key, value) {
        playerSuitClaims[int.parse(key)] = List<String>.from(value as List);
      });
    }

    return LobbyModel(
      id: doc.id,
      hostUserId: data['hostUserId'] as String,
      hostUsername: data['hostUsername'] as String,
      code: data['code'] as String,
      status: LobbyStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => LobbyStatus.waiting,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      players: players,
      gameId: data['gameId'] as String?,
      team0Name: data['team0Name'] as String? ?? 'Team 1',
      team1Name: data['team1Name'] as String? ?? 'Team 2',
      team0EditingBy: data['team0EditingBy'] as String?,
      team1EditingBy: data['team1EditingBy'] as String?,
      cardDrawStarted: data['cardDrawStarted'] as bool? ?? false,
      cardDraw: cardDraw,
    );
  }
}
