import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of authentication state changes
  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get current user
  auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      // Check if username already exists
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('Username already taken');
      }

      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Update display name in Firebase Auth
      await user.updateDisplayName(displayName);

      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: email,
        username: username,
        displayName: displayName,
        createdAt: DateTime.now(),
        stats: const UserStats(),
        friends: [],
      );

      print('📝 Creating user document in Firestore for: $username');
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(_userModelToFirestore(userModel));
        print('✅ User document created successfully');
      } catch (firestoreError) {
        print('❌ Firestore write error: $firestoreError');
        throw Exception('Failed to create user document: $firestoreError');
      }

      return userModel;
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Sign in with email/username and password
  Future<UserModel> signInWithEmailAndPassword({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      String email = emailOrUsername;

      // Check if input is username (doesn't contain @)
      if (!emailOrUsername.contains('@')) {
        // Look up email from username
        final usernameQuery = await _firestore
            .collection('users')
            .where('username', isEqualTo: emailOrUsername)
            .limit(1)
            .get();

        if (usernameQuery.docs.isEmpty) {
          throw Exception('Username not found');
        }

        email = usernameQuery.docs.first.data()['email'] as String;
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in');
      }

      // Fetch user data from Firestore
      return await getUserById(user.uid);
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Get user by ID from Firestore
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        throw Exception('User not found');
      }

      return _userModelFromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? username,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (displayName != null) {
        updates['displayName'] = displayName;
        await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      }

      if (username != null) {
        // Check if username is already taken by another user
        final usernameQuery = await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .limit(1)
            .get();

        if (usernameQuery.docs.isNotEmpty &&
            usernameQuery.docs.first.id != userId) {
          throw Exception('Username already taken');
        }

        updates['username'] = username;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updates);
      }
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user from Firebase Auth
      await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  /// Convert UserModel to Firestore format
  Map<String, dynamic> _userModelToFirestore(UserModel user) {
    return {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'displayName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'stats': {
        'gamesPlayed': user.stats.gamesPlayed,
        'gamesWon': user.stats.gamesWon,
        'gamesLost': user.stats.gamesLost,
        'totalTricks': user.stats.totalTricks,
        'perfectWins': user.stats.perfectWins,
      },
      'friends': user.friends,
    };
  }

  /// Convert Firestore document to UserModel
  UserModel _userModelFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse stats manually
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

  /// Handle Firebase Auth exceptions
  String _handleAuthException(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Email/password sign in is not enabled.';
      default:
        return 'Authentication error: ${e.message ?? e.code}';
    }
  }
}
