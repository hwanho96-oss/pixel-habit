import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_sprite_button.dart';

class PixelSaveButton extends StatelessWidget {
  const PixelSaveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PixelSpriteButton(
      expandWidth: true,
      height: 52,
      enabled: enabled,
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        label,
        style: textTheme.bodyLarge?.copyWith(color: AppColors.cream, height: 1),
      ),
    );
  }
}
