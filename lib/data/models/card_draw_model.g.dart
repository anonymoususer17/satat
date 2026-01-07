// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_draw_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardDrawModelImpl _$$CardDrawModelImplFromJson(Map<String, dynamic> json) =>
    _$CardDrawModelImpl(
      availableCards: (json['availableCards'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      playerPicks: (json['playerPicks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          int.parse(k),
          e == null ? null : CardModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      isComplete: json['isComplete'] as bool,
      winningPosition: (json['winningPosition'] as num?)?.toInt(),
      winningTeam: (json['winningTeam'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CardDrawModelImplToJson(
  _$CardDrawModelImpl instance,
) => <String, dynamic>{
  'availableCards': instance.availableCards,
  'playerPicks': instance.playerPicks.map((k, e) => MapEntry(k.toString(), e)),
  'isComplete': instance.isComplete,
  'winningPosition': instance.winningPosition,
  'winningTeam': instance.winningTeam,
};
