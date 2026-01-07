import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lobby_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/card_draw_provider.dart';
import '../../widgets/card_draw/card_back_widget.dart';

class CardDrawScreen extends ConsumerStatefulWidget {
  final String lobbyId;

  const CardDrawScreen({
    super.key,
    required this.lobbyId,
  });

  @override
  ConsumerState<CardDrawScreen> createState() => _CardDrawScreenState();
}

class _CardDrawScreenState extends ConsumerState<CardDrawScreen> {
  final Set<int> _processedBotPositions = {};
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final lobbyAsync = ref.watch(lobbyProvider(widget.lobbyId));

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

              return lobbyAsync.when(
                data: (lobby) {
                  // Check if card draw is complete and navigate to result screen
                  if (lobby.cardDraw?.isComplete == true) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        context.go('/card-draw-result/${widget.lobbyId}');
                      }
                    });
                  }

                  // Handle bot picks
                  _handleBotPicks(lobby);

                  return _buildCardDrawScreen(context, lobby, currentUser.id);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
                error: (error, _) {
                  return Center(
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
                          'Failed to load card draw',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        ElevatedButton(
                          onPressed: () => context.go('/lobby/${widget.lobbyId}'),
                          child: const Text('Back to Lobby'),
                        ),
                      ],
                    ),
                  );
                },
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

  Widget _buildCardDrawScreen(
    BuildContext context,
    LobbyModel lobby,
    String currentUserId,
  ) {
    final cardDraw = lobby.cardDraw;

    if (cardDraw == null) {
      return const Center(
        child: Text('Card draw not started'),
      );
    }

    // Find current player's position
    final currentPlayerSlot = lobby.players.firstWhere(
      (p) => p.userId == currentUserId,
      orElse: () => const PlayerSlot(position: -1, isBot: false, isReady: false),
    );

    final hasCurrentPlayerPicked = currentPlayerSlot.position != -1 &&
        cardDraw.playerPicks[currentPlayerSlot.position] != null;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            children: [
              Text(
                'Pick a Card',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                hasCurrentPlayerPicked
                    ? 'Waiting for other players...'
                    : 'Choose any face-down card',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
              ),
            ],
          ),
        ),

        // Player status indicators
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLarge,
            vertical: AppTheme.spacingMedium,
          ),
          child: _buildPlayerStatusIndicators(lobby, cardDraw),
        ),

        // Card grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: _buildCardGrid(
              lobby,
              cardDraw,
              currentPlayerSlot.position,
              hasCurrentPlayerPicked,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerStatusIndicators(LobbyModel lobby, cardDraw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (position) {
        final player = lobby.players[position];
        final hasPicked = cardDraw.playerPicks[position] != null;
        final displayName = player.displayName ?? player.username ?? 'Empty';

        return Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasPicked
                    ? AppTheme.accentColor
                    : AppTheme.surfaceColor,
                border: Border.all(
                  color: hasPicked
                      ? AppTheme.accentColor
                      : AppTheme.textSecondaryColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: hasPicked
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )
                    : Text(
                        '${position + 1}',
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayName,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCardGrid(
    LobbyModel lobby,
    cardDraw,
    int currentPlayerPosition,
    bool hasCurrentPlayerPicked,
  ) {
    final availableCards = cardDraw.availableCards;

    // Create a grid layout for 52 cards (8 columns × 7 rows = 56, show 52)
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 60 / 84, // Card aspect ratio
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 52,
      itemBuilder: (context, index) {
        if (index >= availableCards.length) {
          // Empty space for picked cards
          return const SizedBox.shrink();
        }

        final card = availableCards[index];
        final canPick = !hasCurrentPlayerPicked && currentPlayerPosition != -1;

        return CardBackWidget(
          isEnabled: canPick,
          onTap: canPick
              ? () => _handleCardPick(lobby.id, currentPlayerPosition, card)
              : null,
        );
      },
    );
  }

  void _handleCardPick(String lobbyId, int position, card) {
    final controller = ref.read(cardDrawControllerProvider.notifier);
    controller.pickCard(
      lobbyId: lobbyId,
      position: position,
      card: card,
    );
  }

  void _handleBotPicks(LobbyModel lobby) {
    final cardDraw = lobby.cardDraw;

    if (cardDraw == null || cardDraw.isComplete) {
      return;
    }

    // Check each bot position
    for (int i = 0; i < 4; i++) {
      final player = lobby.players[i];

      // Skip if not a bot, already picked, or already being processed
      if (!player.isBot ||
          cardDraw.playerPicks[i] != null ||
          _processedBotPositions.contains(i)) {
        continue;
      }

      // Mark as being processed
      _processedBotPositions.add(i);

      // Schedule bot pick with random delay (1-2 seconds)
      final delay = Duration(milliseconds: 1000 + _random.nextInt(1000));

      Timer(delay, () {
        // Double-check that bot hasn't picked yet (race condition check)
        final updatedLobby = ref.read(lobbyProvider(widget.lobbyId)).value;
        if (updatedLobby?.cardDraw?.playerPicks[i] == null) {
          final controller = ref.read(cardDrawControllerProvider.notifier);
          controller.botPickCard(
            lobbyId: lobby.id,
            position: i,
            availableCards: cardDraw.availableCards,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _processedBotPositions.clear();
    super.dispose();
  }
}
