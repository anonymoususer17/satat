import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lobby_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import '../../providers/game_provider.dart';

class LobbyRoomScreen extends ConsumerWidget {
  final String lobbyId;

  const LobbyRoomScreen({
    super.key,
    required this.lobbyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final lobbyAsync = ref.watch(lobbyProvider(lobbyId));

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
                data: (lobby) => _buildLobbyRoom(context, ref, lobby, currentUser.id),
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
                          'Lobby not found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go Back'),
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

  Widget _buildLobbyRoom(
    BuildContext context,
    WidgetRef ref,
    LobbyModel lobby,
    String currentUserId,
  ) {
    final isHost = lobby.hostUserId == currentUserId;
    final currentPlayerSlot = lobby.players.firstWhere(
      (p) => p.userId == currentUserId,
      orElse: () => const PlayerSlot(position: -1, isBot: false, isReady: false),
    );
    final isInLobby = currentPlayerSlot.position != -1;
    // Host is always considered ready (they control when to start)
    final allPlayersReady = lobby.players
        .where((p) => p.userId != null || p.isBot)
        .every((p) => p.isReady || p.userId == lobby.hostUserId);
    final lobbyFull = lobby.players.every((p) => p.userId != null || p.isBot);

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
                    onPressed: () async {
                      if (isInLobby) {
                        await _leaveLobby(ref, lobby.id, currentUserId);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lobby',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        'Code: ${lobby.code}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                color: AppTheme.accentColor,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: lobby.code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lobby code copied!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Copy code',
              ),
            ],
          ),
        ),

