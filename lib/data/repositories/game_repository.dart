import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';
import '../models/trick_model.dart';
import '../models/game_model.dart';
import '../../domain/services/game_logic_service.dart';

/// Repository for game operations
class GameRepository {
  final FirebaseFirestore _firestore;
  final GameLogicService _gameLogic;

  GameRepository({
    FirebaseFirestore? firestore,
    GameLogicService? gameLogic,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _gameLogic = gameLogic ?? GameLogicService();

  /// Create a new game from a lobby
  Future<GameModel> createGame({
    required String lobbyId,
    required List<Map<String, dynamic>> lobbyPlayers,
    required int dealerPosition,
    String team0Name = 'Team 1',
    String team1Name = 'Team 2',
  }) async {
    try {
      final gameRef = _firestore.collection('games').doc();

      // Create initial game
      var game = createGameFromLobby(
        gameId: gameRef.id,
        lobbyId: lobbyId,
        lobbyPlayers: lobbyPlayers,
        dealerPosition: dealerPosition,
        team0Name: team0Name,
        team1Name: team1Name,
      );

      // Deal cards
      final dealtPlayers = _gameLogic.dealCards(game.players, dealerPosition);
      game = game.copyWith(players: dealtPlayers);

      // Get trump maker's first 5 cards
      final trumpMaker = game.getPlayerByPosition(game.trumpMakerPosition);
      final firstFive = _gameLogic.getFirstFiveCards(trumpMaker);
      game = game.copyWith(trumpMakerFirstFive: firstFive);

      // Save to Firestore
      await gameRef.set(_gameToFirestore(game));

      return game;
    } catch (e) {
      throw Exception('Failed to create game: ${e.toString()}');
    }
  }

  /// Get game by ID
  Future<GameModel> getGameById(String gameId) async {
    try {
      final doc = await _firestore.collection('games').doc(gameId).get();

      if (!doc.exists) {
        throw Exception('Game not found');
      }

      return _gameFromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get game: ${e.toString()}');
    }
  }

  /// Watch game changes (real-time)
  Stream<GameModel> watchGame(String gameId) {
    return _firestore
        .collection('games')
        .doc(gameId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Game not found');
      }
      return _gameFromFirestore(doc);
    });
  }

  /// Select trump suit
  Future<void> selectTrump({
    required String gameId,
    required CardSuit trumpSuit,
    required bool deferredToLastFour,
  }) async {
    try {
      final gameRef = _firestore.collection('games').doc(gameId);
      final gameDoc = await gameRef.get();

      if (!gameDoc.exists) {
        throw Exception('Game not found');
      }

      final game = _gameFromFirestore(gameDoc);

      if (game.phase != GamePhase.trumpSelection) {
        throw Exception('Game is not in trump selection phase');
      }

      // Create first trick
      final firstTrick = _gameLogic.createTrick(
        trickNumber: 0,
        leadPosition: (game.trumpMakerPosition + 1) % 4, // Player after trump maker leads
      );

      await gameRef.update({
        'trumpSuit': trumpSuit.name,
        'phase': GamePhase.playing.name,
        'currentTrick': _trickToMap(firstTrick),
        'trumpMakerLastFour': deferredToLastFour
            ? (game.trumpMakerLastFour?.map((c) => _cardToMap(c)).toList() ?? [])
            : null,
      });
    } catch (e) {
      throw Exception('Failed to select trump: ${e.toString()}');
    }
  }

