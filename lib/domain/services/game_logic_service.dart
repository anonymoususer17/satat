import 'dart:math';
import '../../core/constants/game_constants.dart';
import '../../data/models/card_model.dart';
import '../../data/models/trick_model.dart';
import '../../data/models/game_model.dart';

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
  /// Returns null if valid, or error message if invalid
  String? validateCardPlay({
    required CardModel card,
    required GamePlayer player,
    required TrickModel trick,
    required CardSuit trumpSuit,
  }) {
    // Check if player has the card
    if (!player.hand.any((c) => c.id == card.id)) {
      return 'You do not have this card';
    }

    // If first card of trick, any card is valid
    if (trick.cardsPlayed.isEmpty) {
      return null;
    }

    final leadSuit = trick.leadSuit!;

    // H2 can always be played
    if (card.isHeart2) {
      return null;
    }

    // Check if H2 was led (special rule: must play trump if you have it)
    final h2Led = trick.cardsPlayed.first.card.isHeart2;
    if (h2Led) {
      // Must play trump if you have trump
      final hasTrump = player.hand.any((c) => c.suit == trumpSuit && !c.isHeart2);
      if (hasTrump && card.suit != trumpSuit) {
        return 'When H2 is led, you must play trump if you have it';
      }
      return null;
    }

    // Normal following suit rules
    final hasLeadSuit = player.hand.any((c) => c.suit == leadSuit);

    // If player has lead suit, must play it (unless playing H2)
    if (hasLeadSuit && card.suit != leadSuit) {
      return 'You must follow suit if possible';
    }

    return null;
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
  List<CardModel> getValidCards({
    required GamePlayer player,
    required TrickModel trick,
    required CardSuit trumpSuit,
  }) {
    final validCards = <CardModel>[];

    for (final card in player.hand) {
      final error = validateCardPlay(
        card: card,
        player: player,
        trick: trick,
        trumpSuit: trumpSuit,
      );
      if (error == null) {
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
}
