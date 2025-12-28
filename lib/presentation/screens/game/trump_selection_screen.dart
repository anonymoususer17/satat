import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/card_model.dart';
import '../../providers/game_provider.dart';

class TrumpSelectionScreen extends ConsumerWidget {
  final String gameId;
  final GameModel game;
  final String currentUserId;

  const TrumpSelectionScreen({
    super.key,
    required this.gameId,
    required this.game,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTrumpMaker = game.trumpMakerPosition ==
        game.getPlayerByUserId(currentUserId)?.position;

    if (!isTrumpMaker) {
      return _buildWaitingScreen(context);
    }

    final firstFive = game.trumpMakerFirstFive ?? [];
    final lastFour = game.trumpMakerLastFour;
    final hasPictures = firstFive.any((card) => card.rank.isPicture);
    final reshufflesRemaining = 2 - (game.reshuffleCount ?? 0);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            children: [
              Text(
                'Select Trump',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              if (lastFour == null)
                Text(
                  'Choose a suit from your first 5 cards',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),

        Expanded(
          child: lastFour != null
              ? _buildLastFourSelection(context, ref, lastFour)
              : _buildFirstFiveSelection(
                  context,
                  ref,
                  firstFive,
                  hasPictures,
                  reshufflesRemaining,
                ),
        ),
      ],
    );
  }

  Widget _buildWaitingScreen(BuildContext context) {
    final trumpMaker = game.getPlayerByPosition(game.trumpMakerPosition);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          Text(
            'Waiting for ${trumpMaker.displayName}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            'to select trump suit',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFirstFiveSelection(
    BuildContext context,
    WidgetRef ref,
    List<CardModel> firstFive,
    bool hasPictures,
    int reshufflesRemaining,
  ) {
    // Group cards by suit
    final suitCounts = <CardSuit, int>{};
    for (final card in firstFive) {
      suitCounts[card.suit] = (suitCounts[card.suit] ?? 0) + 1;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Show first 5 cards
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Wrap(
              spacing: AppTheme.spacingMedium,
              children: firstFive.map((card) => _buildCardWidget(card)).toList(),
            ),
          ),

          const SizedBox(height: AppTheme.spacingLarge),

          // Suit selection buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Trump Suit:',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                ...CardSuit.values.map((suit) {
                  final count = suitCounts[suit] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                    child: ElevatedButton(
                      onPressed: () => _selectTrump(context, ref, suit, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: suit.isRed ? Colors.red : Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        '${suit.symbol} ${suit.displayName} ($count cards)',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppTheme.spacingLarge),

                // Defer to last 4
                OutlinedButton(
                  onPressed: () => _deferToLastFour(context, ref),
                  child: const Text('Defer to Last 4 Cards'),
                ),

                const SizedBox(height: AppTheme.spacingSmall),

                // Reshuffle option
                if (!hasPictures && reshufflesRemaining > 0)
                  OutlinedButton(
                    onPressed: () => _requestReshuffle(context, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentColor,
                    ),
                    child: Text(
                      'Reshuffle (No Pictures) - $reshufflesRemaining left',
                    ),
                  ),
                if (!hasPictures && reshufflesRemaining == 0)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingSmall),
                    child: Text(
                      'No reshuffles remaining',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastFourSelection(
    BuildContext context,
    WidgetRef ref,
    List<CardModel> lastFour,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Choose one face-down card',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Text(
          'Its suit will become trump',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingLarge),

        // Show 4 face-down cards
        Wrap(
          spacing: AppTheme.spacingMedium,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () => _selectTrump(context, ref, lastFour[index].suit, true),
              child: _buildFaceDownCard(index + 1),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCardWidget(CardModel card) {
    return Container(
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
    );
  }

  Widget _buildFaceDownCard(int number) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor, width: 2),
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTrump(
    BuildContext context,
    WidgetRef ref,
    CardSuit trumpSuit,
    bool deferred,
  ) async {
    final controller = ref.read(gameControllerProvider.notifier);

    await controller.selectTrump(
      gameId: gameId,
      trumpSuit: trumpSuit,
      deferredToLastFour: deferred,
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

  Future<void> _deferToLastFour(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(gameControllerProvider.notifier);

    await controller.deferTrumpSelection(
      gameId: gameId,
      userId: currentUserId,
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

  Future<void> _requestReshuffle(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(gameControllerProvider.notifier);

    await controller.requestReshuffle(
      gameId: gameId,
      userId: currentUserId,
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