        // Player Slots (4 positions: 0&2 = Team 1, 1&3 = Team 2)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
            child: Column(
              children: [
                _TeamNameSection(
                  lobbyId: lobby.id,
                  teamNumber: 0,
                  teamName: lobby.team0Name,
                  editingBy: lobby.team0EditingBy,
                  currentUserId: currentUserId,
                  isCurrentUserOnTeam: currentPlayerSlot.position == 0 || currentPlayerSlot.position == 2,
                  teamColor: AppTheme.accentColor,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _PlayerSlotCard(
                  slot: lobby.players[0],
                  teamColor: AppTheme.accentColor,
                  isHost: lobby.players[0].userId == lobby.hostUserId,
                  canManage: isHost && lobby.players[0].userId != currentUserId,
                  onAddBot: () => _addBot(ref, lobby.id, 0),
                  onRemove: () => _removePlayer(ref, lobby.id, 0, currentUserId),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _PlayerSlotCard(
                  slot: lobby.players[2],
                  teamColor: AppTheme.accentColor,
                  isHost: lobby.players[2].userId == lobby.hostUserId,
                  canManage: isHost && lobby.players[2].userId != currentUserId,
                  onAddBot: () => _addBot(ref, lobby.id, 2),
                  onRemove: () => _removePlayer(ref, lobby.id, 2, currentUserId),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _TeamNameSection(
                  lobbyId: lobby.id,
                  teamNumber: 1,
                  teamName: lobby.team1Name,
                  editingBy: lobby.team1EditingBy,
                  currentUserId: currentUserId,
                  isCurrentUserOnTeam: currentPlayerSlot.position == 1 || currentPlayerSlot.position == 3,
                  teamColor: AppTheme.primaryColor,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _PlayerSlotCard(
                  slot: lobby.players[1],
                  teamColor: AppTheme.primaryColor,
                  isHost: lobby.players[1].userId == lobby.hostUserId,
                  canManage: isHost && lobby.players[1].userId != currentUserId,
                  onAddBot: () => _addBot(ref, lobby.id, 1),
                  onRemove: () => _removePlayer(ref, lobby.id, 1, currentUserId),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _PlayerSlotCard(
                  slot: lobby.players[3],
                  teamColor: AppTheme.primaryColor,
                  isHost: lobby.players[3].userId == lobby.hostUserId,
                  canManage: isHost && lobby.players[3].userId != currentUserId,
                  onAddBot: () => _addBot(ref, lobby.id, 3),
                  onRemove: () => _removePlayer(ref, lobby.id, 3, currentUserId),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
              ],
            ),
          ),
        ),

        // Bottom Actions
        if (isInLobby)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ready Button (for non-host players)
                if (!isHost)
                  ElevatedButton.icon(
                    onPressed: () => _toggleReady(ref, lobby.id, currentUserId),
                    icon: Icon(
                      currentPlayerSlot.isReady ? Icons.check_circle : Icons.circle_outlined,
                    ),
                    label: Text(
                      currentPlayerSlot.isReady ? 'Ready!' : 'Ready Up',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentPlayerSlot.isReady
                          ? AppTheme.accentColor
                          : AppTheme.primaryColor,
                      foregroundColor: AppTheme.textPrimaryColor,
                    ),
                  ),

                // Start Game Button (host only)
                if (isHost) ...[
                  ElevatedButton.icon(
                    onPressed: allPlayersReady && lobbyFull
                        ? () => _startGame(context, ref, lobby.id)
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (!allPlayersReady || !lobbyFull)
                    Padding(
                      padding: const EdgeInsets.only(top: AppTheme.spacingSmall),
                      child: Text(
                        !lobbyFull
                            ? 'Need 4 players to start'
                            : 'Waiting for all players to be ready',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],

                const SizedBox(height: AppTheme.spacingMedium),

                // Leave/Delete Lobby Button
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await _leaveLobby(ref, lobby.id, currentUserId);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Leave Lobby'),
                      ),
                    ),
                    if (isHost) ...[
                      const SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _deleteLobby(context, ref, lobby.id),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.errorColor,
                          ),
                          child: const Text('Delete Lobby'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _addBot(WidgetRef ref, String lobbyId, int position) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    await controller.addBot(lobbyId: lobbyId, position: position);
  }

  Future<void> _removePlayer(
    WidgetRef ref,
    String lobbyId,
    int position,
    String requestingUserId,
  ) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    await controller.removePlayerFromSlot(
      lobbyId: lobbyId,
      position: position,
      requestingUserId: requestingUserId,
    );
  }

  Future<void> _toggleReady(
    WidgetRef ref,
    String lobbyId,
    String userId,
  ) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    await controller.toggleReady(lobbyId: lobbyId, userId: userId);
  }

  Future<void> _leaveLobby(
    WidgetRef ref,
    String lobbyId,
    String userId,
  ) async {
    final controller = ref.read(lobbyControllerProvider.notifier);
    await controller.leaveLobby(lobbyId: lobbyId, userId: userId);
  }

  Future<void> _startGame(BuildContext context, WidgetRef ref, String lobbyId) async {
    try {
      // Get lobby data to create game
      final lobbyAsync = ref.read(lobbyProvider(lobbyId));
      final lobby = lobbyAsync.value;

      if (lobby == null) {
        throw Exception('Lobby not found');
      }

      // Prepare lobby players data for game creation
      final lobbyPlayers = lobby.players.map((p) => {
            'userId': p.userId,
            'username': p.username ?? 'Unknown',
            'displayName': p.displayName ?? p.username ?? 'Unknown',
            'isBot': p.isBot,
          }).toList();

      // Create game (dealer is position 0 for first game)
      final gameController = ref.read(gameControllerProvider.notifier);
      final game = await gameController.createGame(
        lobbyId: lobbyId,
        lobbyPlayers: lobbyPlayers,
        dealerPosition: 0,
        team0Name: lobby.team0Name,
        team1Name: lobby.team1Name,
      );

      if (game != null && context.mounted) {
        // Navigate to game screen
        context.push('/game/${game.id}');
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create game'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting game: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteLobby(
    BuildContext context,
    WidgetRef ref,
    String lobbyId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lobby'),
        content: const Text(
          'Are you sure you want to delete this lobby? All players will be kicked.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // Delete lobby by having host leave (which deletes if they're last)
      // Or we can add a dedicated delete method
      await ref.read(lobbyRepositoryProvider).leaveLobby(
            lobbyId: lobbyId,
            userId: ref.read(currentUserProvider).value!.id,
          );

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lobby deleted'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
      }
    }
  }
}

// Player Slot Card Widget
class _PlayerSlotCard extends StatelessWidget {
  final PlayerSlot slot;
  final Color teamColor;
  final bool isHost;
  final bool canManage;
  final VoidCallback onAddBot;
  final VoidCallback onRemove;

  const _PlayerSlotCard({
    required this.slot,
    required this.teamColor,
    required this.isHost,
    required this.canManage,
    required this.onAddBot,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = slot.userId == null && !slot.isBot;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isEmpty ? AppTheme.textSecondaryColor : teamColor,
          child: isEmpty
              ? const Icon(Icons.person_add_outlined,
                  color: AppTheme.textPrimaryColor)
              : Text(
                  slot.isBot
                      ? 'B'
                      : (slot.username?.isNotEmpty == true
                          ? slot.username![0].toUpperCase()
                          : '?'),
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          isEmpty
              ? 'Empty Slot'
              : slot.displayName ?? slot.username ?? 'Unknown',
          style: TextStyle(
            color: isEmpty ? AppTheme.textSecondaryColor : AppTheme.textOnCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isEmpty
              ? 'Waiting for player...'
              : slot.isBot
                  ? 'Bot'
                  : isHost
                      ? 'Host ${slot.isReady ? "• Ready" : ""}'
                      : slot.isReady
                          ? 'Ready'
                          : 'Not ready',
          style: TextStyle(
            color: slot.isReady ? AppTheme.accentColor : AppTheme.textSecondaryColor,
          ),
        ),
        trailing: isEmpty && canManage
            ? IconButton(
                icon: const Icon(Icons.smart_toy),
                color: AppTheme.accentColor,
                onPressed: onAddBot,
                tooltip: 'Add Bot',
              )
            : canManage
                ? IconButton(
                    icon: const Icon(Icons.close),
                    color: AppTheme.errorColor,
                    onPressed: onRemove,
                    tooltip: 'Remove',
                  )
                : slot.isReady
                    ? const Icon(Icons.check_circle, color: AppTheme.accentColor)
                    : null,
      ),
    );
  }
}

// Team Name Section Widget
class _TeamNameSection extends ConsumerStatefulWidget {
  final String lobbyId;
  final int teamNumber;
  final String teamName;
  final String? editingBy;
  final String currentUserId;
  final bool isCurrentUserOnTeam;
  final Color teamColor;

  const _TeamNameSection({
    required this.lobbyId,
    required this.teamNumber,
    required this.teamName,
    required this.editingBy,
    required this.currentUserId,
    required this.isCurrentUserOnTeam,
    required this.teamColor,
  });

  @override
  ConsumerState<_TeamNameSection> createState() => _TeamNameSectionState();
}

class _TeamNameSectionState extends ConsumerState<_TeamNameSection> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.teamName);
  }

