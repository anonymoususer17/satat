import 'dart:async';
import '../../data/models/game_model.dart';
import '../../data/repositories/game_repository.dart';
import 'bot_ai_service.dart';

/// Service that controls bot players automatically
class BotControllerService {
  final GameRepository _gameRepository;
  final BotAIService _botAI;
  StreamSubscription<GameModel>? _gameSubscription;

  BotControllerService({
    required GameRepository gameRepository,
    BotAIService? botAI,
  })  : _gameRepository = gameRepository,
        _botAI = botAI ?? BotAIService();

  /// Start watching a game and auto-play for bots
  void startWatchingGame(String gameId) {
    // Stop watching previous game if any
    stopWatching();

    _gameSubscription = _gameRepository.watchGame(gameId).listen(
      (game) async {
        await _handleGameUpdate(game);
      },
      onError: (error) {
        print('Bot controller error: $error');
      },
    );
  }

  /// Stop watching the current game
  void stopWatching() {
    _gameSubscription?.cancel();
    _gameSubscription = null;
  }

  /// Handle game state updates
  Future<void> _handleGameUpdate(GameModel game) async {
    try {
      // Don't do anything if game is over
      if (game.isGameOver) return;

      // Handle trump selection phase
      if (game.phase == GamePhase.trumpSelection) {
        await _handleBotTrumpSelection(game);
        return;
      }

      // Handle playing phase
      if (game.phase == GamePhase.playing) {
        await _handleBotCardPlay(game);
        return;
      }
    } catch (e) {
      print('Error in bot controller: $e');
    }
  }

  /// Handle bot trump selection
  Future<void> _handleBotTrumpSelection(GameModel game) async {
    final trumpMaker = game.getPlayerByPosition(game.trumpMakerPosition);

    // Only act if trump maker is a bot
    if (!trumpMaker.isBot) return;

    // If already selected trump, nothing to do
    if (game.trumpSuit != null) return;

    // If deferred to last 4, select from one of them
    if (game.trumpMakerLastFour != null && game.trumpMakerLastFour!.isNotEmpty) {
      // Small delay to simulate thinking
      await Future.delayed(const Duration(milliseconds: 1500));

      final selectedCard = game.trumpMakerLastFour![0]; // Pick first card
      await _gameRepository.selectTrump(
        gameId: game.id,
        trumpSuit: selectedCard.suit,
        deferredToLastFour: true,
      );
      return;
    }

    // If we have first five, make a decision
    if (game.trumpMakerFirstFive != null && game.trumpMakerFirstFive!.isNotEmpty) {
      // Small delay to simulate thinking
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if should defer
      if (_botAI.shouldDeferTrumpSelection(game.trumpMakerFirstFive!)) {
        // Defer to last 4
        await _gameRepository.deferTrumpSelection(
          gameId: game.id,
          userId: '', // Bot doesn't have userId, repository should handle this
        );
      } else {
        // Select trump from first five
        final trumpSuit = _botAI.selectTrumpSuit(game.trumpMakerFirstFive!);
        await _gameRepository.selectTrump(
          gameId: game.id,
          trumpSuit: trumpSuit,
          deferredToLastFour: false,
        );
      }
    }
  }

  /// Handle bot card play
  Future<void> _handleBotCardPlay(GameModel game) async {
    // Check if it's a bot's turn
    final currentTurnPosition = game.currentTurnPosition;
    if (currentTurnPosition == null) return;

    final currentPlayer = game.getPlayerByPosition(currentTurnPosition);
    if (!currentPlayer.isBot) return;

    // Check if we have a valid trick
    if (game.currentTrick == null || game.trumpSuit == null) return;

    // Small delay to simulate thinking
    await Future.delayed(const Duration(milliseconds: 1000));

    // Select card to play
    final cardToPlay = _botAI.selectCardToPlay(
      bot: currentPlayer,
      trick: game.currentTrick!,
      trumpSuit: game.trumpSuit!,
      botTeam: currentPlayer.team,
    );

    // Play the card using position (since bots don't have userId)
    try {
      await _gameRepository.playCard(
        gameId: game.id,
        position: currentPlayer.position,
        card: cardToPlay,
      );
    } catch (e) {
      print('Error playing bot card: $e');
    }
  }

  void dispose() {
    stopWatching();
  }
}