  /// Play a card
  Future<void> playCard({
    required String gameId,
    String? userId,
    int? position,
    required CardModel card,
  }) async {
    try {
      if (userId == null && position == null) {
        throw Exception('Either userId or position must be provided');
      }

      final gameRef = _firestore.collection('games').doc(gameId);
      final gameDoc = await gameRef.get();

      if (!gameDoc.exists) {
        throw Exception('Game not found');
      }

      final game = _gameFromFirestore(gameDoc);

      if (game.phase != GamePhase.playing) {
        throw Exception('Game is not in playing phase');
      }

      if (game.currentTrick == null) {
        throw Exception('No active trick');
      }

      if (game.trumpSuit == null) {
        throw Exception('Trump not selected');
      }

      // Get player by userId or position
      final player = userId != null
          ? game.getPlayerByUserId(userId)
          : game.getPlayerByPosition(position!);

      if (player == null) {
        throw Exception('Player not found in game');
      }

      // Validate card play
      final error = _gameLogic.validateCardPlay(
        card: card,
        player: player,
        trick: game.currentTrick!,
        trumpSuit: game.trumpSuit!,
      );

      if (error != null) {
        throw Exception(error);
      }

      // Add card to trick
      var updatedTrick = _gameLogic.addCardToTrick(
        trick: game.currentTrick!,
        position: player.position,
        card: card,
      );

      // Remove card from player's hand
      final updatedPlayer = _gameLogic.removeCardFromHand(
        player: player,
        card: card,
      );
      final updatedPlayers = game.players.map((p) {
        return p.position == player.position ? updatedPlayer : p;
      }).toList();

      Map<String, dynamic> updateData = {
        'players': updatedPlayers.map((p) => _playerToMap(p)).toList(),
        'currentTrick': _trickToMap(updatedTrick),
      };

      // Check if trick is complete
      if (updatedTrick.isComplete) {
        // Determine winner
        updatedTrick = _gameLogic.completeTrick(
          trick: updatedTrick,
          trumpSuit: game.trumpSuit!,
        );

        // Update trick counts
        final winnerTeam = updatedTrick.winnerPosition! % 2;
        final trickCounts = _gameLogic.updateTrickCounts(
          team0Tricks: game.team0TricksWon,
          team1Tricks: game.team1TricksWon,
          winningTeam: winnerTeam,
        );

        // Add to completed tricks
        final completedTricks = [...game.completedTricks, updatedTrick];

        // Check for game winner
        final gameResult = _gameLogic.checkGameWinner(
          team0Tricks: trickCounts['team0Tricks']!,
          team1Tricks: trickCounts['team1Tricks']!,
        );

        updateData = {
          ...updateData,
          'currentTrick': _trickToMap(updatedTrick),
          'completedTricks': completedTricks.map((t) => _trickToMap(t)).toList(),
          'team0TricksWon': trickCounts['team0Tricks'],
          'team1TricksWon': trickCounts['team1Tricks'],
        };

        if (gameResult != null) {
          // Game over
          updateData['phase'] = GamePhase.ended.name;
          updateData['result'] = _resultToMap(gameResult);
          updateData['endedAt'] = FieldValue.serverTimestamp();
        } else if (completedTricks.length < 13) {
          // Create next trick
          final nextTrick = _gameLogic.createTrick(
            trickNumber: completedTricks.length,
            leadPosition: updatedTrick.winnerPosition!,
          );
          updateData['currentTrick'] = _trickToMap(nextTrick);
        }
      }

      await gameRef.update(updateData);
    } catch (e) {
      throw Exception('Failed to play card: ${e.toString()}');
    }
  }

