import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelCheckbox extends StatelessWidget {
  const PixelCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      button: true,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: value ? AppColors.gold : AppColors.parchment,
            border: Border.all(
              color: value ? AppColors.antiqueGold : AppColors.outline,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: (value ? AppColors.gold : AppColors.outline)
                    .withValues(alpha: 0.35),
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: value
              ? const Icon(Icons.check, size: 18, color: AppColors.ink)
              : null,
        ),
      ),
    );
  }
}
