import 'package:freezed_annotation/freezed_annotation.dart';
import 'card_model.dart';

part 'card_draw_model.freezed.dart';
part 'card_draw_model.g.dart';

/// Model for card draw phase where players pick cards to determine starting team
@freezed
class CardDrawModel with _$CardDrawModel {
  const factory CardDrawModel({
    required List<CardModel> availableCards, // Remaining cards that can be picked
    required Map<int, CardModel?> playerPicks, // position -> picked card (null if not picked)
    required bool isComplete, // All 4 players have picked
    int? winningPosition, // Position of player with highest card
    int? winningTeam, // 0 or 1
  }) = _CardDrawModel;

  factory CardDrawModel.fromJson(Map<String, dynamic> json) =>
      _$CardDrawModelFromJson(json);
}
