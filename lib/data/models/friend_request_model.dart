import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request_model.freezed.dart';
part 'friend_request_model.g.dart';

/// Status of a friend request
enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
}

/// Friend request model
@freezed
class FriendRequestModel with _$FriendRequestModel {
  const factory FriendRequestModel({
    required String id,
    required String fromUserId,
    required String fromUsername,
    required String fromDisplayName,
    required String toUserId,
    required String toUsername,
    required String toDisplayName,
    required FriendRequestStatus status,
    required DateTime createdAt,
  }) = _FriendRequestModel;

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestModelFromJson(json);
}
