import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_sprite_button.dart';

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

    return PixelSpriteButton(
      selected: selected,
      onPressed: () => onSelected(!selected),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        label,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.cream,
          fontSize: 14,
          height: 1,
        ),
      ),
    );
  }
}
