import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Widget to display a face-down card for the card draw phase
class CardBackWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final double width;
  final double height;

  const CardBackWidget({
    super.key,
    this.onTap,
    this.isEnabled = true,
    this.width = 60,
    this.height = 84,
  });

  @override
  State<CardBackWidget> createState() => _CardBackWidgetState();
}

class _CardBackWidgetState extends State<CardBackWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.isEnabled ? (_) => setState(() => _isHovering = true) : null,
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _isHovering && widget.isEnabled ? 1.05 : 1.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? (_isHovering ? AppTheme.accentColor.withValues(alpha: 0.2) : AppTheme.surfaceColor)
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
          ),
        ),
      ),
    );
  }
}
