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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          transform: _isHovering && widget.isEnabled
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isEnabled
                ? (_isHovering ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.surfaceColor)
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovering && widget.isEnabled
                  ? AppTheme.accentColor
                  : AppTheme.textSecondaryColor,
              width: _isHovering && widget.isEnabled ? 2 : 1,
            ),
            boxShadow: [
              if (_isHovering && widget.isEnabled)
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Stack(
            children: [
              // Card back pattern
              Center(
                child: Icon(
                  Icons.question_mark,
                  size: widget.width * 0.4,
                  color: widget.isEnabled
                      ? AppTheme.textSecondaryColor
                      : Colors.grey.shade600,
                ),
              ),
              // Optional: Add a pattern/texture
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardBackPatternPainter(
                    color: widget.isEnabled
                        ? AppTheme.textSecondaryColor.withOpacity(0.1)
                        : Colors.grey.shade600.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for card back pattern
class _CardBackPatternPainter extends CustomPainter {
  final Color color;

  _CardBackPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw a simple diamond pattern
    const spacing = 15.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final path = Path()
          ..moveTo(x + spacing / 2, y)
          ..lineTo(x + spacing, y + spacing / 2)
          ..lineTo(x + spacing / 2, y + spacing)
          ..lineTo(x, y + spacing / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CardBackPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
