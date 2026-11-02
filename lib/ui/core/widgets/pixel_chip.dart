import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

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
    final foreground = selected ? AppColors.textOnDark : AppColors.text;

    return Material(
      color: selected ? AppColors.accent : AppColors.textOnDark,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => onSelected(!selected),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
