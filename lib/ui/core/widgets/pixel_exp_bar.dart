import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';

class PixelExpBar extends StatelessWidget {
  const PixelExpBar({
    super.key,
    required this.current,
    required this.max,
    required this.label,
    required this.progressLabel,
  });

  final int current;
  final int max;
  final String label;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    final clampedMax = max <= 0 ? 1 : max;
    final progress = (current / clampedMax).clamp(0.0, 1.0);
    final pixel = AppTheme.pixel(fontSize: 16);

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
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(99)),
          child: SizedBox(
            height: 8,
            width: double.infinity,
            child: ColoredBox(
              color: AppColors.border,
              child: progress == 0
                  ? const SizedBox.expand()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        heightFactor: 1,
                        child: const ColoredBox(color: AppColors.accent),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
