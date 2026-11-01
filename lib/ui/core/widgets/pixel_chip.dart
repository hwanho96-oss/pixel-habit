import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';

class PixelChip extends StatelessWidget {
  const PixelChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PixelPressable(
      onTap: () => onSelected(!selected),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.parchmentDark,
          border: Border.all(
            color: selected ? AppColors.antiqueGold : AppColors.outline,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (selected ? AppColors.gold : AppColors.outline)
                  .withValues(alpha: 0.35),
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.ink,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
