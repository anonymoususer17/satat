// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_draw_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CardDrawModel _$CardDrawModelFromJson(Map<String, dynamic> json) {
  return _CardDrawModel.fromJson(json);
}

/// @nodoc
mixin _$CardDrawModel {
  List<CardModel> get availableCards =>
      throw _privateConstructorUsedError; // Remaining cards that can be picked
  Map<int, CardModel?> get playerPicks =>
      throw _privateConstructorUsedError; // position -> picked card (null if not picked)
  bool get isComplete =>
      throw _privateConstructorUsedError; // All 4 players have picked
  int? get winningPosition =>
      throw _privateConstructorUsedError; // Position of player with highest card
  int? get winningTeam => throw _privateConstructorUsedError;

  /// Serializes this CardDrawModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardDrawModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardDrawModelCopyWith<CardDrawModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDrawModelCopyWith<$Res> {
  factory $CardDrawModelCopyWith(
    CardDrawModel value,
    $Res Function(CardDrawModel) then,
  ) = _$CardDrawModelCopyWithImpl<$Res, CardDrawModel>;
  @useResult
  $Res call({
    List<CardModel> availableCards,
    Map<int, CardModel?> playerPicks,
    bool isComplete,
    int? winningPosition,
    int? winningTeam,
  });
}

/// @nodoc
class _$CardDrawModelCopyWithImpl<$Res, $Val extends CardDrawModel>
    implements $CardDrawModelCopyWith<$Res> {
  _$CardDrawModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardDrawModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableCards = null,
    Object? playerPicks = null,
    Object? isComplete = null,
    Object? winningPosition = freezed,
    Object? winningTeam = freezed,
  }) {
    return _then(
      _value.copyWith(
            availableCards: null == availableCards
                ? _value.availableCards
                : availableCards // ignore: cast_nullable_to_non_nullable
                      as List<CardModel>,
            playerPicks: null == playerPicks
                ? _value.playerPicks
                : playerPicks // ignore: cast_nullable_to_non_nullable
                      as Map<int, CardModel?>,
            isComplete: null == isComplete
                ? _value.isComplete
                : isComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            winningPosition: freezed == winningPosition
                ? _value.winningPosition
                : winningPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            winningTeam: freezed == winningTeam
                ? _value.winningTeam
                : winningTeam // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardDrawModelImplCopyWith<$Res>
    implements $CardDrawModelCopyWith<$Res> {
  factory _$$CardDrawModelImplCopyWith(
    _$CardDrawModelImpl value,
    $Res Function(_$CardDrawModelImpl) then,
  ) = __$$CardDrawModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CardModel> availableCards,
    Map<int, CardModel?> playerPicks,
    bool isComplete,
    int? winningPosition,
    int? winningTeam,
  });
}

/// @nodoc
class __$$CardDrawModelImplCopyWithImpl<$Res>
    extends _$CardDrawModelCopyWithImpl<$Res, _$CardDrawModelImpl>
    implements _$$CardDrawModelImplCopyWith<$Res> {
  __$$CardDrawModelImplCopyWithImpl(
    _$CardDrawModelImpl _value,
    $Res Function(_$CardDrawModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardDrawModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableCards = null,
    Object? playerPicks = null,
    Object? isComplete = null,
    Object? winningPosition = freezed,
    Object? winningTeam = freezed,
  }) {
    return _then(
      _$CardDrawModelImpl(
        availableCards: null == availableCards
            ? _value._availableCards
            : availableCards // ignore: cast_nullable_to_non_nullable
                  as List<CardModel>,
        playerPicks: null == playerPicks
            ? _value._playerPicks
            : playerPicks // ignore: cast_nullable_to_non_nullable
                  as Map<int, CardModel?>,
        isComplete: null == isComplete
            ? _value.isComplete
            : isComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        winningPosition: freezed == winningPosition
            ? _value.winningPosition
            : winningPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        winningTeam: freezed == winningTeam
            ? _value.winningTeam
            : winningTeam // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardDrawModelImpl implements _CardDrawModel {
  const _$CardDrawModelImpl({
    required final List<CardModel> availableCards,
    required final Map<int, CardModel?> playerPicks,
    required this.isComplete,
    this.winningPosition,
    this.winningTeam,
  }) : _availableCards = availableCards,
       _playerPicks = playerPicks;

  factory _$CardDrawModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardDrawModelImplFromJson(json);

  final List<CardModel> _availableCards;
  @override
  List<CardModel> get availableCards {
    if (_availableCards is EqualUnmodifiableListView) return _availableCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCards);
  }

  // Remaining cards that can be picked
  final Map<int, CardModel?> _playerPicks;
  // Remaining cards that can be picked
  @override
  Map<int, CardModel?> get playerPicks {
    if (_playerPicks is EqualUnmodifiableMapView) return _playerPicks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_playerPicks);
  }

  // position -> picked card (null if not picked)
  @override
  final bool isComplete;
  // All 4 players have picked
  @override
  final int? winningPosition;
  // Position of player with highest card
  @override
  final int? winningTeam;

  @override
  String toString() {
    return 'CardDrawModel(availableCards: $availableCards, playerPicks: $playerPicks, isComplete: $isComplete, winningPosition: $winningPosition, winningTeam: $winningTeam)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardDrawModelImpl &&
            const DeepCollectionEquality().equals(
              other._availableCards,
              _availableCards,
            ) &&
            const DeepCollectionEquality().equals(
              other._playerPicks,
              _playerPicks,
            ) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.winningPosition, winningPosition) ||
                other.winningPosition == winningPosition) &&
            (identical(other.winningTeam, winningTeam) ||
                other.winningTeam == winningTeam));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_availableCards),
    const DeepCollectionEquality().hash(_playerPicks),
    isComplete,
    winningPosition,
    winningTeam,
  );

  /// Create a copy of CardDrawModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardDrawModelImplCopyWith<_$CardDrawModelImpl> get copyWith =>
      __$$CardDrawModelImplCopyWithImpl<_$CardDrawModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardDrawModelImplToJson(this);
  }
}

abstract class _CardDrawModel implements CardDrawModel {
  const factory _CardDrawModel({
    required final List<CardModel> availableCards,
    required final Map<int, CardModel?> playerPicks,
    required final bool isComplete,
    final int? winningPosition,
    final int? winningTeam,
  }) = _$CardDrawModelImpl;

  factory _CardDrawModel.fromJson(Map<String, dynamic> json) =
      _$CardDrawModelImpl.fromJson;

  @override
  List<CardModel> get availableCards; // Remaining cards that can be picked
  @override
  Map<int, CardModel?> get playerPicks; // position -> picked card (null if not picked)
  @override
  bool get isComplete; // All 4 players have picked
  @override
  int? get winningPosition; // Position of player with highest card
  @override
  int? get winningTeam;

  /// Create a copy of CardDrawModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardDrawModelImplCopyWith<_$CardDrawModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
