import 'package:freezed_annotation/freezed_annotation.dart';
import 'card_draw_model.dart';

part 'lobby_model.freezed.dart';
part 'lobby_model.g.dart';

/// Lobby status
enum LobbyStatus {
  waiting,
  ready,
  inGame,
  completed,
}

/// Player slot in lobby (positions 0-3)
@freezed
class PlayerSlot with _$PlayerSlot {
  const factory PlayerSlot({
    required int position, // 0-3
    String? userId,
    String? username,
    String? displayName,
    required bool isBot,
    required bool isReady,
  }) = _PlayerSlot;

  factory PlayerSlot.fromJson(Map<String, dynamic> json) =>
      _$PlayerSlotFromJson(json);
}

/// Lobby model
@freezed
class LobbyModel with _$LobbyModel {
  const factory LobbyModel({
    required String id,
    required String hostUserId,
    required String hostUsername,
    required String code, // 6-digit invite code
    required LobbyStatus status,
    required DateTime createdAt,
    required List<PlayerSlot> players, // Always 4 slots
    String? gameId, // Set when game starts
    @Default('Team 1') String team0Name,
    @Default('Team 2') String team1Name,
    String? team0EditingBy, // userId of player currently editing team 0 name
    String? team1EditingBy, // userId of player currently editing team 1 name
    @Default(false) bool cardDrawStarted, // Card draw phase initiated
    CardDrawModel? cardDraw, // Card draw state (null until started)
  }) = _LobbyModel;

  factory LobbyModel.fromJson(Map<String, dynamic> json) =>
      _$LobbyModelFromJson(json);
}

/// Helper to create empty lobby
LobbyModel createEmptyLobby({
  required String id,
  required String hostUserId,
  required String hostUsername,
  required String code,
}) {
  return LobbyModel(
    id: id,
    hostUserId: hostUserId,
    hostUsername: hostUsername,
    code: code,
    status: LobbyStatus.waiting,
    createdAt: DateTime.now(),
    gameId: null,
    players: [
      PlayerSlot(
        position: 0,
        userId: hostUserId,
        username: hostUsername,
        displayName: hostUsername,
        isBot: false,
        isReady: false,
      ),
      const PlayerSlot(position: 1, isBot: false, isReady: false),
      const PlayerSlot(position: 2, isBot: false, isReady: false),
      const PlayerSlot(position: 3, isBot: false, isReady: false),
    ],
  );
}
