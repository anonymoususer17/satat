// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamePlayerImpl _$$GamePlayerImplFromJson(Map<String, dynamic> json) =>
    _$GamePlayerImpl(
      position: (json['position'] as num).toInt(),
      userId: json['userId'] as String?,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      isBot: json['isBot'] as bool,
      hand: (json['hand'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GamePlayerImplToJson(_$GamePlayerImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'isBot': instance.isBot,
      'hand': instance.hand,
    };

_$GameResultImpl _$$GameResultImplFromJson(Map<String, dynamic> json) =>
    _$GameResultImpl(
      winningTeam: (json['winningTeam'] as num).toInt(),
      team0Tricks: (json['team0Tricks'] as num).toInt(),
      team1Tricks: (json['team1Tricks'] as num).toInt(),
      resultType: json['resultType'] as String,
    );

Map<String, dynamic> _$$GameResultImplToJson(_$GameResultImpl instance) =>
    <String, dynamic>{
      'winningTeam': instance.winningTeam,
      'team0Tricks': instance.team0Tricks,
      'team1Tricks': instance.team1Tricks,
      'resultType': instance.resultType,
    };

_$GameModelImpl _$$GameModelImplFromJson(Map<String, dynamic> json) =>
    _$GameModelImpl(
      id: json['id'] as String,
      lobbyId: json['lobbyId'] as String,
      phase: $enumDecode(_$GamePhaseEnumMap, json['phase']),
      players: (json['players'] as List<dynamic>)
          .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      dealerPosition: (json['dealerPosition'] as num).toInt(),
      trumpMakerPosition: (json['trumpMakerPosition'] as num).toInt(),
      trumpSuit: $enumDecodeNullable(_$CardSuitEnumMap, json['trumpSuit']),
      currentTrick: json['currentTrick'] == null
          ? null
          : TrickModel.fromJson(json['currentTrick'] as Map<String, dynamic>),
      completedTricks: (json['completedTricks'] as List<dynamic>)
          .map((e) => TrickModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      team0TricksWon: (json['team0TricksWon'] as num).toInt(),
      team1TricksWon: (json['team1TricksWon'] as num).toInt(),
      team0Name: json['team0Name'] as String? ?? 'Team 1',
      team1Name: json['team1Name'] as String? ?? 'Team 2',
      result: json['result'] == null
          ? null
          : GameResult.fromJson(json['result'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      trumpMakerFirstFive: (json['trumpMakerFirstFive'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trumpMakerLastFour: (json['trumpMakerLastFour'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reshuffleCount: (json['reshuffleCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GameModelImplToJson(_$GameModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lobbyId': instance.lobbyId,
      'phase': _$GamePhaseEnumMap[instance.phase]!,
      'players': instance.players,
      'dealerPosition': instance.dealerPosition,
      'trumpMakerPosition': instance.trumpMakerPosition,
      'trumpSuit': _$CardSuitEnumMap[instance.trumpSuit],
      'currentTrick': instance.currentTrick,
      'completedTricks': instance.completedTricks,
      'team0TricksWon': instance.team0TricksWon,
      'team1TricksWon': instance.team1TricksWon,
      'team0Name': instance.team0Name,
      'team1Name': instance.team1Name,
      'result': instance.result,
      'createdAt': instance.createdAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'trumpMakerFirstFive': instance.trumpMakerFirstFive,
      'trumpMakerLastFour': instance.trumpMakerLastFour,
      'reshuffleCount': instance.reshuffleCount,
    };

const _$GamePhaseEnumMap = {
  GamePhase.trumpSelection: 'trumpSelection',
  GamePhase.playing: 'playing',
  GamePhase.ended: 'ended',
};

const _$CardSuitEnumMap = {
  CardSuit.hearts: 'hearts',
  CardSuit.diamonds: 'diamonds',
  CardSuit.clubs: 'clubs',
  CardSuit.spades: 'spades',
};
