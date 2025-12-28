import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider for authentication state (FirebaseAuth user)
final authStateProvider = StreamProvider<auth.User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider for current user data (UserModel from Firestore)
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges.asyncMap((user) async {
    if (user == null) {
      return null;
    } else {
      // Retry logic: document might be created after auth user
      for (int attempt = 0; attempt < 5; attempt++) {
        try {
          final userModel = await authRepository.getUserById(user.uid);
          print('✅ User data loaded: ${userModel.username}');
          return userModel;
        } catch (e) {
          if (attempt < 4) {
            // Wait before retrying (document might be being created)
            await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
          } else {
            // All attempts failed - throw error to trigger sign out
            print('❌ Error loading user data after ${attempt + 1} attempts: $e');
            throw Exception('Failed to load user data. Please try logging in again.');
          }
        }
      }
      return null;
    }
  });
});

/// Auth controller for authentication operations
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  /// Register with email and password
  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
    });
  }

  /// Sign in with email/username and password
  Future<void> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmailAndPassword(
        emailOrUsername: emailOrUsername,
        password: password,
      );
    });
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }

  /// Update user profile
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? username,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.updateUserProfile(
        userId: userId,
        displayName: displayName,
        username: username,
      );
    });
  }

  /// Delete account
  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.deleteAccount();
    });
  }
}

/// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});
