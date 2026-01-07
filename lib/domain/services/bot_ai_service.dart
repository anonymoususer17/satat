import 'dart:math';
import '../../data/models/card_model.dart';
import '../../data/models/trick_model.dart';
import '../../data/models/game_model.dart';
import 'game_logic_service.dart';

/// Basic rule-based AI for bot players
class BotAIService {
  final GameLogicService _gameLogic;
  final Random _random = Random();

  BotAIService({GameLogicService? gameLogic})
      : _gameLogic = gameLogic ?? GameLogicService();

  /// Select trump suit for bot
  CardSuit selectTrumpSuit(List<CardModel> firstFive) {
    // Count cards by suit
    final suitCounts = <CardSuit, int>{};
    final suitStrength = <CardSuit, int>{};

    for (final card in firstFive) {
      suitCounts[card.suit] = (suitCounts[card.suit] ?? 0) + 1;
      suitStrength[card.suit] = (suitStrength[card.suit] ?? 0) + card.rank.value;
    }

    // Prefer suit with most cards, then highest total strength
    CardSuit? bestSuit;
    int maxCount = 0;
    int maxStrength = 0;

    for (final entry in suitCounts.entries) {
      final count = entry.value;
      final strength = suitStrength[entry.key] ?? 0;

      if (count > maxCount || (count == maxCount && strength > maxStrength)) {
        bestSuit = entry.key;
        maxCount = count;
        maxStrength = strength;
      }
    }

    return bestSuit ?? CardSuit.hearts;
  }

  /// Decide whether bot should defer to last 4 cards
  bool shouldDeferTrumpSelection(List<CardModel> firstFive) {
    // Defer if no picture cards (required for reshuffle anyway)
    final hasPictures = firstFive.any((card) => card.rank.isPicture);
    if (!hasPictures) return false;

    // Count cards by suit
    final suitCounts = <CardSuit, int>{};
    for (final card in firstFive) {
      suitCounts[card.suit] = (suitCounts[card.suit] ?? 0) + 1;
    }

    // If no suit has more than 1 card, consider deferring (weak hand)
    final maxCount = suitCounts.values.fold<int>(0, (max, count) => count > max ? count : max);
    if (maxCount <= 1) {
      return _random.nextDouble() < 0.5; // 50% chance to defer
    }

    return false;
  }

  /// Select a card to play for bot
  CardModel selectCardToPlay({
    required GamePlayer bot,
    required TrickModel trick,
    required CardSuit trumpSuit,
    required int botTeam,
    required Map<int, List<String>> playerSuitClaims,
  }) {
    // Get all valid cards bot can play
    final validCards = _gameLogic.getValidCards(
      player: bot,
      trick: trick,
      trumpSuit: trumpSuit,
      playerSuitClaims: playerSuitClaims,
    );

    if (validCards.isEmpty) {
      // Should never happen, but just in case
      return bot.hand.first;
    }

    if (validCards.length == 1) {
      return validCards.first;
    }

    // If leading the trick
    if (trick.cardsPlayed.isEmpty) {
      return _selectLeadCard(validCards, trumpSuit, botTeam);
    }

    // If following in trick
    return _selectFollowCard(
      validCards,
      trick,
      trumpSuit,
      botTeam,
      bot.hand,
    );
  }

  /// Select card when leading a trick
  CardModel _selectLeadCard(
    List<CardModel> validCards,
    CardSuit trumpSuit,
    int botTeam,
  ) {
    // Prefer playing H2 if we have it (always wins)
    final h2 = validCards.firstWhere(
      (card) => card.isHeart2,
      orElse: () => validCards.first,
    );
    if (h2.isHeart2) {
      return h2;
    }

    // Prefer leading with high trump
    final trumpCards = validCards.where((c) => c.suit == trumpSuit).toList();
    if (trumpCards.isNotEmpty) {
      // Lead with highest trump
      trumpCards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
      return trumpCards.first;
    }

    // Otherwise, lead with a medium-high card (not lowest, not highest)
    validCards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    if (validCards.length >= 3) {
      return validCards[1]; // Second highest
    }

    return validCards.first;
  }

  /// Select card when following in a trick
  CardModel _selectFollowCard(
    List<CardModel> validCards,
    TrickModel trick,
    CardSuit trumpSuit,
    int botTeam,
    List<CardModel> fullHand,
  ) {
    final leadSuit = trick.leadSuit!;

    // Determine current winning card
    CardModel? currentWinner;
    int? currentWinnerTeam;

    if (trick.cardsPlayed.isNotEmpty) {
      currentWinner = trick.cardsPlayed.first.card;
      currentWinnerTeam = trick.cardsPlayed.first.position % 2;

      for (int i = 1; i < trick.cardsPlayed.length; i++) {
        final playedCard = trick.cardsPlayed[i];
        if (currentWinner != null) {
          final comparison = playedCard.card.compareForTrick(
            otherCard: currentWinner,
            trumpSuit: trumpSuit,
            leadSuit: leadSuit,
          );

          if (comparison > 0) {
            currentWinner = playedCard.card;
            currentWinnerTeam = playedCard.position % 2;
          }
        }
      }
    }

    // If partner is winning, play lowest valid card
    if (currentWinnerTeam != null && currentWinnerTeam == botTeam) {
      validCards.sort((a, b) => a.rank.value.compareTo(b.rank.value));
      return validCards.first;
    }

    // Try to win the trick
    // Find cards that can beat current winner
    final winningCards = validCards.where((card) {
      final winner = currentWinner;
      if (winner == null) return true;
      return card.compareForTrick(
            otherCard: winner,
            trumpSuit: trumpSuit,
            leadSuit: leadSuit,
          ) >
          0;
    }).toList();

    if (winningCards.isNotEmpty) {
      // Play the lowest card that can win
      winningCards.sort((a, b) => a.rank.value.compareTo(b.rank.value));
      return winningCards.first;
    }

    // Can't win, play lowest card
    validCards.sort((a, b) => a.rank.value.compareTo(b.rank.value));
    return validCards.first;
  }

  /// Decide if bot should continue after 7-0 win
  bool shouldContinueAfter7_0(GameModel game, int botTeam) {
    // For now, always continue to try for perfect win
    // TODO: Make this more strategic based on hand strength
    return true;
  }

  /// Select a random card for card draw phase
  CardModel selectCardForDraw(List<CardModel> availableCards) {
    if (availableCards.isEmpty) {
      throw Exception('No cards available to select');
    }
    return availableCards[_random.nextInt(availableCards.length)];
  }
}