  /// Request reshuffle (for trump selection)
  Future<void> requestReshuffle({
    required String gameId,
    required String userId,
  }) async {
    try {
      final gameRef = _firestore.collection('games').doc(gameId);
      final gameDoc = await gameRef.get();

      if (!gameDoc.exists) {
        throw Exception('Game not found');
      }

      final game = _gameFromFirestore(gameDoc);

      if (game.phase != GamePhase.trumpSelection) {
        throw Exception('Not in trump selection phase');
      }

      final player = game.getPlayerByUserId(userId);
      if (player == null || player.position != game.trumpMakerPosition) {
        throw Exception('Only trump maker can request reshuffle');
      }

      final reshuffleCount = game.reshuffleCount ?? 0;
      if (reshuffleCount >= 2) {
        throw Exception('Maximum reshuffles reached');
      }

      // Check if first 5 have no pictures
      if (_gameLogic.hasPictureCards(game.trumpMakerFirstFive ?? [])) {
        throw Exception('Cannot reshuffle - you have picture cards');
      }

      // Reshuffle and redeal
      final dealtPlayers = _gameLogic.dealCards(game.players, game.dealerPosition);
      final trumpMaker = dealtPlayers[game.trumpMakerPosition];
      final firstFive = _gameLogic.getFirstFiveCards(trumpMaker);

      await gameRef.update({
        'players': dealtPlayers.map((p) => _playerToMap(p)).toList(),
        'trumpMakerFirstFive': firstFive.map((c) => _cardToMap(c)).toList(),
        'reshuffleCount': reshuffleCount + 1,
      });
    } catch (e) {
      throw Exception('Failed to reshuffle: ${e.toString()}');
    }
  }

