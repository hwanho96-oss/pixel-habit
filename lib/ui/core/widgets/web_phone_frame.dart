import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

/// Centers the phone UI when the browser window is wider than a phone.
///
/// A phone-width viewport is left untouched so a mobile browser still fills
/// the screen. Android never mounts this widget.
class WebPhoneFrame extends StatelessWidget {
  const WebPhoneFrame({super.key, required this.child});

  final Widget child;

  /// Logical width close to a typical phone.
  static const double phoneWidth = 400;

  static const Color backdrop = AppColors.dark;

  static bool shouldConstrain({
    required bool isWeb,
    required double viewportWidth,
  }) {
    return isWeb && viewportWidth.isFinite && viewportWidth > phoneWidth;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backdrop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportWidth = constraints.maxWidth;
          if (!shouldConstrain(isWeb: true, viewportWidth: viewportWidth)) {
            return child;
          }

          final media = MediaQuery.of(context);
          final framedHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : media.size.height;

          return Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: AppColors.gold.withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark.withValues(alpha: 0.35),
                    blurRadius: 36,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SizedBox(
                width: phoneWidth,
                height: framedHeight,
                child: MediaQuery(
                  data: media.copyWith(size: Size(phoneWidth, framedHeight)),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
