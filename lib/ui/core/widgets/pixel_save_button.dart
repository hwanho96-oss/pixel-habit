import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_sprite_button.dart';

/// 화면에서 하나뿐인 강조 버튼. 픽셀 버튼 스프라이트는 여기에만 쓴다.
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
    return PixelSpriteButton(
      expandWidth: true,
      height: 56,
      enabled: enabled,
      selected: true,
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        label,
        style: AppTheme.pixel(fontSize: 16, color: AppColors.text),
      ),
    );
  }
}
