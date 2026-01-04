import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/card_model.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/trick_model.dart';

/// Animated display of the current trick
/// Shows cards flying from player positions to center when played
class AnimatedTrickDisplay extends StatefulWidget {
  final TrickModel trick;
  final int currentPlayerPosition;
  final GameModel game;

  const AnimatedTrickDisplay({
    super.key,
    required this.trick,
    required this.currentPlayerPosition,
    required this.game,
  });

  @override
  State<AnimatedTrickDisplay> createState() => _AnimatedTrickDisplayState();
}

class _AnimatedTrickDisplayState extends State<AnimatedTrickDisplay> {
  // Index of card currently animating (null if none)
  int? _animatingCardIndex;

  // Whether the animating card has been positioned at start (before animation begins)
  bool _animationStarted = false;

  // Store last completed trick to show it briefly before clearing
  TrickModel? _displayedTrick;

  // Whether we're in the "showing completed trick" pause state
  bool _showingCompletedTrick = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current trick
    _displayedTrick = widget.trick;
  }

  @override
  void didUpdateWidget(AnimatedTrickDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If we're showing a completed trick, don't process new updates yet
    if (_showingCompletedTrick) {
      return;
    }

    final currentLength = widget.trick.cardsPlayed.length;
    final oldLength = oldWidget.trick.cardsPlayed.length;
    final currentTrickNum = widget.trick.trickNumber;
    final oldTrickNum = oldWidget.trick.trickNumber;

    // CRITICAL: Detect trick completion by checking if trick number changed
    // AND old trick had 3+ cards (meaning it was close to completion)
    if (oldTrickNum != currentTrickNum && oldLength >= 3) {
      // Find the completed trick in game.completedTricks (has all 4 cards!)
      final completedTrick = widget.game.completedTricks.isNotEmpty
          ? widget.game.completedTricks.last
          : oldWidget.trick;

      setState(() {
        _showingCompletedTrick = true;
        _displayedTrick = completedTrick; // Use completed trick with all 4 cards!
      });

      // Wait for pause, then allow clearing
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) {
          setState(() {
            _showingCompletedTrick = false;
            _displayedTrick = widget.trick;
          });
        }
      });

      return; // Don't process other logic
    }

    // Detect if a new card was played (normal case)
    if (currentLength > oldLength) {
      final newCardIndex = currentLength - 1;
      final newCard = widget.trick.cardsPlayed[newCardIndex];

      // Calculate relative position
      final relativePos = (newCard.position - widget.currentPlayerPosition) % 4;

      // Update displayed trick
      _displayedTrick = widget.trick;

      // Only animate if it's NOT the current player's card
      // Skip if already animating another card (prevent visual chaos with bots)
      if (relativePos != 0 && _animatingCardIndex == null) {
        setState(() {
          _animatingCardIndex = newCardIndex;
          _animationStarted = false;
        });

        // On next frame, trigger the animation by setting _animationStarted = true
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _animationStarted = true;
            });
          }
        });

        // Clear animation flag after duration
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) {
            setState(() {
              _animatingCardIndex = null;
              _animationStarted = false;
            });
          }
        });
      }
    } else if (currentLength < oldLength) {
      // Trick was cleared (but not a completion, already handled above)
      if (!_showingCompletedTrick) {
        _displayedTrick = widget.trick;
        _animatingCardIndex = null;
        _animationStarted = false;
      }
    } else {
      // Same length, just update if not showing completed
      if (!_showingCompletedTrick) {
        _displayedTrick = widget.trick;
      }
    }
  }

  /// Calculate start position for a card based on player's relative position
  Offset _getStartOffset(int position, Size containerSize) {
    final relativePos = (position - widget.currentPlayerPosition) % 4;
    final centerX = containerSize.width / 2;
    final centerY = containerSize.height / 2;

    switch (relativePos) {
      case 0: // Current player (bottom) - should not animate
        return Offset(centerX - 60, centerY - 84);
      case 1: // Right player
        return Offset(containerSize.width + 50, centerY - 84);
      case 2: // Opposite player (top)
        return Offset(centerX - 60, -200);
      case 3: // Left player
        return Offset(-170, centerY - 84);
      default:
        return Offset(centerX - 60, centerY - 84);
    }
  }

  /// Calculate final position for a card in the center display
  Offset _getCenterOffset(int cardIndex, int totalCards, Size containerSize) {
    final centerX = containerSize.width / 2;
    final centerY = containerSize.height / 2;

    // Card dimensions (same as in game_screen.dart)
    const cardWidth = 120.0;
    const spacing = 16.0; // AppTheme.spacingMedium

    // Calculate total width of all cards
    final totalWidth = (totalCards * cardWidth) + ((totalCards - 1) * spacing);

    // Start position to center all cards
    final startX = centerX - (totalWidth / 2);

    // Position for this specific card
    final cardX = startX + (cardIndex * (cardWidth + spacing));
    final cardY = centerY - 84; // Center vertically (card height is 168, so 168/2 = 84)

    return Offset(cardX, cardY);
  }

  /// Build a single card widget with optional label
  Widget _buildCardWidget(CardModel card, {String? label}) {
    final assetPath = 'assets/cards/${card.id}.png';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
          ],
          SizedBox(
            width: 120,
            height: 168,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to text rendering if image not found
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: card.isHeart2 ? AppTheme.accentColor : Colors.grey,
                      width: card.isHeart2 ? 3 : 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Top-left rank and suit
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.rank.displayName,
                              style: TextStyle(
                                color: card.suit.isRed ? Colors.red : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              card.suit.symbol,
                              style: TextStyle(
                                color: card.suit.isRed ? Colors.red : Colors.black,
                                fontSize: 20,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Center display
                      Center(
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use displayed trick (might be different from widget.trick during pause)
    final trickToDisplay = _displayedTrick ?? widget.trick;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use bounded constraints, default to 300x300 if unbounded
          final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0;
          final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 300.0;
          final containerSize = Size(width, height);

          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none, // Allow cards to overflow during animation
              children: trickToDisplay.cardsPlayed.asMap().entries.map((entry) {
                final index = entry.key;
                final playedCard = entry.value;
                final isAnimating = index == _animatingCardIndex;

                // Calculate positions
                final startOffset = _getStartOffset(playedCard.position, containerSize);
                final endOffset = _getCenterOffset(index, trickToDisplay.cardsPlayed.length, containerSize);

                // Determine current position based on animation state
                final Offset currentPosition;
                final Duration animDuration;

                if (isAnimating && !_animationStarted) {
                  // Card just appeared, position at start (no animation yet)
                  currentPosition = startOffset;
                  animDuration = Duration.zero;
                } else if (isAnimating && _animationStarted) {
                  // Animation in progress, move to end position
                  currentPosition = endOffset;
                  animDuration = const Duration(milliseconds: 400);
                } else {
                  // Not animating or animation complete, position at end
                  currentPosition = endOffset;
                  animDuration = Duration.zero;
                }

                return AnimatedPositioned(
                  duration: animDuration,
                  curve: Curves.easeOutCubic,
                  left: currentPosition.dx,
                  top: currentPosition.dy,
                  child: _buildCardWidget(
                    playedCard.card,
                    label: widget.game.getPlayerByPosition(playedCard.position).displayName,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
