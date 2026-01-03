import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              // If user is null, show loading (don't auto-sign-out during registration)
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Image
                    Center(
                      child: Image.asset(
                        'assets/title/satat.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

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

                    // Menu Section
                    Text(
                      'Menu',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Friends Button
                    _MenuButton(
                      icon: Icons.people,
                      title: 'Friends',
                      subtitle: 'Manage your friends list',
                      onTap: () => context.push('/friends'),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Lobby Button
                    _MenuButton(
                      icon: Icons.meeting_room,
                      title: 'Lobby',
                      subtitle: 'Create or join a game',
                      onTap: () => context.push('/lobby'),
                      isDisabled: false,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Game History Button (Coming Soon)
                    _MenuButton(
                      icon: Icons.history,
                      title: 'Game History',
                      subtitle: 'Coming soon',
                      onTap: null,
                      isDisabled: true,
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
            error: (error, stack) {
              // Auto sign out on error and redirect to login
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(authControllerProvider.notifier).signOut();
              });

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
                      'Error loading user data',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      'Signing out...',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    const CircularProgressIndicator(
                      color: AppTheme.errorColor,
                    ),
                  ],
                ),
              );
            },
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

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Card(
        child: ListTile(
          leading: Icon(
            icon,
            color: isDisabled ? AppTheme.textSecondaryColor : AppTheme.accentColor,
            size: 32,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDisabled ? AppTheme.textSecondaryColor : AppTheme.textOnCardColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isDisabled ? AppTheme.textSecondaryColor : AppTheme.textOnCardColor,
          ),
          onTap: isDisabled ? null : onTap,
          enabled: !isDisabled,
        ),
      ),
    );
  }
}
