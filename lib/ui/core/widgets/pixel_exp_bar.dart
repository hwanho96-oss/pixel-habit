import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

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
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedMax = max <= 0 ? 1 : max;
    final progress = (current / clampedMax).clamp(0.0, 1.0);
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: labelStyle?.copyWith(color: AppColors.goldHighlight),
            ),
            const Spacer(),
            Text(
              progressLabel,
              style: labelStyle?.copyWith(color: AppColors.parchment),
            ),
          ],
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.night,
            border: Border.all(color: AppColors.antiqueGold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.arcane.withValues(alpha: 0.35),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.goldHighlight,
                          AppColors.gold,
                          AppColors.antiqueGold,
                        ],
                      ),
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth * progress,
                      height: height,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
