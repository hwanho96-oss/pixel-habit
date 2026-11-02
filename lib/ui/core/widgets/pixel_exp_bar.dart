import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_nine_slice.dart';

class PixelExpBar extends StatelessWidget {
  const PixelExpBar({
    super.key,
    required this.current,
    required this.max,
    required this.label,
    required this.progressLabel,
    this.height = 12,
  });

  final int current;
  final int max;
  final String label;
  final String progressLabel;

  /// 트랙 안쪽 홈의 높이. 프레임 스프라이트 두께는 따로 더해진다.
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedMax = max <= 0 ? 1 : max;
    final progress = (current / clampedMax).clamp(0.0, 1.0);
    final pixel = AppTheme.pixelLatin(color: AppColors.ink);
    final caps = RpgUiAssets.barTrack.capInsets;
    final trackHeight = caps.vertical + height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: pixel),
            const Spacer(),
            Text(progressLabel, style: pixel),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: trackHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const PixelNineSlice(
                slice: RpgUiAssets.barTrack,
                child: SizedBox.expand(),
              ),
              if (progress > 0)
                Padding(
                  padding: caps,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      heightFactor: 1,
                      child: const ColoredBox(color: AppColors.goldHighlight),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
