import 'dart:math';
import '../../core/constants/game_constants.dart';
import '../../data/models/card_model.dart';
import '../../data/models/trick_model.dart';
import '../../data/models/game_model.dart';

/// Status of a card play validation
enum CardPlayStatus {
  valid, // Card follows all rules
  invalidCheating, // Card breaks rules but can be played (cheating)
  forbidden, // Card truly cannot be played (player doesn't have it)
}

/// Result of card play validation
class CardPlayValidation {
  final CardPlayStatus status;
  final String? errorMessage;
  final CardSuit? claimedNotToHave; // Which suit player claimed not to have

  CardPlayValidation({
    required this.status,
    this.errorMessage,
    this.claimedNotToHave,
  });

  factory CardPlayValidation.valid() => CardPlayValidation(
        status: CardPlayStatus.valid,
      );

  factory CardPlayValidation.forbidden(String message) => CardPlayValidation(
        status: CardPlayStatus.forbidden,
        errorMessage: message,
      );

  factory CardPlayValidation.cheating(String message, CardSuit claimedSuit) =>
      CardPlayValidation(
        status: CardPlayStatus.invalidCheating,
        errorMessage: message,
        claimedNotToHave: claimedSuit,
      );

  bool get isPlayable => status != CardPlayStatus.forbidden;
  bool get isCheating => status == CardPlayStatus.invalidCheating;
}

/// Service containing all game logic and rules for Satat
class GameLogicService {
  final Random _random = Random();

  /// Shuffle and deal cards to players
  /// Returns updated players with dealt cards
  List<GamePlayer> dealCards(List<GamePlayer> players, int dealerPosition) {
    // Create and shuffle deck
    final deck = CardModel.createDeck();
    deck.shuffle(_random);

    // Deal cards to each player (13 cards each)
    final updatedPlayers = <GamePlayer>[];
    for (int i = 0; i < GameConstants.totalPlayers; i++) {
      final player = players[i];
      final startIndex = i * GameConstants.cardsPerPlayer;
      final endIndex = startIndex + GameConstants.cardsPerPlayer;
      final hand = deck.sublist(startIndex, endIndex);

      updatedPlayers.add(player.copyWith(hand: hand));
    }

    return updatedPlayers;
  }

  /// Get first 5 cards for trump maker to view
  List<CardModel> getFirstFiveCards(GamePlayer trumpMaker) {
    if (trumpMaker.hand.length < 5) {
      throw Exception('Trump maker must have at least 5 cards');
    }
    return trumpMaker.hand.sublist(0, 5);
  }

  /// Get last 4 cards for trump selection (if deferred)
  List<CardModel> getLastFourCards(GamePlayer trumpMaker) {
    if (trumpMaker.hand.length < 13) {
      throw Exception('Trump maker must have 13 cards');
    }
    return trumpMaker.hand.sublist(9, 13);
  }

  /// Check if first 5 cards have any picture cards (J, Q, K)
  bool hasPictureCards(List<CardModel> cards) {
    return cards.any((card) => card.rank.isPicture);
  }

  /// Validate if a card can be played given the current trick state
  /// Returns CardPlayValidation with status and details
  CardPlayValidation validateCardPlay({
    required CardModel card,
    required GamePlayer player,
    required TrickModel trick,
    required CardSuit trumpSuit,
    required Map<int, List<String>> playerSuitClaims,
  }) {
    // Check if player has the card (truly forbidden)
    if (!player.hand.any((c) => c.id == card.id)) {
      return CardPlayValidation.forbidden('You do not have this card');
    }

    // Check if playing this card would expose previous cheat
    final playerClaims = playerSuitClaims[player.position] ?? [];
    if (playerClaims.contains(card.suit.name)) {
      // Player previously claimed not to have this suit, now playing it
      // This is auto-detected but still allow (they're doubling down on cheat)
      // The callout mechanism will catch this
    }

    // If first card of trick, any card is valid
    if (trick.cardsPlayed.isEmpty) {
      return CardPlayValidation.valid();
    }

    final leadSuit = trick.leadSuit!;

    // H2 can always be played
    if (card.isHeart2) {
      return CardPlayValidation.valid();
    }

    // Check if H2 was led (special rule: must play trump if you have it)
    final h2Led = trick.cardsPlayed.first.card.isHeart2;
    if (h2Led) {
      // Must play trump if you have trump
      final hasTrump = player.hand.any((c) => c.suit == trumpSuit && !c.isHeart2);
      if (hasTrump && card.suit != trumpSuit) {
        // This is cheating - they have trump but not playing it
        return CardPlayValidation.cheating(
          'When H2 is led, you must play trump if you have it',
          trumpSuit,
        );
      }
      return CardPlayValidation.valid();
    }

    // Normal following suit rules
    final hasLeadSuit = player.hand.any((c) => c.suit == leadSuit);

    // If player has lead suit, must play it (unless playing H2)
    if (hasLeadSuit && card.suit != leadSuit) {
      // This is cheating - claiming not to have lead suit
      return CardPlayValidation.cheating(
        'You must follow suit if possible',
        leadSuit,
      );
    }

    return CardPlayValidation.valid();
  }

