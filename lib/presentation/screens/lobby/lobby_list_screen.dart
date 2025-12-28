import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import 'join_lobby_dialog.dart';

class LobbyListScreen extends ConsumerWidget {
  const LobbyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final activeLobbiesAsync = ref.watch(activeLobbiesProvider);

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

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: AppTheme.textPrimaryColor,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: AppTheme.spacingSmall),
                            Text(
                              'Lobbies',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _createLobby(context, ref, currentUser.id, currentUser.username),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Lobby'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => JoinLobbyDialog(
                                  currentUser: currentUser,
                                ),
                              );
                            },
                            icon: const Icon(Icons.login),
                            label: const Text('Join by Code'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),

                  // Lobbies List
                  Expanded(
                    child: activeLobbiesAsync.when(
                      data: (lobbies) {
                        if (lobbies.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.meeting_room_outlined,
                                  size: 64,
                                  color: AppTheme.textSecondaryColor,
                                ),
                                const SizedBox(height: AppTheme.spacingMedium),
                                Text(
                                  'No active lobbies',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppTheme.spacingSmall),
                                Text(
                                  'Create one to get started!',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLarge,
                          ),
                          itemCount: lobbies.length,
                          itemBuilder: (context, index) {
                            final lobby = lobbies[index];
                            final playerCount = lobby.players.where((p) => p.userId != null || p.isBot).length;
                            final isUserInLobby = lobby.players.any((p) => p.userId == currentUser.id);

                            return Card(
                              margin: const EdgeInsets.only(
                                bottom: AppTheme.spacingMedium,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.accentColor,
                                  child: Text(
                                    playerCount.toString(),
                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${lobby.hostUsername}\'s Lobby',
                                  style: const TextStyle(
                                    color: AppTheme.textOnCardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Code: ${lobby.code} • $playerCount/4 players',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                                trailing: Icon(
                                  isUserInLobby ? Icons.check_circle : Icons.chevron_right,
                                  color: isUserInLobby ? AppTheme.accentColor : AppTheme.textOnCardColor,
                                ),
                                onTap: () => _openLobby(
                                  context,
                                  ref,
                                  lobby.id,
                                  isUserInLobby,
                                  currentUser.id,
                                  currentUser.username,
                                  currentUser.displayName,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      error: (error, _) => Center(
                        child: Text(
                          'Error loading lobbies: $error',
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ),
                  ),
                ],
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

  Future<void> _createLobby(
    BuildContext context,
    WidgetRef ref,
    String hostUserId,
    String hostUsername,
  ) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    final lobby = await controller.createLobby(
      hostUserId: hostUserId,
      hostUsername: hostUsername,
    );

    if (lobby != null && context.mounted) {
      context.push('/lobby/${lobby.id}');
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create lobby'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _joinLobby(
    BuildContext context,
    WidgetRef ref,
    String lobbyId,
    String userId,
    String username,
    String displayName,
  ) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    await controller.joinLobby(
      lobbyId: lobbyId,
      userId: userId,
      username: username,
      displayName: displayName,
    );

    final state = ref.read(lobbyControllerProvider);
    if (state.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error.toString()),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } else if (context.mounted) {
      context.push('/lobby/$lobbyId');
    }
  }

  Future<void> _openLobby(
    BuildContext context,
    WidgetRef ref,
    String lobbyId,
    bool isUserInLobby,
    String userId,
    String username,
    String displayName,
  ) async {
    // If user is already in lobby, just navigate
    if (isUserInLobby) {
      if (context.mounted) {
        context.push('/lobby/$lobbyId');
      }
      return;
    }

    // Otherwise, join first then navigate
    await _joinLobby(context, ref, lobbyId, userId, username, displayName);
  }
}
