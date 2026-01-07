// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerSlotImpl _$$PlayerSlotImplFromJson(Map<String, dynamic> json) =>
    _$PlayerSlotImpl(
      position: (json['position'] as num).toInt(),
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      displayName: json['displayName'] as String?,
      isBot: json['isBot'] as bool,
      isReady: json['isReady'] as bool,
    );

Map<String, dynamic> _$$PlayerSlotImplToJson(_$PlayerSlotImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'isBot': instance.isBot,
      'isReady': instance.isReady,
    };

_$LobbyModelImpl _$$LobbyModelImplFromJson(Map<String, dynamic> json) =>
    _$LobbyModelImpl(
      id: json['id'] as String,
      hostUserId: json['hostUserId'] as String,
      hostUsername: json['hostUsername'] as String,
      code: json['code'] as String,
      status: $enumDecode(_$LobbyStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameId: json['gameId'] as String?,
      team0Name: json['team0Name'] as String? ?? 'Team 1',
      team1Name: json['team1Name'] as String? ?? 'Team 2',
      team0EditingBy: json['team0EditingBy'] as String?,
      team1EditingBy: json['team1EditingBy'] as String?,
      cardDrawStarted: json['cardDrawStarted'] as bool? ?? false,
      cardDraw: json['cardDraw'] == null
          ? null
          : CardDrawModel.fromJson(json['cardDraw'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LobbyModelImplToJson(_$LobbyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostUserId': instance.hostUserId,
      'hostUsername': instance.hostUsername,
      'code': instance.code,
      'status': _$LobbyStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'players': instance.players,
      'gameId': instance.gameId,
      'team0Name': instance.team0Name,
      'team1Name': instance.team1Name,
      'team0EditingBy': instance.team0EditingBy,
      'team1EditingBy': instance.team1EditingBy,
      'cardDrawStarted': instance.cardDrawStarted,
      'cardDraw': instance.cardDraw,
    };

const _$LobbyStatusEnumMap = {
  LobbyStatus.waiting: 'waiting',
  LobbyStatus.ready: 'ready',
  LobbyStatus.inGame: 'inGame',
  LobbyStatus.completed: 'completed',
};
