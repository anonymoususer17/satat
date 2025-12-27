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
final currentUserProvider = StreamProvider<UserModel?>((ref) async* {
  final authState = ref.watch(authStateProvider);

  await for (final user in authState.stream) {
    if (user == null) {
      yield null;
    } else {
      final authRepository = ref.read(authRepositoryProvider);
      try {
        final userModel = await authRepository.getUserById(user.uid);
        yield userModel;
      } catch (e) {
        // If user document doesn't exist yet, yield null
        yield null;
      }
    }
  }
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

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
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
