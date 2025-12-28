import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/friends_provider.dart';

class AddFriendDialog extends ConsumerStatefulWidget {
  final UserModel currentUser;

  const AddFriendDialog({
    super.key,
    required this.currentUser,
  });

  @override
  ConsumerState<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends ConsumerState<AddFriendDialog> {
  final _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final controller = ref.read(friendsControllerProvider.notifier);
      final results = await controller.searchUsers(query);

      // Filter out current user and existing friends
      final filteredResults = results.where((user) {
        return user.id != widget.currentUser.id &&
            !widget.currentUser.friends.contains(user.id);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: ${e.toString()}';
        _isSearching = false;
      });
    }
  }

  Future<void> _sendFriendRequest(UserModel user) async {
    try {
      final controller = ref.read(friendsControllerProvider.notifier);
      await controller.sendFriendRequest(
        fromUserId: widget.currentUser.id,
        fromUsername: widget.currentUser.username,
        fromDisplayName: widget.currentUser.displayName,
        toUserId: user.id,
        toUsername: user.username,
        toDisplayName: user.displayName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend request sent to ${user.displayName}'),
            backgroundColor: AppTheme.accentColor,
          ),
        );

        // Remove from search results
        setState(() {
          _searchResults.removeWhere((u) => u.id == user.id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Friend',
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
            const SizedBox(height: AppTheme.spacingMedium),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              onChanged: (value) {
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _performSearch();
                  }
                });
              },
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: AppTheme.spacingMedium),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppTheme.errorColor),
                  textAlign: TextAlign.center,
                ),
              ),

            // Search results
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Search for friends by username',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'No users found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.accentColor,
              child: Text(
                user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.displayName,
              style: const TextStyle(
                color: AppTheme.textOnCardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '@${user.username}',
              style: const TextStyle(color: AppTheme.textSecondaryColor),
            ),
            trailing: ElevatedButton.icon(
              onPressed: () => _sendFriendRequest(user),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
