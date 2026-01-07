import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/card_model.dart';
import '../../data/models/game_model.dart';
import '../../data/repositories/game_repository.dart';
import '../../domain/services/game_logic_service.dart';
import '../../domain/services/bot_ai_service.dart';
import '../../domain/services/bot_controller_service.dart';
import 'auth_provider.dart';

/// Game repository provider
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

/// Game logic service provider
final gameLogicServiceProvider = Provider<GameLogicService>((ref) {
  return GameLogicService();
});

/// Watch a specific game by ID
/// Automatically recreates when user auth state changes
final gameProvider = StreamProvider.family<GameModel, String>((ref, gameId) {
  // Watch auth state to invalidate this provider when user changes
  final authState = ref.watch(authStateProvider);

  // If not authenticated, throw error
  if (authState.value == null) {
    throw Exception('Not authenticated');
  }

  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGame(gameId);
});

/// Game controller state
class GameControllerState {
  final bool isLoading;
  final String? error;

  GameControllerState({
    this.isLoading = false,
    this.error,
  });

  GameControllerState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return GameControllerState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasError => error != null;
}

/// Game controller for game actions
class GameController extends StateNotifier<GameControllerState> {
  final GameRepository _repository;

  GameController(this._repository) : super(GameControllerState());

  /// Create a game from a lobby
  Future<GameModel?> createGame({
    required String lobbyId,
    required List<Map<String, dynamic>> lobbyPlayers,
    required int dealerPosition,
    String team0Name = 'Team 1',
    String team1Name = 'Team 2',
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final game = await _repository.createGame(
        lobbyId: lobbyId,
        lobbyPlayers: lobbyPlayers,
        dealerPosition: dealerPosition,
        team0Name: team0Name,
        team1Name: team1Name,
      );

      state = state.copyWith(isLoading: false);
      return game;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Select trump suit
  Future<void> selectTrump({
    required String gameId,
    required CardSuit trumpSuit,
    required bool deferredToLastFour,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _repository.selectTrump(
        gameId: gameId,
        trumpSuit: trumpSuit,
        deferredToLastFour: deferredToLastFour,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Play a card
  Future<void> playCard({
    required String gameId,
    String? userId,
    int? position,
    required CardModel card,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _repository.playCard(
        gameId: gameId,
        userId: userId,
        position: position,
        card: card,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Request reshuffle
  Future<void> requestReshuffle({
    required String gameId,
    required String userId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _repository.requestReshuffle(
        gameId: gameId,
        userId: userId,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Defer trump selection to last 4 cards
  Future<void> deferTrumpSelection({
    required String gameId,
    required String userId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _repository.deferTrumpSelection(
        gameId: gameId,
        userId: userId,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Call out the opposing team for cheating
  Future<void> callOutOpposingTeam({
    required String gameId,
    required String userId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _repository.callOutOpposingTeam(
        gameId: gameId,
        userId: userId,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Game controller provider
final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return GameController(repository);
});

/// Bot AI service provider
final botAIServiceProvider = Provider<BotAIService>((ref) {
  return BotAIService();
});

/// Bot controller service provider
final botControllerServiceProvider = Provider<BotControllerService>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  final botAI = ref.watch(botAIServiceProvider);
  return BotControllerService(
    gameRepository: repository,
    botAI: botAI,
  );
});
