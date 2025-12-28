// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendRequestModelImpl _$$FriendRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$FriendRequestModelImpl(
  id: json['id'] as String,
  fromUserId: json['fromUserId'] as String,
  fromUsername: json['fromUsername'] as String,
  fromDisplayName: json['fromDisplayName'] as String,
  toUserId: json['toUserId'] as String,
  toUsername: json['toUsername'] as String,
  toDisplayName: json['toDisplayName'] as String,
  status: $enumDecode(_$FriendRequestStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$FriendRequestModelImplToJson(
  _$FriendRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fromUserId': instance.fromUserId,
  'fromUsername': instance.fromUsername,
  'fromDisplayName': instance.fromDisplayName,
  'toUserId': instance.toUserId,
  'toUsername': instance.toUsername,
  'toDisplayName': instance.toDisplayName,
  'status': _$FriendRequestStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.rejected: 'rejected',
};
