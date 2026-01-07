import 'dart:math';
import '../../data/models/card_model.dart';
import '../../data/models/card_draw_model.dart';

/// Service for card draw logic (determining starting team)
class CardDrawService {
  final Random _random = Random();

  /// Initialize card draw with shuffled 52 cards
  CardDrawModel initializeCardDraw() {
    // Create and shuffle full deck
    final deck = CardModel.createDeck();
    deck.shuffle(_random);

    return CardDrawModel(
      availableCards: deck,
      playerPicks: {
        0: null,
        1: null,
        2: null,
        3: null,
      },
      isComplete: false,
      winningPosition: null,
      winningTeam: null,
    );
  }

  /// Determine winner from all picks
  /// Returns (winningPosition, winningTeam)
  (int, int) determineWinner(Map<int, CardModel> allPicks, List<dynamic> players) {
    if (allPicks.length != 4) {
      throw Exception('All 4 players must pick before determining winner');
    }

    // Find highest card
    int winningPosition = 0;
    CardModel winningCard = allPicks[0]!;

    for (int i = 1; i < 4; i++) {
      final currentCard = allPicks[i]!;

      // Compare cards: higher rank wins, ties broken by suit priority
      final comparison = _compareCards(currentCard, winningCard);

      if (comparison > 0) {
        winningPosition = i;
        winningCard = currentCard;
      }
    }

    // Determine team from position (0 & 2 = team 0, 1 & 3 = team 1)
    final winningTeam = winningPosition % 2;

    return (winningPosition, winningTeam);
  }

  /// Compare two cards for card draw
  /// Returns positive if card1 > card2, negative if card1 < card2, 0 if equal
  /// Suit priority for ties: Spades > Hearts > Clubs > Diamonds
  int _compareCards(CardModel card1, CardModel card2) {
    // First compare by rank value
    final rankDiff = card1.rank.value - card2.rank.value;

    if (rankDiff != 0) {
      return rankDiff;
    }

    // Same rank, compare by suit priority
    return _getSuitPriority(card1.suit) - _getSuitPriority(card2.suit);
  }

  /// Get suit priority for tiebreaking
  /// Spades (4) > Hearts (3) > Clubs (2) > Diamonds (1)
  int _getSuitPriority(CardSuit suit) {
    switch (suit) {
      case CardSuit.spades:
        return 4;
      case CardSuit.hearts:
        return 3;
      case CardSuit.clubs:
        return 2;
      case CardSuit.diamonds:
        return 1;
    }
  }
}
