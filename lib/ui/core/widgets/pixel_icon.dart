import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';

/// 16×16 픽셀 아이콘. 흰 속은 [color], 검은 테두리는 그보다 어두운 색이다.
/// [size]는 16, 24, 32만 쓴다.
class PixelIcon extends StatelessWidget {
  const PixelIcon({
    super.key,
    required this.asset,
    required this.size,
    required this.color,
    this.outline,
  });

  final String asset;
  final double size;
  final Color color;
  final Color? outline;

  static const _sizes = <double>[16, 24, 32];

  @override
  Widget build(BuildContext context) {
    assert(_sizes.contains(size), 'PixelIcon size must be 16, 24, or 32.');
    final edge = outline ?? Color.lerp(color, AppColors.dark, 0.55)!;
    return ColorFiltered(
      colorFilter: _recolor(fill: color, edge: edge),
      child: PixelAssetImage(path: asset, width: size, height: size),
    );
  }

  static ColorFilter _recolor({required Color fill, required Color edge}) {
    return ColorFilter.matrix(<double>[
      fill.r - edge.r,
      0,
      0,
      0,
      edge.r,
      0,
      fill.g - edge.g,
      0,
      0,
      edge.g,
      0,
      0,
      fill.b - edge.b,
      0,
      edge.b,
      0,
      0,
      0,
      1,
      0,
    ]);
  }
}

abstract final class PixelIcons {
  static const home = 'assets/icons/home.png';
  static const avatar = 'assets/icons/avatar.png';
  static const records = 'assets/icons/records.png';
  static const settings = 'assets/icons/settings.png';
  static const strength = 'assets/icons/stat_strength.png';
  static const intelligence = 'assets/icons/stat_intelligence.png';
  static const wisdom = 'assets/icons/stat_wisdom.png';
  static const plus = 'assets/icons/plus.png';
  static const close = 'assets/icons/close.png';
  static const scroll = 'assets/icons/scroll.png';
  static const star = 'assets/icons/star.png';

  static const paths = <String>[
    home,
    avatar,
    records,
    settings,
    strength,
    intelligence,
    wisdom,
    plus,
    close,
    scroll,
    star,
  ];

  static String stat(HabitStat stat) {
    return switch (stat) {
      HabitStat.strength => strength,
      HabitStat.intelligence => intelligence,
      HabitStat.wisdom => wisdom,
    };
  }

  static void warmUp(BuildContext context) {
    for (final path in paths) {
      precacheImage(AssetImage(path), context);
    }
  }
}
