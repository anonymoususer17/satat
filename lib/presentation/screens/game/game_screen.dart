import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/card_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game/animated_trick_display.dart';
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
  int? _hoveredCardIndex;

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
    // Get opponents relative to current player's position
    final opponents = game.players.where((p) => p.position != currentPlayer.position).toList();

    // Calculate relative positions (clockwise from current player)
    final relativePositions = opponents.map((opp) {
      int diff = (opp.position - currentPlayer.position) % 4;
      return {'player': opp, 'relative': diff};
    }).toList();

    // Sort by relative position to get consistent placement
    relativePositions.sort((a, b) => (a['relative'] as int).compareTo(b['relative'] as int));

    // Assign to positions: top (opposite), left, right
    final topPlayer = relativePositions[1]['player'] as GamePlayer; // Opposite player
    final leftPlayer = relativePositions[2]['player'] as GamePlayer; // Player to the left
    final rightPlayer = relativePositions[0]['player'] as GamePlayer; // Player to the right

    return Stack(
      children: [
        // Top opponent (opposite player)
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: _buildOpponentHand(context, topPlayer, alignment: Alignment.topCenter),
        ),

        // Left opponent
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: _buildOpponentHand(
            context,
            leftPlayer,
            alignment: Alignment.centerLeft,
            vertical: true,
            rotation: pi / 2, // 90 degrees clockwise
          ),
        ),

        // Right opponent
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: _buildOpponentHand(
            context,
            rightPlayer,
            alignment: Alignment.centerRight,
            vertical: true,
            rotation: -pi / 2, // 90 degrees counter-clockwise
          ),
        ),

        // Center area with trick and turn indicator (drag target)
        Center(
          child: _buildDragTarget(context, ref, game, currentPlayer),
        ),
      ],
    );
  }

  Widget _buildDragTarget(
    BuildContext context,
    WidgetRef ref,
    GameModel game,
    GamePlayer currentPlayer,
  ) {
    final isMyTurn = game.isPlayerTurn(currentPlayer.userId!);
    final canAcceptDrop = isMyTurn && game.phase == GamePhase.playing;

    return DragTarget<CardModel>(
      onWillAcceptWithDetails: (details) => canAcceptDrop,
      onAcceptWithDetails: (details) {
        _playCard(context, ref, game.id, currentPlayer.userId!, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isDragging = candidateData.isNotEmpty;

        return Container(
          constraints: const BoxConstraints(
            minWidth: 300,
            minHeight: 300,
          ),
          decoration: BoxDecoration(
            color: isDragging
                ? AppTheme.accentColor.withAlpha(77) // Highlight when dragging
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isDragging
                ? Border.all(
                    color: AppTheme.accentColor,
                    width: 3,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Current trick - ALWAYS render to keep widget mounted
              if (game.currentTrick != null)
                AnimatedTrickDisplay(
                  trick: game.currentTrick!,
                  currentPlayerPosition: currentPlayer.position,
                  game: game,
                ),

              const SizedBox(height: AppTheme.spacingLarge),

              // Turn indicator or drop hint
              if (game.currentTurnPosition != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge,
                    vertical: AppTheme.spacingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: isDragging
                        ? AppTheme.accentColor.withAlpha(128)
                        : AppTheme.accentColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isDragging
                        ? 'Drop here to play'
                        : game.currentTurnPosition == currentPlayer.position
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
      },
    );
  }

  Widget _buildOpponentHand(
    BuildContext context,
    GamePlayer player, {
    required Alignment alignment,
    bool vertical = false,
    double rotation = 0.0,
  }) {
    const cardWidth = 70.0;
    const cardHeight = 98.0;
    const cardOverlapOffset = 30.0;

    final cardCount = player.hand.length;

    return Container(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player name
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSmall,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.displayName,
              style: const TextStyle(
                color: AppTheme.textOnCardColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Cards
          if (vertical)
            SizedBox(
              width: cardHeight, // Swapped because rotated
              height: cardCount == 0
                  ? 0
                  : cardWidth + (cardCount - 1) * cardOverlapOffset,
              child: Stack(
                clipBehavior: Clip.none, // Prevent clipping of rotated cards
                children: [
                  for (int i = 0; i < cardCount; i++)
                    Positioned(
                      top: i * cardOverlapOffset,
                      left: 0,
                      child: Transform.rotate(
                        angle: rotation,
                        child: _buildFaceDownCard(cardWidth, cardHeight),
                      ),
                    ),
                ],
              ),
            )
          else
            SizedBox(
              width: cardCount == 0
                  ? 0
                  : cardWidth + (cardCount - 1) * cardOverlapOffset,
              height: cardHeight,
              child: Stack(
                clipBehavior: Clip.none, // Prevent clipping
                children: [
                  for (int i = 0; i < cardCount; i++)
                    Positioned(
                      left: i * cardOverlapOffset,
                      top: 0,
                      child: _buildFaceDownCard(cardWidth, cardHeight),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFaceDownCard(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppTheme.textPrimaryColor.withAlpha(77), // 0.3 * 255
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.style,
          color: AppTheme.textPrimaryColor.withAlpha(128), // 0.5 * 255
          size: 24,
        ),
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
    const cardWidth = 120.0;
    const cardHeight = 168.0;
    const cardOverlapOffset = 40.0; // How much each card overlaps the previous one
    const hoverOffset = 30.0; // How much card lifts when hovered

    return Container(
      height: 230,
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Center(
        child: SizedBox(
          // Calculate total width needed for stacked cards (full width of last card)
          width: sortedHand.isEmpty
            ? 0
            : cardWidth + (sortedHand.length - 1) * cardOverlapOffset,
          height: cardHeight + hoverOffset, // Extra space for hover effect
          child: Stack(
            clipBehavior: Clip.none, // Allow cards to overflow when hovered
            children: [
              for (int index = 0; index < sortedHand.length; index++)
                Positioned(
                  left: index * cardOverlapOffset,
                  bottom: 0, // Align cards at bottom so they lift upward
                  child: Builder(
                    builder: (context) {
                      final card = sortedHand[index];
                      final canPlay = isMyTurn && game.phase == GamePhase.playing;
                      final isHovered = _hoveredCardIndex == index;

                      final cardWidget = AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        transform: Matrix4.translationValues(
                          0,
                          isHovered && canPlay ? -hoverOffset : 0,
                          0,
                        ),
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
                                    color: Colors.grey.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );

                      return MouseRegion(
                        onEnter: canPlay ? (_) => setState(() => _hoveredCardIndex = index) : null,
                        onExit: canPlay ? (_) => setState(() => _hoveredCardIndex = null) : null,
                        cursor: canPlay ? SystemMouseCursors.click : SystemMouseCursors.basic,
                        child: canPlay
                            ? Draggable<CardModel>(
                                data: card,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 1.2,
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: _buildCardWidget(context, card),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: cardWidget,
                                ),
                                onDragStarted: () {
                                  setState(() => _hoveredCardIndex = null);
                                },
                                child: GestureDetector(
                                  onTapDown: (_) => setState(() => _hoveredCardIndex = index),
                                  onTapUp: (_) => setState(() => _hoveredCardIndex = null),
                                  onTapCancel: () => setState(() => _hoveredCardIndex = null),
                                  onTap: () => _playCard(context, ref, game.id, player.userId!, card),
                                  child: cardWidget,
                                ),
                              )
                            : cardWidget,
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
    final assetPath = 'assets/cards/${card.id}.png';

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
          SizedBox(
            width: 120,
            height: 168,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to text rendering if image not found
                return Container(
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
                );
              },
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