  /// Defer trump selection to last 4 cards
  Future<void> deferTrumpSelection({
    required String gameId,
    required String userId,
  }) async {
    try {
      final gameRef = _firestore.collection('games').doc(gameId);
      final gameDoc = await gameRef.get();

      if (!gameDoc.exists) {
        throw Exception('Game not found');
      }

      final game = _gameFromFirestore(gameDoc);

      if (game.phase != GamePhase.trumpSelection) {
        throw Exception('Not in trump selection phase');
      }

      final player = game.getPlayerByUserId(userId);
      if (player == null || player.position != game.trumpMakerPosition) {
        throw Exception('Only trump maker can defer');
      }

      // Get last 4 cards
      final lastFour = _gameLogic.getLastFourCards(player);

      await gameRef.update({
        'trumpMakerLastFour': lastFour.map((c) => _cardToMap(c)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to defer trump selection: ${e.toString()}');
    }
  }

  // Conversion methods

  Map<String, dynamic> _gameToFirestore(GameModel game) {
    return {
      'id': game.id,
      'lobbyId': game.lobbyId,
      'phase': game.phase.name,
      'players': game.players.map((p) => _playerToMap(p)).toList(),
      'dealerPosition': game.dealerPosition,
      'trumpMakerPosition': game.trumpMakerPosition,
      'trumpSuit': game.trumpSuit?.name,
      'currentTrick': game.currentTrick != null ? _trickToMap(game.currentTrick!) : null,
      'completedTricks': game.completedTricks.map((t) => _trickToMap(t)).toList(),
      'team0TricksWon': game.team0TricksWon,
      'team1TricksWon': game.team1TricksWon,
      'team0Name': game.team0Name,
      'team1Name': game.team1Name,
      'result': game.result != null ? _resultToMap(game.result!) : null,
      'createdAt': FieldValue.serverTimestamp(),
      'endedAt': game.endedAt,
      'trumpMakerFirstFive': game.trumpMakerFirstFive?.map((c) => _cardToMap(c)).toList(),
      'trumpMakerLastFour': game.trumpMakerLastFour?.map((c) => _cardToMap(c)).toList(),
      'reshuffleCount': game.reshuffleCount,
    };
  }

  Map<String, dynamic> _playerToMap(GamePlayer player) {
    return {
      'position': player.position,
      'userId': player.userId,
      'username': player.username,
      'displayName': player.displayName,
      'isBot': player.isBot,
      'hand': player.hand.map((c) => _cardToMap(c)).toList(),
    };
  }

  Map<String, dynamic> _cardToMap(CardModel card) {
    return {
      'suit': card.suit.name,
      'rank': card.rank.name,
    };
  }

  Map<String, dynamic> _trickToMap(TrickModel trick) {
    return {
      'trickNumber': trick.trickNumber,
      'leadPosition': trick.leadPosition,
      'cardsPlayed': trick.cardsPlayed.map((p) => {
            'position': p.position,
            'card': _cardToMap(p.card),
          }).toList(),
      'winnerPosition': trick.winnerPosition,
      'winningCard': trick.winningCard != null ? _cardToMap(trick.winningCard!) : null,
    };
  }

  Map<String, dynamic> _resultToMap(GameResult result) {
    return {
      'winningTeam': result.winningTeam,
      'team0Tricks': result.team0Tricks,
      'team1Tricks': result.team1Tricks,
      'resultType': result.resultType,
    };
  }

  GameModel _gameFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GameModel(
      id: doc.id,
      lobbyId: data['lobbyId'] as String,
      phase: GamePhase.values.firstWhere((e) => e.name == data['phase']),
      players: (data['players'] as List<dynamic>)
          .map((p) => _playerFromMap(p as Map<String, dynamic>))
          .toList(),
      dealerPosition: data['dealerPosition'] as int,
      trumpMakerPosition: data['trumpMakerPosition'] as int,
      trumpSuit: data['trumpSuit'] != null
          ? CardSuit.values.firstWhere((e) => e.name == data['trumpSuit'])
          : null,
      currentTrick: data['currentTrick'] != null
          ? _trickFromMap(data['currentTrick'] as Map<String, dynamic>)
          : null,
      completedTricks: (data['completedTricks'] as List<dynamic>? ?? [])
          .map((t) => _trickFromMap(t as Map<String, dynamic>))
          .toList(),
      team0TricksWon: data['team0TricksWon'] as int,
      team1TricksWon: data['team1TricksWon'] as int,
      team0Name: data['team0Name'] as String? ?? 'Team 1',
      team1Name: data['team1Name'] as String? ?? 'Team 2',
      result: data['result'] != null
          ? _resultFromMap(data['result'] as Map<String, dynamic>)
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
      trumpMakerFirstFive: (data['trumpMakerFirstFive'] as List<dynamic>?)
          ?.map((c) => _cardFromMap(c as Map<String, dynamic>))
          .toList(),
      trumpMakerLastFour: (data['trumpMakerLastFour'] as List<dynamic>?)
          ?.map((c) => _cardFromMap(c as Map<String, dynamic>))
          .toList(),
      reshuffleCount: data['reshuffleCount'] as int? ?? 0,
    );
  }

  GamePlayer _playerFromMap(Map<String, dynamic> map) {
    return GamePlayer(
      position: map['position'] as int,
      userId: map['userId'] as String?,
      username: map['username'] as String,
      displayName: map['displayName'] as String,
      isBot: map['isBot'] as bool,
      hand: (map['hand'] as List<dynamic>)
          .map((c) => _cardFromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }

  CardModel _cardFromMap(Map<String, dynamic> map) {
    return CardModel(
      suit: CardSuit.values.firstWhere((e) => e.name == map['suit']),
      rank: CardRank.values.firstWhere((e) => e.name == map['rank']),
    );
  }

  TrickModel _trickFromMap(Map<String, dynamic> map) {
    return TrickModel(
      trickNumber: map['trickNumber'] as int,
      leadPosition: map['leadPosition'] as int,
      cardsPlayed: (map['cardsPlayed'] as List<dynamic>)
          .map((p) => PlayedCard(
                position: p['position'] as int,
                card: _cardFromMap(p['card'] as Map<String, dynamic>),
              ))
          .toList(),
      winnerPosition: map['winnerPosition'] as int?,
      winningCard: map['winningCard'] != null
          ? _cardFromMap(map['winningCard'] as Map<String, dynamic>)
          : null,
    );
  }

  GameResult _resultFromMap(Map<String, dynamic> map) {
    return GameResult(
      winningTeam: map['winningTeam'] as int,
      team0Tricks: map['team0Tricks'] as int,
      team1Tricks: map['team1Tricks'] as int,
      resultType: map['resultType'] as String,
    );
  }
}
