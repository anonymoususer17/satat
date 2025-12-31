import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/card_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import 'trump_selection_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Start bot controller to watch this game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(botControllerServiceProvider).startWatchingGame(widget.gameId);
    });
  }

  @override
  void dispose() {
    // Stop bot controller when leaving game
    ref.read(botControllerServiceProvider).stopWatching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final gameAsync = ref.watch(gameProvider(widget.gameId));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: currentUserAsync.when(
            data: (currentUser) {
              if (currentUser == null) {
                return const Center(child: Text('Please log in'));
              }

              return gameAsync.when(
                data: (game) {
                  // Trump selection phase
                  if (game.phase == GamePhase.trumpSelection) {
                    return TrumpSelectionScreen(
                      gameId: widget.gameId,
                      game: game,
                      currentUserId: currentUser.id,
                    );
                  }

                  // Playing or ended phase
                  return _buildGameScreen(context, ref, game, currentUser.id);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      Text(
                        'Error loading game',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen(
    BuildContext context,
    WidgetRef ref,
    GameModel game,
    String currentUserId,
  ) {
    final currentPlayer = game.getPlayerByUserId(currentUserId);
    if (currentPlayer == null) {
      return const Center(child: Text('You are not in this game'));
    }

    final isMyTurn = game.isPlayerTurn(currentUserId);

    return Column(
      children: [
        // Header with trump and score
        _buildHeader(context, game),

        // Game area (tricks and opponents)
        Expanded(
          child: _buildGameArea(context, game, currentPlayer),
        ),

        // Current player's hand
        _buildPlayerHand(context, ref, game, currentPlayer, isMyTurn),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, GameModel game) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.textPrimaryColor,
            onPressed: () => Navigator.of(context).pop(),
          ),

          const SizedBox(width: AppTheme.spacingSmall),

          // Trump suit
          if (game.trumpSuit != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSmall,
                vertical: AppTheme.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    game.trumpSuit!.symbol,
                    style: TextStyle(
                      color: game.trumpSuit!.isRed ? Colors.red : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.spacingSmall),
          ],

          // Score - flexible to take remaining space
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSmall,
                vertical: AppTheme.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${game.team0TricksWon}-${game.team1TricksWon}',
                style: const TextStyle(
                  color: AppTheme.textOnCardColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(
    BuildContext context,
    GameModel game,
    GamePlayer currentPlayer,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current trick
          if (game.currentTrick != null && game.currentTrick!.cardsPlayed.isNotEmpty)
            _buildCurrentTrick(context, game),

          const SizedBox(height: AppTheme.spacingLarge),

          // Turn indicator
          if (game.currentTurnPosition != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLarge,
                vertical: AppTheme.spacingMedium,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withAlpha(51), // 0.2 * 255 = 51
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                game.currentTurnPosition == currentPlayer.position
                    ? 'Your Turn'
                    : '${game.getPlayerByPosition(game.currentTurnPosition!).displayName}\'s Turn',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

          // Game result
          if (game.result != null) _buildGameResult(context, game),
        ],
      ),
    );
  }

  Widget _buildCurrentTrick(BuildContext context, GameModel game) {
    final trick = game.currentTrick!;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Wrap(
        spacing: AppTheme.spacingMedium,
        children: trick.cardsPlayed.map((playedCard) {
          return _buildCardWidget(
            context,
            playedCard.card,
            label: game.getPlayerByPosition(playedCard.position).displayName,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameResult(BuildContext context, GameModel game) {
    final result = game.result!;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      margin: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events,
            size: 64,
            color: AppTheme.textPrimaryColor,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            'Team ${result.winningTeam + 1} Wins!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            result.resultType == '13-0'
                ? 'Perfect Win!'
                : result.resultType == '7-0'
                    ? '7-0 Victory!'
                    : 'Victory!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            'Score: ${result.team0Tricks} - ${result.team1Tricks}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerHand(
    BuildContext context,
    WidgetRef ref,
    GameModel game,
    GamePlayer player,
    bool isMyTurn,
  ) {
    final sortedHand = player.sortedHand;
    const cardWidth = 80.0;
    const cardOverlapOffset = 30.0; // How much each card overlaps the previous one

    return Container(
      height: 180,
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Center(
        child: SizedBox(
          // Calculate total width needed for stacked cards
          width: sortedHand.isEmpty
            ? 0
            : cardWidth + (sortedHand.length - 1) * cardOverlapOffset,
          height: 150,
          child: Stack(
            children: [
              for (int index = 0; index < sortedHand.length; index++)
                Positioned(
                  left: index * cardOverlapOffset,
                  child: Builder(
                    builder: (context) {
                      final card = sortedHand[index];
                      final canPlay = isMyTurn && game.phase == GamePhase.playing;

                      return GestureDetector(
                        onTap: canPlay
                            ? () => _playCard(context, ref, game.id, player.userId!, card)
                            : null,
                        child: Stack(
                          children: [
                            ColorFiltered(
                              colorFilter: canPlay
                                  ? const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    )
                                  : const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 1, 0,
                                    ]),
                              child: _buildCardWidget(context, card),
                            ),
                            if (!canPlay)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWidget(BuildContext context, CardModel card, {String? label}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: card.isHeart2 ? AppTheme.accentColor : Colors.grey,
                width: card.isHeart2 ? 3 : 1,
              ),
            ),
            child: Stack(
              children: [
                // Top-left rank and suit (visible when overlapped)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.rank.displayName,
                        style: TextStyle(
                          color: card.suit.isRed ? Colors.red : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        card.suit.symbol,
                        style: TextStyle(
                          color: card.suit.isRed ? Colors.red : Colors.black,
                          fontSize: 20,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Center display (larger symbols)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card.rank.displayName,
                        style: TextStyle(
                          color: card.suit.isRed ? Colors.red : Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        card.suit.symbol,
                        style: TextStyle(
                          color: card.suit.isRed ? Colors.red : Colors.black,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playCard(
    BuildContext context,
    WidgetRef ref,
    String gameId,
    String userId,
    CardModel card,
  ) async {
    final controller = ref.read(gameControllerProvider.notifier);

    await controller.playCard(
      gameId: gameId,
      userId: userId,
      card: card,
    );

    final state = ref.read(gameControllerProvider);
    if (state.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      controller.clearError();
    }
  }
}
