import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelFrame extends StatelessWidget {
  const PixelFrame({
    super.key,
    required this.child,
    this.color = AppColors.parchment,
    this.borderColor = AppColors.gold,
    this.padding = const EdgeInsets.all(12),
    this.borderWidth = 3,
    this.showOrnaments = true,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final EdgeInsets padding;
  final double borderWidth;
  final bool showOrnaments;

  @override
  Widget build(BuildContext context) {
    final isDark = color.computeLuminance() < 0.3;
    final blend = isDark ? AppColors.night : AppColors.ink;
    final gradientEnd = Color.lerp(color, blend, 0.14)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: borderColor,
        boxShadow: [
          const BoxShadow(
            color: AppColors.outline,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.28),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outline, width: 2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, gradientEnd],
            ),
          ),
          child: Stack(
            children: [
              Padding(padding: padding, child: child),
              if (showOrnaments)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _CornerOrnamentPainter()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerOrnamentPainter extends CustomPainter {
  const _CornerOrnamentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.antiqueGold
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final fill = Paint()
      ..color = AppColors.goldHighlight
      ..style = PaintingStyle.fill;

    const inset = 5.0;
    const arm = 11.0;

    void corner(Offset origin, double dx, double dy) {
      final path = Path()
        ..moveTo(origin.dx, origin.dy + dy * arm)
        ..lineTo(origin.dx, origin.dy)
        ..lineTo(origin.dx + dx * arm, origin.dy);
      canvas.drawPath(path, stroke);
      canvas.drawRect(
        Rect.fromCenter(center: origin, width: 3.2, height: 3.2),
        fill,
      );
    }

    corner(const Offset(inset, inset), 1, 1);
    corner(Offset(size.width - inset, inset), -1, 1);
    corner(Offset(inset, size.height - inset), 1, -1);
    corner(Offset(size.width - inset, size.height - inset), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
