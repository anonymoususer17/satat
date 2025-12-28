// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trick_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayedCardImpl _$$PlayedCardImplFromJson(Map<String, dynamic> json) =>
    _$PlayedCardImpl(
      position: (json['position'] as num).toInt(),
      card: CardModel.fromJson(json['card'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlayedCardImplToJson(_$PlayedCardImpl instance) =>
    <String, dynamic>{'position': instance.position, 'card': instance.card};

_$TrickModelImpl _$$TrickModelImplFromJson(Map<String, dynamic> json) =>
    _$TrickModelImpl(
      trickNumber: (json['trickNumber'] as num).toInt(),
      leadPosition: (json['leadPosition'] as num).toInt(),
      cardsPlayed: (json['cardsPlayed'] as List<dynamic>)
          .map((e) => PlayedCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      winnerPosition: (json['winnerPosition'] as num?)?.toInt(),
      winningCard: json['winningCard'] == null
          ? null
          : CardModel.fromJson(json['winningCard'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TrickModelImplToJson(_$TrickModelImpl instance) =>
    <String, dynamic>{
      'trickNumber': instance.trickNumber,
      'leadPosition': instance.leadPosition,
      'cardsPlayed': instance.cardsPlayed,
      'winnerPosition': instance.winnerPosition,
      'winningCard': instance.winningCard,
    };
