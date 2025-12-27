import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              // If user is null, sign out and go back to login
              if (user == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(authControllerProvider.notifier).signOut();
                });
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              user.displayName,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          color: AppTheme.textPrimaryColor,
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).signOut();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Stats Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Stats',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.textOnCardColor,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            _StatRow(
                              label: 'Games Played',
                              value: user.stats.gamesPlayed.toString(),
                            ),
                            _StatRow(
                              label: 'Games Won',
                              value: user.stats.gamesWon.toString(),
                            ),
                            _StatRow(
                              label: 'Games Lost',
                              value: user.stats.gamesLost.toString(),
                            ),
                            _StatRow(
                              label: 'Total Tricks',
                              value: user.stats.totalTricks.toString(),
                            ),
                            _StatRow(
                              label: 'Perfect Wins',
                              value: user.stats.perfectWins.toString(),
                            ),
                            const SizedBox(height: AppTheme.spacingSmall),
                            if (user.stats.gamesPlayed > 0)
                              Text(
                                'Win Rate: ${((user.stats.gamesWon / user.stats.gamesPlayed) * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // Coming Soon section
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.construction,
                              size: 64,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            Text(
                              'More features coming soon!',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacingSmall),
                            Text(
                              'Next: Friends system & Lobby',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
            error: (error, stack) => Center(
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
                    'Error loading user data',
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
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textOnCardColor,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textOnCardColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
