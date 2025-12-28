// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerSlot _$PlayerSlotFromJson(Map<String, dynamic> json) {
  return _PlayerSlot.fromJson(json);
}

/// @nodoc
mixin _$PlayerSlot {
  int get position => throw _privateConstructorUsedError; // 0-3
  String? get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get isBot => throw _privateConstructorUsedError;
  bool get isReady => throw _privateConstructorUsedError;

  /// Serializes this PlayerSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerSlotCopyWith<PlayerSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerSlotCopyWith<$Res> {
  factory $PlayerSlotCopyWith(
    PlayerSlot value,
    $Res Function(PlayerSlot) then,
  ) = _$PlayerSlotCopyWithImpl<$Res, PlayerSlot>;
  @useResult
  $Res call({
    int position,
    String? userId,
    String? username,
    String? displayName,
    bool isBot,
    bool isReady,
  });
}

/// @nodoc
class _$PlayerSlotCopyWithImpl<$Res, $Val extends PlayerSlot>
    implements $PlayerSlotCopyWith<$Res> {
  _$PlayerSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? userId = freezed,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? isBot = null,
    Object? isReady = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isBot: null == isBot
                ? _value.isBot
                : isBot // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReady: null == isReady
                ? _value.isReady
                : isReady // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerSlotImplCopyWith<$Res>
    implements $PlayerSlotCopyWith<$Res> {
  factory _$$PlayerSlotImplCopyWith(
    _$PlayerSlotImpl value,
    $Res Function(_$PlayerSlotImpl) then,
  ) = __$$PlayerSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int position,
    String? userId,
    String? username,
    String? displayName,
    bool isBot,
    bool isReady,
  });
}

/// @nodoc
class __$$PlayerSlotImplCopyWithImpl<$Res>
    extends _$PlayerSlotCopyWithImpl<$Res, _$PlayerSlotImpl>
    implements _$$PlayerSlotImplCopyWith<$Res> {
  __$$PlayerSlotImplCopyWithImpl(
    _$PlayerSlotImpl _value,
    $Res Function(_$PlayerSlotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? userId = freezed,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? isBot = null,
    Object? isReady = null,
  }) {
    return _then(
      _$PlayerSlotImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isBot: null == isBot
            ? _value.isBot
            : isBot // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReady: null == isReady
            ? _value.isReady
            : isReady // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerSlotImpl implements _PlayerSlot {
  const _$PlayerSlotImpl({
    required this.position,
    this.userId,
    this.username,
    this.displayName,
    required this.isBot,
    required this.isReady,
  });

  factory _$PlayerSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerSlotImplFromJson(json);

  @override
  final int position;
  // 0-3
  @override
  final String? userId;
  @override
  final String? username;
  @override
  final String? displayName;
  @override
  final bool isBot;
  @override
  final bool isReady;

  @override
  String toString() {
    return 'PlayerSlot(position: $position, userId: $userId, username: $username, displayName: $displayName, isBot: $isBot, isReady: $isReady)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerSlotImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isBot, isBot) || other.isBot == isBot) &&
            (identical(other.isReady, isReady) || other.isReady == isReady));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    position,
    userId,
    username,
    displayName,
    isBot,
    isReady,
  );

  /// Create a copy of PlayerSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerSlotImplCopyWith<_$PlayerSlotImpl> get copyWith =>
      __$$PlayerSlotImplCopyWithImpl<_$PlayerSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerSlotImplToJson(this);
  }
}

abstract class _PlayerSlot implements PlayerSlot {
  const factory _PlayerSlot({
    required final int position,
    final String? userId,
    final String? username,
    final String? displayName,
    required final bool isBot,
    required final bool isReady,
  }) = _$PlayerSlotImpl;

  factory _PlayerSlot.fromJson(Map<String, dynamic> json) =
      _$PlayerSlotImpl.fromJson;

  @override
  int get position; // 0-3
  @override
  String? get userId;
  @override
  String? get username;
  @override
  String? get displayName;
  @override
  bool get isBot;
  @override
  bool get isReady;

  /// Create a copy of PlayerSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerSlotImplCopyWith<_$PlayerSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LobbyModel _$LobbyModelFromJson(Map<String, dynamic> json) {
  return _LobbyModel.fromJson(json);
}

