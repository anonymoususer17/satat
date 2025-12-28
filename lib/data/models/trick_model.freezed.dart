// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trick_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayedCard _$PlayedCardFromJson(Map<String, dynamic> json) {
  return _PlayedCard.fromJson(json);
}

/// @nodoc
mixin _$PlayedCard {
  int get position => throw _privateConstructorUsedError;
  CardModel get card => throw _privateConstructorUsedError;

  /// Serializes this PlayedCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayedCardCopyWith<PlayedCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayedCardCopyWith<$Res> {
  factory $PlayedCardCopyWith(
    PlayedCard value,
    $Res Function(PlayedCard) then,
  ) = _$PlayedCardCopyWithImpl<$Res, PlayedCard>;
  @useResult
  $Res call({int position, CardModel card});

  $CardModelCopyWith<$Res> get card;
}

/// @nodoc
class _$PlayedCardCopyWithImpl<$Res, $Val extends PlayedCard>
    implements $PlayedCardCopyWith<$Res> {
  _$PlayedCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null, Object? card = null}) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            card: null == card
                ? _value.card
                : card // ignore: cast_nullable_to_non_nullable
                      as CardModel,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardModelCopyWith<$Res> get card {
    return $CardModelCopyWith<$Res>(_value.card, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayedCardImplCopyWith<$Res>
    implements $PlayedCardCopyWith<$Res> {
  factory _$$PlayedCardImplCopyWith(
    _$PlayedCardImpl value,
    $Res Function(_$PlayedCardImpl) then,
  ) = __$$PlayedCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int position, CardModel card});

  @override
  $CardModelCopyWith<$Res> get card;
}

