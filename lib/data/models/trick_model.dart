import 'package:freezed_annotation/freezed_annotation.dart';
import 'card_model.dart';

part 'trick_model.freezed.dart';
part 'trick_model.g.dart';

/// Represents a card played by a player in a trick
@freezed
class PlayedCard with _$PlayedCard {
  const factory PlayedCard({
    required int position,
    required CardModel card,
  }) = _PlayedCard;

  factory PlayedCard.fromJson(Map<String, dynamic> json) => _$PlayedCardFromJson(json);
}

/// Represents a single trick in the game
@freezed
class TrickModel with _$TrickModel {
  const TrickModel._();

  const factory TrickModel({
    required int trickNumber, // 0-12 (13 tricks total)
    required int leadPosition, // Position that led this trick
    required List<PlayedCard> cardsPlayed, // Cards played so far (0-4)
    int? winnerPosition, // Position that won this trick (null if in progress)
    CardModel? winningCard, // Card that won the trick (null if in progress)
  }) = _TrickModel;

  factory TrickModel.fromJson(Map<String, dynamic> json) => _$TrickModelFromJson(json);

  /// Check if trick is complete (all 4 players played)
  bool get isComplete => cardsPlayed.length == 4;

  /// Get the suit that was led
  CardSuit? get leadSuit {
    if (cardsPlayed.isEmpty) return null;
    return cardsPlayed.first.card.suit;
  }

  /// Get the next position to play
  int? get nextPosition {
    if (isComplete) return null;

    // Calculate next position clockwise from lead
    final playedCount = cardsPlayed.length;
    return (leadPosition + playedCount) % 4;
  }

  /// Create an empty trick
  factory TrickModel.create({
    required int trickNumber,
    required int leadPosition,
  }) {
    return TrickModel(
      trickNumber: trickNumber,
      leadPosition: leadPosition,
      cardsPlayed: [],
      winnerPosition: null,
      winningCard: null,
    );
  }
}
