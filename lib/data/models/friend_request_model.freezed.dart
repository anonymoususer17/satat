// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FriendRequestModel _$FriendRequestModelFromJson(Map<String, dynamic> json) {
  return _FriendRequestModel.fromJson(json);
}

/// @nodoc
mixin _$FriendRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get fromUsername => throw _privateConstructorUsedError;
  String get fromDisplayName => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  String get toUsername => throw _privateConstructorUsedError;
  String get toDisplayName => throw _privateConstructorUsedError;
  FriendRequestStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FriendRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendRequestModelCopyWith<FriendRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestModelCopyWith<$Res> {
  factory $FriendRequestModelCopyWith(
    FriendRequestModel value,
    $Res Function(FriendRequestModel) then,
  ) = _$FriendRequestModelCopyWithImpl<$Res, FriendRequestModel>;
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String fromUsername,
    String fromDisplayName,
    String toUserId,
    String toUsername,
    String toDisplayName,
    FriendRequestStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FriendRequestModelCopyWithImpl<$Res, $Val extends FriendRequestModel>
    implements $FriendRequestModelCopyWith<$Res> {
  _$FriendRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? fromUsername = null,
    Object? fromDisplayName = null,
    Object? toUserId = null,
    Object? toUsername = null,
    Object? toDisplayName = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUserId: null == fromUserId
                ? _value.fromUserId
                : fromUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUsername: null == fromUsername
                ? _value.fromUsername
                : fromUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            fromDisplayName: null == fromDisplayName
                ? _value.fromDisplayName
                : fromDisplayName // ignore: cast_nullable_to_non_nullable
                      as String,
            toUserId: null == toUserId
                ? _value.toUserId
                : toUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            toUsername: null == toUsername
                ? _value.toUsername
                : toUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            toDisplayName: null == toDisplayName
                ? _value.toDisplayName
                : toDisplayName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as FriendRequestStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendRequestModelImplCopyWith<$Res>
    implements $FriendRequestModelCopyWith<$Res> {
  factory _$$FriendRequestModelImplCopyWith(
    _$FriendRequestModelImpl value,
    $Res Function(_$FriendRequestModelImpl) then,
  ) = __$$FriendRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String fromUsername,
    String fromDisplayName,
    String toUserId,
    String toUsername,
    String toDisplayName,
    FriendRequestStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FriendRequestModelImplCopyWithImpl<$Res>
    extends _$FriendRequestModelCopyWithImpl<$Res, _$FriendRequestModelImpl>
    implements _$$FriendRequestModelImplCopyWith<$Res> {
  __$$FriendRequestModelImplCopyWithImpl(
    _$FriendRequestModelImpl _value,
    $Res Function(_$FriendRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? fromUsername = null,
    Object? fromDisplayName = null,
    Object? toUserId = null,
    Object? toUsername = null,
    Object? toDisplayName = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$FriendRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUserId: null == fromUserId
            ? _value.fromUserId
            : fromUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUsername: null == fromUsername
            ? _value.fromUsername
            : fromUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        fromDisplayName: null == fromDisplayName
            ? _value.fromDisplayName
            : fromDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        toUserId: null == toUserId
            ? _value.toUserId
            : toUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        toUsername: null == toUsername
            ? _value.toUsername
            : toUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        toDisplayName: null == toDisplayName
            ? _value.toDisplayName
            : toDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as FriendRequestStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestModelImpl implements _FriendRequestModel {
  const _$FriendRequestModelImpl({
    required this.id,
    required this.fromUserId,
    required this.fromUsername,
    required this.fromDisplayName,
    required this.toUserId,
    required this.toUsername,
    required this.toDisplayName,
    required this.status,
    required this.createdAt,
  });

  factory _$FriendRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String fromUsername;
  @override
  final String fromDisplayName;
  @override
  final String toUserId;
  @override
  final String toUsername;
  @override
  final String toDisplayName;
  @override
  final FriendRequestStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FriendRequestModel(id: $id, fromUserId: $fromUserId, fromUsername: $fromUsername, fromDisplayName: $fromDisplayName, toUserId: $toUserId, toUsername: $toUsername, toDisplayName: $toDisplayName, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.fromUsername, fromUsername) ||
                other.fromUsername == fromUsername) &&
            (identical(other.fromDisplayName, fromDisplayName) ||
                other.fromDisplayName == fromDisplayName) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.toUsername, toUsername) ||
                other.toUsername == toUsername) &&
            (identical(other.toDisplayName, toDisplayName) ||
                other.toDisplayName == toDisplayName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fromUserId,
    fromUsername,
    fromDisplayName,
    toUserId,
    toUsername,
    toDisplayName,
    status,
    createdAt,
  );

  /// Create a copy of FriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestModelImplCopyWith<_$FriendRequestModelImpl> get copyWith =>
      __$$FriendRequestModelImplCopyWithImpl<_$FriendRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestModelImplToJson(this);
  }
}

abstract class _FriendRequestModel implements FriendRequestModel {
  const factory _FriendRequestModel({
    required final String id,
    required final String fromUserId,
    required final String fromUsername,
    required final String fromDisplayName,
    required final String toUserId,
    required final String toUsername,
    required final String toDisplayName,
    required final FriendRequestStatus status,
    required final DateTime createdAt,
  }) = _$FriendRequestModelImpl;

  factory _FriendRequestModel.fromJson(Map<String, dynamic> json) =
      _$FriendRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get fromUsername;
  @override
  String get fromDisplayName;
  @override
  String get toUserId;
  @override
  String get toUsername;
  @override
  String get toDisplayName;
  @override
  FriendRequestStatus get status;
  @override
  DateTime get createdAt;

  /// Create a copy of FriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendRequestModelImplCopyWith<_$FriendRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
