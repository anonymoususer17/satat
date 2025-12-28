import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

/// Card suits in Satat
enum CardSuit {
  hearts,
  diamonds,
  clubs,
  spades;

  String get displayName {
    switch (this) {
      case CardSuit.hearts:
        return 'Hearts';
      case CardSuit.diamonds:
        return 'Diamonds';
      case CardSuit.clubs:
        return 'Clubs';
      case CardSuit.spades:
        return 'Spades';
    }
  }

  String get symbol {
    switch (this) {
      case CardSuit.hearts:
        return '♥';
      case CardSuit.diamonds:
        return '♦';
      case CardSuit.clubs:
        return '♣';
      case CardSuit.spades:
        return '♠';
    }
  }

  bool get isRed => this == CardSuit.hearts || this == CardSuit.diamonds;
}

/// Card ranks in Satat
enum CardRank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace;

  String get displayName {
    switch (this) {
      case CardRank.two:
        return '2';
      case CardRank.three:
        return '3';
      case CardRank.four:
        return '4';
      case CardRank.five:
        return '5';
      case CardRank.six:
        return '6';
      case CardRank.seven:
        return '7';
      case CardRank.eight:
        return '8';
      case CardRank.nine:
        return '9';
      case CardRank.ten:
        return '10';
      case CardRank.jack:
        return 'J';
      case CardRank.queen:
        return 'Q';
      case CardRank.king:
        return 'K';
      case CardRank.ace:
        return 'A';
    }
  }

  /// Numeric value for comparison (except H2 which is handled specially)
  int get value {
    switch (this) {
      case CardRank.two:
        return 2;
      case CardRank.three:
        return 3;
      case CardRank.four:
        return 4;
      case CardRank.five:
        return 5;
      case CardRank.six:
        return 6;
      case CardRank.seven:
        return 7;
      case CardRank.eight:
        return 8;
      case CardRank.nine:
        return 9;
      case CardRank.ten:
        return 10;
      case CardRank.jack:
        return 11;
      case CardRank.queen:
        return 12;
      case CardRank.king:
        return 13;
      case CardRank.ace:
        return 14;
    }
  }

  /// Check if this is a picture card (for trump selection rule)
  bool get isPicture => this == CardRank.jack || this == CardRank.queen || this == CardRank.king;
}

/// Represents a playing card in Satat
@freezed
class CardModel with _$CardModel {
  const CardModel._();

  const factory CardModel({
    required CardSuit suit,
    required CardRank rank,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

  /// Check if this is the special Heart 2 card
  bool get isHeart2 => suit == CardSuit.hearts && rank == CardRank.two;

  /// Get unique identifier for this card (e.g., "hearts_two")
  String get id => '${suit.name}_${rank.name}';

  /// Get display string (e.g., "2♥")
  String get displayString => '${rank.displayName}${suit.symbol}';

  /// Compare cards for trick winner determination
  /// Returns positive if this card beats otherCard in the given context
  /// (trumpSuit is the current trump suit, leadSuit is the suit that was led)
  int compareForTrick({
    required CardModel otherCard,
    required CardSuit trumpSuit,
    required CardSuit leadSuit,
  }) {
    // H2 always wins
    if (isHeart2) return 1;
    if (otherCard.isHeart2) return -1;

    // Both trump cards
    if (suit == trumpSuit && otherCard.suit == trumpSuit) {
      return rank.value.compareTo(otherCard.rank.value);
    }

    // This is trump, other is not
    if (suit == trumpSuit) return 1;
    if (otherCard.suit == trumpSuit) return -1;

    // Both same suit (and both are lead suit or neither is)
    if (suit == otherCard.suit) {
      return rank.value.compareTo(otherCard.rank.value);
    }

    // This is lead suit, other is not
    if (suit == leadSuit) return 1;
    if (otherCard.suit == leadSuit) return -1;

    // Neither is trump or lead suit, compare by rank
    return rank.value.compareTo(otherCard.rank.value);
  }

  /// Create a full deck of 52 cards
  static List<CardModel> createDeck() {
    final deck = <CardModel>[];
    for (final suit in CardSuit.values) {
      for (final rank in CardRank.values) {
        deck.add(CardModel(suit: suit, rank: rank));
      }
    }
    return deck;
  }
}
