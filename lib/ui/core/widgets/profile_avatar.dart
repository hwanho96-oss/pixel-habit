import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 56});

  static const assetPath = 'assets/images/profile_wizard.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.night,
          border: Border.all(color: AppColors.antiqueGold, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.arcane.withValues(alpha: 0.4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          isAntiAlias: false,
          semanticLabel: 'profile wizard',
        ),
      ),
    );
  }
}