/// @nodoc
mixin _$LobbyModel {
  String get id => throw _privateConstructorUsedError;
  String get hostUserId => throw _privateConstructorUsedError;
  String get hostUsername => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError; // 6-digit invite code
  LobbyStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<PlayerSlot> get players =>
      throw _privateConstructorUsedError; // Always 4 slots
  String? get gameId => throw _privateConstructorUsedError;

  /// Serializes this LobbyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbyModelCopyWith<LobbyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyModelCopyWith<$Res> {
  factory $LobbyModelCopyWith(
    LobbyModel value,
    $Res Function(LobbyModel) then,
  ) = _$LobbyModelCopyWithImpl<$Res, LobbyModel>;
  @useResult
  $Res call({
    String id,
    String hostUserId,
    String hostUsername,
    String code,
    LobbyStatus status,
    DateTime createdAt,
    List<PlayerSlot> players,
    String? gameId,
  });
}

/// @nodoc
class _$LobbyModelCopyWithImpl<$Res, $Val extends LobbyModel>
    implements $LobbyModelCopyWith<$Res> {
  _$LobbyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostUserId = null,
    Object? hostUsername = null,
    Object? code = null,
    Object? status = null,
    Object? createdAt = null,
    Object? players = null,
    Object? gameId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            hostUserId: null == hostUserId
                ? _value.hostUserId
                : hostUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            hostUsername: null == hostUsername
                ? _value.hostUsername
                : hostUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as LobbyStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<PlayerSlot>,
            gameId: freezed == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LobbyModelImplCopyWith<$Res>
    implements $LobbyModelCopyWith<$Res> {
  factory _$$LobbyModelImplCopyWith(
    _$LobbyModelImpl value,
    $Res Function(_$LobbyModelImpl) then,
  ) = __$$LobbyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String hostUserId,
    String hostUsername,
    String code,
    LobbyStatus status,
    DateTime createdAt,
    List<PlayerSlot> players,
    String? gameId,
  });
}

/// @nodoc
class __$$LobbyModelImplCopyWithImpl<$Res>
    extends _$LobbyModelCopyWithImpl<$Res, _$LobbyModelImpl>
    implements _$$LobbyModelImplCopyWith<$Res> {
  __$$LobbyModelImplCopyWithImpl(
    _$LobbyModelImpl _value,
    $Res Function(_$LobbyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostUserId = null,
    Object? hostUsername = null,
    Object? code = null,
    Object? status = null,
    Object? createdAt = null,
    Object? players = null,
    Object? gameId = freezed,
  }) {
    return _then(
      _$LobbyModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        hostUserId: null == hostUserId
            ? _value.hostUserId
            : hostUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostUsername: null == hostUsername
            ? _value.hostUsername
            : hostUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as LobbyStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<PlayerSlot>,
        gameId: freezed == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LobbyModelImpl implements _LobbyModel {
  const _$LobbyModelImpl({
    required this.id,
    required this.hostUserId,
    required this.hostUsername,
    required this.code,
    required this.status,
    required this.createdAt,
    required final List<PlayerSlot> players,
    this.gameId,
  }) : _players = players;

  factory _$LobbyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LobbyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String hostUserId;
  @override
  final String hostUsername;
  @override
  final String code;
  // 6-digit invite code
  @override
  final LobbyStatus status;
  @override
  final DateTime createdAt;
  final List<PlayerSlot> _players;
  @override
  List<PlayerSlot> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  // Always 4 slots
  @override
  final String? gameId;

  @override
  String toString() {
    return 'LobbyModel(id: $id, hostUserId: $hostUserId, hostUsername: $hostUsername, code: $code, status: $status, createdAt: $createdAt, players: $players, gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostUserId, hostUserId) ||
                other.hostUserId == hostUserId) &&
            (identical(other.hostUsername, hostUsername) ||
                other.hostUsername == hostUsername) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    hostUserId,
    hostUsername,
    code,
    status,
    createdAt,
    const DeepCollectionEquality().hash(_players),
    gameId,
  );

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyModelImplCopyWith<_$LobbyModelImpl> get copyWith =>
      __$$LobbyModelImplCopyWithImpl<_$LobbyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LobbyModelImplToJson(this);
  }
}

abstract class _LobbyModel implements LobbyModel {
  const factory _LobbyModel({
    required final String id,
    required final String hostUserId,
    required final String hostUsername,
    required final String code,
    required final LobbyStatus status,
    required final DateTime createdAt,
    required final List<PlayerSlot> players,
    final String? gameId,
  }) = _$LobbyModelImpl;

  factory _LobbyModel.fromJson(Map<String, dynamic> json) =
      _$LobbyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get hostUserId;
  @override
  String get hostUsername;
  @override
  String get code; // 6-digit invite code
  @override
  LobbyStatus get status;
  @override
  DateTime get createdAt;
  @override
  List<PlayerSlot> get players; // Always 4 slots
  @override
  String? get gameId;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbyModelImplCopyWith<_$LobbyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
