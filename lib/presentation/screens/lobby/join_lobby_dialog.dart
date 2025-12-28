import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/lobby_provider.dart';

class JoinLobbyDialog extends ConsumerStatefulWidget {
  final UserModel currentUser;

  const JoinLobbyDialog({
    super.key,
    required this.currentUser,
  });

  @override
  ConsumerState<JoinLobbyDialog> createState() => _JoinLobbyDialogState();
}

class _JoinLobbyDialogState extends ConsumerState<JoinLobbyDialog> {
  final _codeController = TextEditingController();
  bool _isJoining = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinLobby() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a lobby code'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lobby code must be 6 digits'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isJoining = true);

    final controller = ref.read(lobbyControllerProvider.notifier);
    final lobby = await controller.joinLobbyByCode(
      code: code,
      userId: widget.currentUser.id,
      username: widget.currentUser.username,
      displayName: widget.currentUser.displayName,
    );

    if (!mounted) return;

    setState(() => _isJoining = false);

    if (lobby != null) {
      Navigator.of(context).pop();
      context.push('/lobby/${lobby.id}');
    } else {
      final state = ref.read(lobbyControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.hasError
                ? state.error.toString()
                : 'Failed to join lobby',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Join Lobby',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textOnCardColor,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppTheme.textOnCardColor,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Code input
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Lobby Code',
                hintText: 'Enter 6-digit code',
                prefixIcon: Icon(Icons.tag),
              ),
              enabled: !_isJoining,
              onSubmitted: (_) => _joinLobby(),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Join button
            ElevatedButton(
              onPressed: _isJoining ? null : _joinLobby,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.textPrimaryColor,
              ),
              child: _isJoining
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.textPrimaryColor,
                      ),
                    )
                  : const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
