import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelCoin extends StatelessWidget {
  const PixelCoin({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _PixelCoinPainter(),
    );
  }
}

class _PixelCoinPainter extends CustomPainter {
  const _PixelCoinPainter();

  static const _rows = <String>[
    '..####..',
    '.##ss##.',
    '#ssooo##',
    '#sooooo#',
    '#oooooo#',
    '#oooaa##',
    '.##aa##.',
    '..####..',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.shortestSide / _rows.length;
    for (var y = 0; y < _rows.length; y++) {
      final row = _rows[y];
      for (var x = 0; x < row.length; x++) {
        final color = _colorFor(row[x]);
        if (color == null) {
          continue;
        }
        canvas.drawRect(
          Rect.fromLTWH(x * unit, y * unit, unit, unit),
          Paint()..color = color,
        );
      }
    }
  }

  Color? _colorFor(String pixel) {
    return switch (pixel) {
      '#' => AppColors.outline,
      'o' => AppColors.gold,
      's' => AppColors.goldHighlight,
      'a' => AppColors.antiqueGold,
      _ => null,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
