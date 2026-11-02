import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

class PixelBackdrop extends StatelessWidget {
  const PixelBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.background, child: child);
  }
}