/// @nodoc
class __$$PlayedCardImplCopyWithImpl<$Res>
    extends _$PlayedCardCopyWithImpl<$Res, _$PlayedCardImpl>
    implements _$$PlayedCardImplCopyWith<$Res> {
  __$$PlayedCardImplCopyWithImpl(
    _$PlayedCardImpl _value,
    $Res Function(_$PlayedCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null, Object? card = null}) {
    return _then(
      _$PlayedCardImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        card: null == card
            ? _value.card
            : card // ignore: cast_nullable_to_non_nullable
                  as CardModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayedCardImpl implements _PlayedCard {
  const _$PlayedCardImpl({required this.position, required this.card});

  factory _$PlayedCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayedCardImplFromJson(json);

  @override
  final int position;
  @override
  final CardModel card;

  @override
  String toString() {
    return 'PlayedCard(position: $position, card: $card)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayedCardImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.card, card) || other.card == card));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, position, card);

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayedCardImplCopyWith<_$PlayedCardImpl> get copyWith =>
      __$$PlayedCardImplCopyWithImpl<_$PlayedCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayedCardImplToJson(this);
  }
}

abstract class _PlayedCard implements PlayedCard {
  const factory _PlayedCard({
    required final int position,
    required final CardModel card,
  }) = _$PlayedCardImpl;

  factory _PlayedCard.fromJson(Map<String, dynamic> json) =
      _$PlayedCardImpl.fromJson;

  @override
  int get position;
  @override
  CardModel get card;

  /// Create a copy of PlayedCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayedCardImplCopyWith<_$PlayedCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrickModel _$TrickModelFromJson(Map<String, dynamic> json) {
  return _TrickModel.fromJson(json);
}

/// @nodoc
mixin _$TrickModel {
  int get trickNumber =>
      throw _privateConstructorUsedError; // 0-12 (13 tricks total)
  int get leadPosition =>
      throw _privateConstructorUsedError; // Position that led this trick
  List<PlayedCard> get cardsPlayed =>
      throw _privateConstructorUsedError; // Cards played so far (0-4)
  int? get winnerPosition =>
      throw _privateConstructorUsedError; // Position that won this trick (null if in progress)
  CardModel? get winningCard => throw _privateConstructorUsedError;

  /// Serializes this TrickModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrickModelCopyWith<TrickModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrickModelCopyWith<$Res> {
  factory $TrickModelCopyWith(
    TrickModel value,
    $Res Function(TrickModel) then,
  ) = _$TrickModelCopyWithImpl<$Res, TrickModel>;
  @useResult
  $Res call({
    int trickNumber,
    int leadPosition,
    List<PlayedCard> cardsPlayed,
    int? winnerPosition,
    CardModel? winningCard,
  });

  $CardModelCopyWith<$Res>? get winningCard;
}

/// @nodoc
class _$TrickModelCopyWithImpl<$Res, $Val extends TrickModel>
    implements $TrickModelCopyWith<$Res> {
  _$TrickModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trickNumber = null,
    Object? leadPosition = null,
    Object? cardsPlayed = null,
    Object? winnerPosition = freezed,
    Object? winningCard = freezed,
  }) {
    return _then(
      _value.copyWith(
            trickNumber: null == trickNumber
                ? _value.trickNumber
                : trickNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            leadPosition: null == leadPosition
                ? _value.leadPosition
                : leadPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            cardsPlayed: null == cardsPlayed
                ? _value.cardsPlayed
                : cardsPlayed // ignore: cast_nullable_to_non_nullable
                      as List<PlayedCard>,
            winnerPosition: freezed == winnerPosition
                ? _value.winnerPosition
                : winnerPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            winningCard: freezed == winningCard
                ? _value.winningCard
                : winningCard // ignore: cast_nullable_to_non_nullable
                      as CardModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardModelCopyWith<$Res>? get winningCard {
    if (_value.winningCard == null) {
      return null;
    }

    return $CardModelCopyWith<$Res>(_value.winningCard!, (value) {
      return _then(_value.copyWith(winningCard: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrickModelImplCopyWith<$Res>
    implements $TrickModelCopyWith<$Res> {
  factory _$$TrickModelImplCopyWith(
    _$TrickModelImpl value,
    $Res Function(_$TrickModelImpl) then,
  ) = __$$TrickModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int trickNumber,
    int leadPosition,
    List<PlayedCard> cardsPlayed,
    int? winnerPosition,
    CardModel? winningCard,
  });

  @override
  $CardModelCopyWith<$Res>? get winningCard;
}

/// @nodoc
class __$$TrickModelImplCopyWithImpl<$Res>
    extends _$TrickModelCopyWithImpl<$Res, _$TrickModelImpl>
    implements _$$TrickModelImplCopyWith<$Res> {
  __$$TrickModelImplCopyWithImpl(
    _$TrickModelImpl _value,
    $Res Function(_$TrickModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trickNumber = null,
    Object? leadPosition = null,
    Object? cardsPlayed = null,
    Object? winnerPosition = freezed,
    Object? winningCard = freezed,
  }) {
    return _then(
      _$TrickModelImpl(
        trickNumber: null == trickNumber
            ? _value.trickNumber
            : trickNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        leadPosition: null == leadPosition
            ? _value.leadPosition
            : leadPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        cardsPlayed: null == cardsPlayed
            ? _value._cardsPlayed
            : cardsPlayed // ignore: cast_nullable_to_non_nullable
                  as List<PlayedCard>,
        winnerPosition: freezed == winnerPosition
            ? _value.winnerPosition
            : winnerPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        winningCard: freezed == winningCard
            ? _value.winningCard
            : winningCard // ignore: cast_nullable_to_non_nullable
                  as CardModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrickModelImpl extends _TrickModel {
  const _$TrickModelImpl({
    required this.trickNumber,
    required this.leadPosition,
    required final List<PlayedCard> cardsPlayed,
    this.winnerPosition,
    this.winningCard,
  }) : _cardsPlayed = cardsPlayed,
       super._();

  factory _$TrickModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrickModelImplFromJson(json);

  @override
  final int trickNumber;
  // 0-12 (13 tricks total)
  @override
  final int leadPosition;
  // Position that led this trick
  final List<PlayedCard> _cardsPlayed;
  // Position that led this trick
  @override
  List<PlayedCard> get cardsPlayed {
    if (_cardsPlayed is EqualUnmodifiableListView) return _cardsPlayed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cardsPlayed);
  }

  // Cards played so far (0-4)
  @override
  final int? winnerPosition;
  // Position that won this trick (null if in progress)
  @override
  final CardModel? winningCard;

  @override
  String toString() {
    return 'TrickModel(trickNumber: $trickNumber, leadPosition: $leadPosition, cardsPlayed: $cardsPlayed, winnerPosition: $winnerPosition, winningCard: $winningCard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrickModelImpl &&
            (identical(other.trickNumber, trickNumber) ||
                other.trickNumber == trickNumber) &&
            (identical(other.leadPosition, leadPosition) ||
                other.leadPosition == leadPosition) &&
            const DeepCollectionEquality().equals(
              other._cardsPlayed,
              _cardsPlayed,
            ) &&
            (identical(other.winnerPosition, winnerPosition) ||
                other.winnerPosition == winnerPosition) &&
            (identical(other.winningCard, winningCard) ||
                other.winningCard == winningCard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    trickNumber,
    leadPosition,
    const DeepCollectionEquality().hash(_cardsPlayed),
    winnerPosition,
    winningCard,
  );

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrickModelImplCopyWith<_$TrickModelImpl> get copyWith =>
      __$$TrickModelImplCopyWithImpl<_$TrickModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrickModelImplToJson(this);
  }
}

abstract class _TrickModel extends TrickModel {
  const factory _TrickModel({
    required final int trickNumber,
    required final int leadPosition,
    required final List<PlayedCard> cardsPlayed,
    final int? winnerPosition,
    final CardModel? winningCard,
  }) = _$TrickModelImpl;
  const _TrickModel._() : super._();

  factory _TrickModel.fromJson(Map<String, dynamic> json) =
      _$TrickModelImpl.fromJson;

  @override
  int get trickNumber; // 0-12 (13 tricks total)
  @override
  int get leadPosition; // Position that led this trick
  @override
  List<PlayedCard> get cardsPlayed; // Cards played so far (0-4)
  @override
  int? get winnerPosition; // Position that won this trick (null if in progress)
  @override
  CardModel? get winningCard;

  /// Create a copy of TrickModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrickModelImplCopyWith<_$TrickModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
