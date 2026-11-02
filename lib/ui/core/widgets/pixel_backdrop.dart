import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelBackdrop extends StatelessWidget {
  const PixelBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.night, AppColors.dungeon, AppColors.night],
        ),
      ),
      child: child,
    );
  }
}
