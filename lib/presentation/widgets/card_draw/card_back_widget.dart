import 'dart:math' show pi;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Widget to display a face-down card for the card draw phase
class CardBackWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final double width;
  final double height;
  final bool shouldFlip;
  final dynamic card;

  const CardBackWidget({
    super.key,
    this.onTap,
    this.isEnabled = true,
    this.width = 60,
    this.height = 84,
    this.shouldFlip = false,
    this.card,
  });

  @override
  State<CardBackWidget> createState() => _CardBackWidgetState();
}

class _CardBackWidgetState extends State<CardBackWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CardBackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldFlip && !oldWidget.shouldFlip) {
      _flipController.forward();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.isEnabled && !widget.shouldFlip
          ? (_) => setState(() => _isHovering = true)
          : null,
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.isEnabled && !widget.shouldFlip
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.isEnabled && !widget.shouldFlip ? widget.onTap : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _isHovering && widget.isEnabled && !widget.shouldFlip ? 1.05 : 1.0,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value;
              final isFront = angle < pi / 2;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: isFront ? _buildCardBack() : _buildCardFront(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? (_isHovering
                ? AppTheme.accentColor.withValues(alpha: 0.2)
                : AppTheme.surfaceColor)
            : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isHovering && widget.isEnabled
              ? AppTheme.accentColor
              : AppTheme.textSecondaryColor,
          width: _isHovering && widget.isEnabled ? 2 : 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.style,
          size: widget.width * 0.4,
          color: widget.isEnabled
              ? AppTheme.textSecondaryColor
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    if (widget.card == null) {
      return _buildCardBack();
    }

    final card = widget.card;
    final assetPath = 'assets/cards/${card.id}.png';

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.accentColor,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.rank.displayName,
                      style: TextStyle(
                        color: card.suit.isRed ? Colors.red : Colors.black,
                        fontSize: widget.width * 0.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      card.suit.symbol,
                      style: TextStyle(
                        color: card.suit.isRed ? Colors.red : Colors.black,
                        fontSize: widget.width * 0.35,
                      ),
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
