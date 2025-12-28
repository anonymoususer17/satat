import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/friend_request_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/friend_repository.dart';
import 'auth_provider.dart';

/// Provider for FriendRepository
final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  return FriendRepository();
});

/// Provider for user's friends list
final friendsListProvider = FutureProvider<List<UserModel>>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final friendRepository = ref.watch(friendRepositoryProvider);
  return friendRepository.getFriends(currentUser.id);
});

/// Provider for received friend requests (stream)
final receivedRequestsProvider =
    StreamProvider<List<FriendRequestModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value([]);
  }

  final friendRepository = ref.watch(friendRepositoryProvider);
  return friendRepository.getReceivedRequests(user.uid);
});

/// Provider for sent friend requests (stream)
final sentRequestsProvider = StreamProvider<List<FriendRequestModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value([]);
  }

  final friendRepository = ref.watch(friendRepositoryProvider);
  return friendRepository.getSentRequests(user.uid);
});

/// Controller for friend operations
class FriendsController extends StateNotifier<AsyncValue<void>> {
  final FriendRepository _friendRepository;

  FriendsController(this._friendRepository)
      : super(const AsyncValue.data(null));

  /// Search for users by username
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      return await _friendRepository.searchUsers(query);
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  /// Send a friend request
  Future<void> sendFriendRequest({
    required String fromUserId,
    required String fromUsername,
    required String fromDisplayName,
    required String toUserId,
    required String toUsername,
    required String toDisplayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _friendRepository.sendFriendRequest(
        fromUserId: fromUserId,
        fromUsername: fromUsername,
        fromDisplayName: fromDisplayName,
        toUserId: toUserId,
        toUsername: toUsername,
        toDisplayName: toDisplayName,
      );
    });
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _friendRepository.acceptFriendRequest(requestId);
    });
  }

  /// Reject a friend request
  Future<void> rejectFriendRequest(String requestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _friendRepository.rejectFriendRequest(requestId);
    });
  }

  /// Cancel a sent friend request
  Future<void> cancelFriendRequest(String requestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _friendRepository.cancelFriendRequest(requestId);
    });
  }

  /// Remove a friend
  Future<void> removeFriend({
    required String userId,
    required String friendId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _friendRepository.removeFriend(
        userId: userId,
        friendId: friendId,
      );
    });
  }
}

/// Provider for FriendsController
final friendsControllerProvider =
    StateNotifierProvider<FriendsController, AsyncValue<void>>((ref) {
  final friendRepository = ref.watch(friendRepositoryProvider);
  return FriendsController(friendRepository);
});
