import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 72});

  static const assetPath = 'assets/images/profile_wizard.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Semantics(
            label: 'profile wizard',
            child: const PixelAssetImage(path: assetPath),
          ),
        ),
      ),
    );
  }
}