  @override
  void didUpdateWidget(_TeamNameSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update editing state based on lock
    if (widget.editingBy == widget.currentUserId && !_isEditing) {
      setState(() {
        _isEditing = true;
        _controller.text = widget.teamName;
      });
    } else if (widget.editingBy != widget.currentUserId && _isEditing) {
      setState(() {
        _isEditing = false;
      });
    }
    // Update controller if team name changed externally
    if (widget.teamName != oldWidget.teamName && !_isEditing) {
      _controller.text = widget.teamName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startEditing() async {
    try {
      await ref.read(lobbyControllerProvider.notifier).lockTeamNameEdit(
            lobbyId: widget.lobbyId,
            team: widget.teamNumber,
            userId: widget.currentUserId,
          );
      setState(() {
        _isEditing = true;
        _controller.text = widget.teamName;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _saveTeamName() async {
    final newName = _controller.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team name cannot be empty'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (newName.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team name cannot exceed 20 characters'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      await ref.read(lobbyControllerProvider.notifier).updateTeamName(
            lobbyId: widget.lobbyId,
            team: widget.teamNumber,
            newName: newName,
            userId: widget.currentUserId,
          );
      setState(() {
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team name updated'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _cancelEditing() async {
    try {
      await ref.read(lobbyControllerProvider.notifier).cancelTeamNameEdit(
            lobbyId: widget.lobbyId,
            team: widget.teamNumber,
            userId: widget.currentUserId,
          );
      setState(() {
        _isEditing = false;
        _controller.text = widget.teamName;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLockedByTeammate = widget.editingBy != null &&
                                widget.editingBy != widget.currentUserId;
    final isLockedByCurrentUser = widget.editingBy == widget.currentUserId;

    if (_isEditing || isLockedByCurrentUser) {
      // Editing mode
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: widget.teamColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: 'Team Name',
                hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.teamColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.teamColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.teamColor, width: 2),
                ),
              ),
              maxLength: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          IconButton(
            icon: const Icon(Icons.check),
            color: AppTheme.accentColor,
            onPressed: _saveTeamName,
            tooltip: 'Save',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: AppTheme.errorColor,
            onPressed: _cancelEditing,
            tooltip: 'Cancel',
          ),
        ],
      );
    }

    if (isLockedByTeammate) {
      // Locked by teammate
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.teamName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: widget.teamColor,
                ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            '(teammate editing...)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      );
    }

    // Display mode
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.teamName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: widget.teamColor,
              ),
        ),
        if (widget.isCurrentUserOnTeam) ...[
          const SizedBox(width: AppTheme.spacingSmall),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: widget.teamColor,
            onPressed: _startEditing,
            tooltip: 'Edit team name',
          ),
        ],
      ],
    );
  }
}
