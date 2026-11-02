import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';

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
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: PixelAssetImage(
            path: value ? RpgUiAssets.checkboxOn : RpgUiAssets.checkboxOff,
            width: RpgUiAssets.checkboxWidth,
            height: RpgUiAssets.checkboxHeight,
          ),
        ),
      ),
    );
  }
}
