import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelAvatar extends StatelessWidget {
  const PixelAvatar({
    super.key,
    required this.seed,
    this.size = 44,
  });

  final int seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dungeon,
          border: Border.all(color: AppColors.outline, width: 3),
        ),
        child: CustomPaint(
          painter: _PixelHeroPainter(seed: seed),
        ),
      ),
    );
  }
}

class _PixelHeroPainter extends CustomPainter {
  _PixelHeroPainter({required this.seed});

  final int seed;

  static const _palettes = [
    [AppColors.sky, AppColors.gold, AppColors.moss],
    [AppColors.ruby, AppColors.parchment, AppColors.gold],
    [AppColors.moss, AppColors.sky, AppColors.parchment],
    [AppColors.gold, AppColors.ruby, AppColors.sky],
    [AppColors.parchmentDark, AppColors.moss, AppColors.ruby],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final palette = _palettes[seed.abs() % _palettes.length];
    final cell = size.width / 8;
    final paint = Paint()..style = PaintingStyle.fill;

    void pixel(int x, int y, Color color) {
      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * cell, y * cell, cell, cell),
        paint,
      );
    }

    // Helmet
    for (var x = 2; x <= 5; x++) {
      pixel(x, 1, palette[0]);
    }
    pixel(2, 2, palette[0]);
    pixel(5, 2, palette[0]);
    // Face
    pixel(3, 2, palette[1]);
    pixel(4, 2, palette[1]);
    pixel(3, 3, palette[1]);
    pixel(4, 3, palette[1]);
    pixel(2, 3, palette[0]);
    pixel(5, 3, palette[0]);
    // Eyes
    pixel(3, 2, AppColors.ink);
    pixel(4, 2, AppColors.ink);
    // Body
    for (var x = 2; x <= 5; x++) {
      pixel(x, 4, palette[2]);
      pixel(x, 5, palette[2]);
    }
    pixel(1, 4, palette[0]);
    pixel(6, 4, palette[0]);
    pixel(3, 6, palette[0]);
    pixel(4, 6, palette[0]);
  }

  @override
  bool shouldRepaint(covariant _PixelHeroPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
