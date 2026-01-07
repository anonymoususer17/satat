import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lobby_model.dart';
import '../../../data/models/card_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/game_provider.dart';

class CardDrawResultScreen extends ConsumerStatefulWidget {
  final String lobbyId;

  const CardDrawResultScreen({
    super.key,
    required this.lobbyId,
  });

  @override
  ConsumerState<CardDrawResultScreen> createState() =>
      _CardDrawResultScreenState();
}

class _CardDrawResultScreenState extends ConsumerState<CardDrawResultScreen> {
  int _countdown = 3;
  Timer? _countdownTimer;
  bool _isCreatingGame = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _createGameAndNavigate();
      }
    });
  }

  Future<void> _createGameAndNavigate() async {
    if (_isCreatingGame) return;

    setState(() {
      _isCreatingGame = true;
    });

    final lobby = await ref.read(lobbyProvider(widget.lobbyId).future);

    if (lobby.cardDraw == null || !lobby.cardDraw!.isComplete) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card draw not complete')),
        );
      }
      return;
    }

    final winningTeam = lobby.cardDraw!.winningTeam!;

    // Create game with winning team starting
    final gameController = ref.read(gameControllerProvider.notifier);
    final game = await gameController.createGameFromCardDraw(
      lobbyId: widget.lobbyId,
      lobbyPlayers: lobby.players.map((p) => {
        'position': p.position,
        'userId': p.userId,
        'username': p.username ?? '',
        'displayName': p.displayName ?? '',
        'isBot': p.isBot,
      }).toList(),
      winningTeam: winningTeam,
      team0Name: lobby.team0Name,
      team1Name: lobby.team1Name,
    );

    if (game != null && mounted) {
      context.go('/game/${game.id}');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create game')),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

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
                  if (lobby.cardDraw == null || !lobby.cardDraw!.isComplete) {
                    return const Center(
                      child: Text('Card draw not complete'),
                    );
                  }

                  return _buildResultScreen(context, lobby);
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
                          'Failed to load results',
                          style: Theme.of(context).textTheme.titleLarge,
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

  Widget _buildResultScreen(BuildContext context, LobbyModel lobby) {
    final cardDraw = lobby.cardDraw!;
    final winningPosition = cardDraw.winningPosition!;
    final winningTeam = cardDraw.winningTeam!;
    final teamName = winningTeam == 0 ? lobby.team0Name : lobby.team1Name;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            'Card Draw Results',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppTheme.spacingLarge),

          // Winner announcement
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacingMedium,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  '$teamName Starts!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingXLarge),

          // Display all 4 picked cards
          Wrap(
            spacing: AppTheme.spacingMedium,
            runSpacing: AppTheme.spacingMedium,
            alignment: WrapAlignment.center,
            children: List.generate(4, (position) {
              final player = lobby.players[position];
              final card = cardDraw.playerPicks[position]!;
              final isWinner = position == winningPosition;

              return _buildPlayerCard(
                context,
                player,
                card,
                isWinner,
              );
            }),
          ),

          const SizedBox(height: AppTheme.spacingXLarge),

          // Countdown
          if (!_isCreatingGame) ...[
            Text(
              'Starting game in...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withOpacity(0.2),
                border: Border.all(
                  color: AppTheme.accentColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ] else ...[
            const CircularProgressIndicator(
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Creating game...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    PlayerSlot player,
    CardModel card,
    bool isWinner,
  ) {
    final assetPath = 'assets/cards/${card.id}.png';
    final displayName = player.displayName ?? player.username ?? 'Player';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isWinner
            ? Border.all(
                color: AppTheme.accentColor,
                width: 3,
              )
            : null,
        boxShadow: isWinner
            ? [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          // Player name
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMedium,
              vertical: AppTheme.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: isWinner
                  ? AppTheme.accentColor
                  : AppTheme.surfaceColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isWinner) ...[
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  displayName,
                  style: TextStyle(
                    color: isWinner ? Colors.white : AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Card image
          SizedBox(
            width: 100,
            height: 140,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback rendering
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
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
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