  /// Determine the winner of a completed trick
  /// Returns the position of the winning player
  int determineTrickWinner({
    required TrickModel trick,
    required CardSuit trumpSuit,
  }) {
    if (!trick.isComplete) {
      throw Exception('Trick is not complete');
    }

    final leadSuit = trick.leadSuit!;
    PlayedCard winningPlay = trick.cardsPlayed.first;

    for (int i = 1; i < trick.cardsPlayed.length; i++) {
      final currentPlay = trick.cardsPlayed[i];
      final comparison = currentPlay.card.compareForTrick(
        otherCard: winningPlay.card,
        trumpSuit: trumpSuit,
        leadSuit: leadSuit,
      );

      if (comparison > 0) {
        winningPlay = currentPlay;
      }
    }

    return winningPlay.position;
  }

  /// Check if a team has won the game
  /// Returns GameResult if game is over, null otherwise
  GameResult? checkGameWinner({
    required int team0Tricks,
    required int team1Tricks,
  }) {
    // Check for 13-0 perfect win
    if (team0Tricks == GameConstants.perfectWinTricks) {
      return GameResult(
        winningTeam: 0,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.resultPerfectWin,
      );
    }
    if (team1Tricks == GameConstants.perfectWinTricks) {
      return GameResult(
        winningTeam: 1,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.resultPerfectWin,
      );
    }

    // Check for 7-0 win (team can choose to continue)
    // Note: This is handled in the UI - team chooses whether to continue
    // For now, we just check if 7 tricks won and return result
    if (team0Tricks == GameConstants.tricksToWin && team1Tricks == 0) {
      return GameResult(
        winningTeam: 0,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.result7to0Win,
      );
    }
    if (team1Tricks == GameConstants.tricksToWin && team0Tricks == 0) {
      return GameResult(
        winningTeam: 1,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.result7to0Win,
      );
    }

    // Check for normal win (first to 7 tricks)
    if (team0Tricks >= GameConstants.tricksToWin) {
      return GameResult(
        winningTeam: 0,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.resultNormalWin,
      );
    }
    if (team1Tricks >= GameConstants.tricksToWin) {
      return GameResult(
        winningTeam: 1,
        team0Tricks: team0Tricks,
        team1Tricks: team1Tricks,
        resultType: GameConstants.resultNormalWin,
      );
    }

    return null;
  }

  /// Get all valid cards a player can play for the current trick
  /// Only returns truly valid cards (not cheating ones)
  List<CardModel> getValidCards({
    required GamePlayer player,
    required TrickModel trick,
    required CardSuit trumpSuit,
    required Map<int, List<String>> playerSuitClaims,
  }) {
    final validCards = <CardModel>[];

    for (final card in player.hand) {
      final validation = validateCardPlay(
        card: card,
        player: player,
        trick: trick,
        trumpSuit: trumpSuit,
        playerSuitClaims: playerSuitClaims,
      );
      // Only truly valid cards, not cheating ones
      if (validation.status == CardPlayStatus.valid) {
        validCards.add(card);
      }
    }

    return validCards;
  }

  /// Create a new trick
  TrickModel createTrick({
    required int trickNumber,
    required int leadPosition,
  }) {
    return TrickModel.create(
      trickNumber: trickNumber,
      leadPosition: leadPosition,
    );
  }

  /// Add a played card to the current trick
  TrickModel addCardToTrick({
    required TrickModel trick,
    required int position,
    required CardModel card,
  }) {
    final updatedCards = List<PlayedCard>.from(trick.cardsPlayed);
    updatedCards.add(PlayedCard(position: position, card: card));

    return trick.copyWith(cardsPlayed: updatedCards);
  }

  /// Complete a trick by determining the winner
  TrickModel completeTrick({
    required TrickModel trick,
    required CardSuit trumpSuit,
  }) {
    if (!trick.isComplete) {
      throw Exception('Cannot complete trick - not all cards played');
    }

    final winnerPosition = determineTrickWinner(trick: trick, trumpSuit: trumpSuit);
    final winningCard = trick.cardsPlayed
        .firstWhere((p) => p.position == winnerPosition)
        .card;

    return trick.copyWith(
      winnerPosition: winnerPosition,
      winningCard: winningCard,
    );
  }

  /// Remove a card from player's hand
  GamePlayer removeCardFromHand({
    required GamePlayer player,
    required CardModel card,
  }) {
    final updatedHand = player.hand.where((c) => c.id != card.id).toList();
    return player.copyWith(hand: updatedHand);
  }

  /// Update trick counts after a trick is won
  Map<String, int> updateTrickCounts({
    required int team0Tricks,
    required int team1Tricks,
    required int winningTeam,
  }) {
    return {
      'team0Tricks': winningTeam == 0 ? team0Tricks + 1 : team0Tricks,
      'team1Tricks': winningTeam == 1 ? team1Tricks + 1 : team1Tricks,
    };
  }

  /// Check if a team has cheated
  /// Returns position of cheater if found, null otherwise
  int? detectCheat({
    required int team,
    required List<GamePlayer> players,
    required Map<int, List<String>> playerSuitClaims,
  }) {
    // Get team members (team 0 = positions 0 & 2, team 1 = positions 1 & 3)
    final teamMembers = players.where((p) => p.team == team).toList();

    for (final player in teamMembers) {
      final claims = playerSuitClaims[player.position] ?? [];

      // Check each claimed suit
      for (final suitName in claims) {
        final claimedSuit =
            CardSuit.values.firstWhere((s) => s.name == suitName);

        // Check if player currently has this suit in hand
        final hasClaimedSuit = player.hand.any((card) => card.suit == claimedSuit);

        if (hasClaimedSuit) {
          // CHEAT! Player claimed not to have this suit but has it
          return player.position;
        }
      }
    }

    return null; // No cheat detected
  }
}
