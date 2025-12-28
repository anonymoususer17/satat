import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/friends_provider.dart';
import 'add_friend_dialog.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final friendsAsync = ref.watch(friendsListProvider);
    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);

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
                              'Friends',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_add),
                          color: AppTheme.accentColor,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddFriendDialog(
                                currentUser: currentUser,
                              ),
                            );
                          },
                          tooltip: 'Add Friend',
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLarge,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Received Requests Section
                          receivedRequestsAsync.when(
                            data: (requests) {
                              if (requests.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Friend Requests (${requests.length})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: AppTheme.spacingMedium),
                                  ...requests.map((request) =>
                                      _FriendRequestCard(
                                        request: request,
                                        currentUserId: currentUser.id,
                                      )),
                                  const SizedBox(height: AppTheme.spacingLarge),
                                ],
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, _) => Text('Error: $error'),
                          ),

                          // Sent Requests Section
                          sentRequestsAsync.when(
                            data: (requests) {
                              if (requests.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sent Requests (${requests.length})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: AppTheme.spacingMedium),
                                  ...requests.map((request) =>
                                      _SentRequestCard(request: request)),
                                  const SizedBox(height: AppTheme.spacingLarge),
                                ],
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (error, _) => const SizedBox.shrink(),
                          ),

                          // Friends List Section
                          Text(
                            'My Friends',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          friendsAsync.when(
                            data: (friends) {
                              if (friends.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        AppTheme.spacingXLarge),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.people_outline,
                                          size: 64,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                        const SizedBox(
                                            height: AppTheme.spacingMedium),
                                        Text(
                                          'No friends yet',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(
                                            height: AppTheme.spacingSmall),
                                        Text(
                                          'Tap the + button to add friends',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: friends
                                    .map((friend) => _FriendCard(
                                          friend: friend,
                                          currentUserId: currentUser.id,
                                        ))
                                    .toList(),
                              );
                            },
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppTheme.spacingXLarge),
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            error: (error, stack) => Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(AppTheme.spacingLarge),
                                child: Text(
                                  'Error loading friends: $error',
                                  style: const TextStyle(
                                      color: AppTheme.errorColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXLarge),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
            error: (error, _) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
    );
  }
}

// Friend Card Widget
class _FriendCard extends ConsumerWidget {
  final UserModel friend;
  final String currentUserId;

  const _FriendCard({
    required this.friend,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accentColor,
          child: Text(
            friend.username.isNotEmpty ? friend.username[0].toUpperCase() : '?',
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.displayName,
          style: const TextStyle(
            color: AppTheme.textOnCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '@${friend.username}',
          style: const TextStyle(color: AppTheme.textSecondaryColor),
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: AppTheme.textOnCardColor),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.person_remove, color: AppTheme.errorColor),
                  SizedBox(width: AppTheme.spacingSmall),
                  Text('Remove Friend'),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'remove') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Friend'),
                  content: Text(
                      'Are you sure you want to remove ${friend.displayName} from your friends?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                final controller = ref.read(friendsControllerProvider.notifier);
                await controller.removeFriend(
                  userId: currentUserId,
                  friendId: friend.id,
                );

                if (context.mounted) {
                  ref.invalidate(friendsListProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend removed')),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}

// Friend Request Card Widget (Received)
class _FriendRequestCard extends ConsumerWidget {
  final dynamic request; // FriendRequestModel
  final String currentUserId;

  const _FriendRequestCard({
    required this.request,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            request.fromUsername.isNotEmpty
                ? request.fromUsername[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          request.fromDisplayName,
          style: const TextStyle(
            color: AppTheme.textOnCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '@${request.fromUsername}',
          style: const TextStyle(color: AppTheme.textSecondaryColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: AppTheme.accentColor),
              onPressed: () async {
                final controller = ref.read(friendsControllerProvider.notifier);
                await controller.acceptFriendRequest(request.id);

                if (context.mounted) {
                  ref.invalidate(friendsListProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request accepted')),
                  );
                }
              },
              tooltip: 'Accept',
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppTheme.errorColor),
              onPressed: () async {
                final controller = ref.read(friendsControllerProvider.notifier);
                await controller.rejectFriendRequest(request.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request rejected')),
                  );
                }
              },
              tooltip: 'Reject',
            ),
          ],
        ),
      ),
    );
  }
}

// Sent Request Card Widget
class _SentRequestCard extends ConsumerWidget {
  final dynamic request; // FriendRequestModel

  const _SentRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.textSecondaryColor,
          child: Text(
            request.toUsername.isNotEmpty
                ? request.toUsername[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          request.toDisplayName,
          style: const TextStyle(
            color: AppTheme.textOnCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '@${request.toUsername} • Pending',
          style: const TextStyle(color: AppTheme.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel, color: AppTheme.errorColor),
          onPressed: () async {
            final controller = ref.read(friendsControllerProvider.notifier);
            await controller.cancelFriendRequest(request.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend request cancelled')),
              );
            }
          },
          tooltip: 'Cancel',
        ),
      ),
    );
  }
}
