import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';
import 'package:pixel_habit/ui/core/widgets/soft_card.dart';

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
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SoftCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PixelIcon(
                  asset: PixelIcons.scroll,
                  size: 32,
                  color: AppColors.gold,
                ),
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
    );
  }
}
