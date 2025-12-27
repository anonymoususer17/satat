// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
      gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
      gamesLost: (json['gamesLost'] as num?)?.toInt() ?? 0,
      totalTricks: (json['totalTricks'] as num?)?.toInt() ?? 0,
      perfectWins: (json['perfectWins'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'gamesPlayed': instance.gamesPlayed,
      'gamesWon': instance.gamesWon,
      'gamesLost': instance.gamesLost,
      'totalTricks': instance.totalTricks,
      'perfectWins': instance.perfectWins,
    };

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      stats: json['stats'] == null
          ? const UserStats()
          : UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      friends:
          (json['friends'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'stats': instance.stats,
      'friends': instance.friends,
    };
