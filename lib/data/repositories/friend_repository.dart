import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend_request_model.dart';
import '../models/user_model.dart';

/// Repository for friend operations
class FriendRepository {
  final FirebaseFirestore _firestore;

  FriendRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Search users by username
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return [];

      // Search for users whose username starts with the query
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: '$query\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => _userModelFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  /// Get user's friends list
  Future<List<UserModel>> getFriends(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final friendIds = List<String>.from(userDoc.data()?['friends'] ?? []);

      if (friendIds.isEmpty) {
        return [];
      }

      // Fetch all friend user documents
      final friendDocs = await Future.wait(
        friendIds.map((id) => _firestore.collection('users').doc(id).get()),
      );

      return friendDocs
          .where((doc) => doc.exists)
          .map((doc) => _userModelFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get friends: ${e.toString()}');
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
    try {
      // Check if users are already friends
      final fromUserDoc = await _firestore.collection('users').doc(fromUserId).get();
      final friendIds = List<String>.from(fromUserDoc.data()?['friends'] ?? []);

      if (friendIds.contains(toUserId)) {
        throw Exception('You are already friends with this user');
      }

      // Check if a pending request already exists
      final existingRequests = await _firestore
          .collection('friendRequests')
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .where('status', isEqualTo: FriendRequestStatus.pending.name)
          .limit(1)
          .get();

      if (existingRequests.docs.isNotEmpty) {
        throw Exception('Friend request already sent');
      }

      // Check if there's a pending request from the other user
      final reverseRequests = await _firestore
          .collection('friendRequests')
          .where('fromUserId', isEqualTo: toUserId)
          .where('toUserId', isEqualTo: fromUserId)
          .where('status', isEqualTo: FriendRequestStatus.pending.name)
          .limit(1)
          .get();

      if (reverseRequests.docs.isNotEmpty) {
        throw Exception('This user has already sent you a friend request');
      }

      // Create friend request
      await _firestore.collection('friendRequests').add({
        'fromUserId': fromUserId,
        'fromUsername': fromUsername,
        'fromDisplayName': fromDisplayName,
        'toUserId': toUserId,
        'toUsername': toUsername,
        'toDisplayName': toDisplayName,
        'status': FriendRequestStatus.pending.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send friend request: ${e.toString()}');
    }
  }

  /// Get pending friend requests received by a user
  Stream<List<FriendRequestModel>> getReceivedRequests(String userId) {
    return _firestore
        .collection('friendRequests')
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: FriendRequestStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _friendRequestFromFirestore(doc))
            .toList());
  }

  /// Get pending friend requests sent by a user
  Stream<List<FriendRequestModel>> getSentRequests(String userId) {
    return _firestore
        .collection('friendRequests')
        .where('fromUserId', isEqualTo: userId)
        .where('status', isEqualTo: FriendRequestStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _friendRequestFromFirestore(doc))
            .toList());
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    try {
      final requestDoc =
          await _firestore.collection('friendRequests').doc(requestId).get();

      if (!requestDoc.exists) {
        throw Exception('Friend request not found');
      }

      final request = _friendRequestFromFirestore(requestDoc);

      // Use a batch to update both users and the request atomically
      final batch = _firestore.batch();

      // Update request status
      batch.update(requestDoc.reference, {
        'status': FriendRequestStatus.accepted.name,
      });

      // Add each user to the other's friends list
      final fromUserRef = _firestore.collection('users').doc(request.fromUserId);
      final toUserRef = _firestore.collection('users').doc(request.toUserId);

      batch.update(fromUserRef, {
        'friends': FieldValue.arrayUnion([request.toUserId]),
      });

      batch.update(toUserRef, {
        'friends': FieldValue.arrayUnion([request.fromUserId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to accept friend request: ${e.toString()}');
    }
  }

  /// Reject a friend request
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _firestore.collection('friendRequests').doc(requestId).update({
        'status': FriendRequestStatus.rejected.name,
      });
    } catch (e) {
      throw Exception('Failed to reject friend request: ${e.toString()}');
    }
  }

  /// Cancel a sent friend request
  Future<void> cancelFriendRequest(String requestId) async {
    try {
      await _firestore.collection('friendRequests').doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to cancel friend request: ${e.toString()}');
    }
  }

  /// Remove a friend
  Future<void> removeFriend({
    required String userId,
    required String friendId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Remove each user from the other's friends list
      final userRef = _firestore.collection('users').doc(userId);
      final friendRef = _firestore.collection('users').doc(friendId);

      batch.update(userRef, {
        'friends': FieldValue.arrayRemove([friendId]),
      });

      batch.update(friendRef, {
        'friends': FieldValue.arrayRemove([userId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to remove friend: ${e.toString()}');
    }
  }

  /// Convert Firestore document to UserModel
  UserModel _userModelFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final statsData = data['stats'] as Map<String, dynamic>? ?? {};
    final stats = UserStats(
      gamesPlayed: statsData['gamesPlayed'] as int? ?? 0,
      gamesWon: statsData['gamesWon'] as int? ?? 0,
      gamesLost: statsData['gamesLost'] as int? ?? 0,
      totalTricks: statsData['totalTricks'] as int? ?? 0,
      perfectWins: statsData['perfectWins'] as int? ?? 0,
    );

    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      username: data['username'] as String,
      displayName: data['displayName'] as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stats: stats,
      friends: List<String>.from(data['friends'] as List? ?? []),
    );
  }

  /// Convert Firestore document to FriendRequestModel
  FriendRequestModel _friendRequestFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FriendRequestModel(
      id: doc.id,
      fromUserId: data['fromUserId'] as String,
      fromUsername: data['fromUsername'] as String,
      fromDisplayName: data['fromDisplayName'] as String,
      toUserId: data['toUserId'] as String,
      toUsername: data['toUsername'] as String,
      toDisplayName: data['toDisplayName'] as String,
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => FriendRequestStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
