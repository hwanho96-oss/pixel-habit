import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';

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
    final canPress = enabled && onPressed != null;

    return PixelPressable(
      enabled: canPress,
      onTap: onPressed,
      child: Opacity(
        opacity: canPress ? 1 : 0.45,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.gold,
            border: Border.all(
              color: AppColors.antiqueGold,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.outline.withValues(alpha: 0.45),
                offset: const Offset(3, 3),
              ),
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.28),
                blurRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Center(
              child: Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
