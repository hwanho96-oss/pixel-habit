import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_backdrop.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_frame.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_title_banner.dart';

class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({
    super.key,
    required this.title,
    required this.message,
    this.footer,
  });

  final String title;
  final String message;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: PixelTitleBanner(
          title: title,
          slice: RpgUiAssets.bannerLight,
          height: 40,
          textStyle: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontSize: 16, height: 1, color: AppColors.ink),
        ),
      ),
      body: PixelBackdrop(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: PixelFrame(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, color: AppColors.ink, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (footer != null) ...[const SizedBox(height: 16), footer!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
