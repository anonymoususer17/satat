import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lobby_model.dart';
import '../../data/repositories/lobby_repository.dart';
import 'auth_provider.dart';

/// Provider for LobbyRepository
final lobbyRepositoryProvider = Provider<LobbyRepository>((ref) {
  return LobbyRepository();
});

/// Provider for active lobbies list (stream)
/// Automatically recreates when user auth state changes
final activeLobbiesProvider = StreamProvider<List<LobbyModel>>((ref) {
  // Watch auth state to invalidate this provider when user changes
  final authState = ref.watch(authStateProvider);

  // If not authenticated, return empty stream
  if (authState.value == null) {
    return Stream.value([]);
  }

  final lobbyRepository = ref.watch(lobbyRepositoryProvider);
  return lobbyRepository.watchActiveLobbies();
});

/// Provider for specific lobby (stream)
/// Automatically recreates when user auth state changes
final lobbyProvider = StreamProvider.family<LobbyModel, String>((ref, lobbyId) {
  // Watch auth state to invalidate this provider when user changes
  final authState = ref.watch(authStateProvider);

  // If not authenticated, throw error
  if (authState.value == null) {
    throw Exception('Not authenticated');
  }

  final lobbyRepository = ref.watch(lobbyRepositoryProvider);
  return lobbyRepository.watchLobby(lobbyId);
});

/// Controller for lobby operations
class LobbyController extends StateNotifier<AsyncValue<void>> {
  final LobbyRepository _lobbyRepository;

  LobbyController(this._lobbyRepository)
      : super(const AsyncValue.data(null));

  /// Create a new lobby
  Future<LobbyModel?> createLobby({
    required String hostUserId,
    required String hostUsername,
  }) async {
    state = const AsyncValue.loading();
    try {
      final lobby = await _lobbyRepository.createLobby(
        hostUserId: hostUserId,
        hostUsername: hostUsername,
      );
      state = const AsyncValue.data(null);
      return lobby;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Join lobby by code
  Future<LobbyModel?> joinLobbyByCode({
    required String code,
    required String userId,
    required String username,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final lobby = await _lobbyRepository.getLobbyByCode(code);
      await _lobbyRepository.joinLobby(
        lobbyId: lobby.id,
        userId: userId,
        username: username,
        displayName: displayName,
      );
      state = const AsyncValue.data(null);
      return lobby;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Join lobby by ID
  Future<void> joinLobby({
    required String lobbyId,
    required String userId,
    required String username,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _lobbyRepository.joinLobby(
        lobbyId: lobbyId,
        userId: userId,
        username: username,
        displayName: displayName,
      );
    });
  }

  /// Leave lobby
  Future<void> leaveLobby({
    required String lobbyId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _lobbyRepository.leaveLobby(
        lobbyId: lobbyId,
        userId: userId,
      );
    });
  }

  /// Toggle ready status
  Future<void> toggleReady({
    required String lobbyId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _lobbyRepository.toggleReady(
        lobbyId: lobbyId,
        userId: userId,
      );
    });
  }

  /// Add bot to empty slot
  Future<void> addBot({
    required String lobbyId,
    required int position,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _lobbyRepository.addBot(
        lobbyId: lobbyId,
        position: position,
      );
    });
  }

  /// Remove player/bot from slot
  Future<void> removePlayerFromSlot({
    required String lobbyId,
    required int position,
    required String requestingUserId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _lobbyRepository.removePlayerFromSlot(
        lobbyId: lobbyId,
        position: position,
        requestingUserId: requestingUserId,
      );
    });
  }
}

/// Provider for LobbyController
final lobbyControllerProvider =
    StateNotifierProvider<LobbyController, AsyncValue<void>>((ref) {
  final lobbyRepository = ref.watch(lobbyRepositoryProvider);
  return LobbyController(lobbyRepository);
});
