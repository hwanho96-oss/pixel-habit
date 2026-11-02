import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_nine_slice.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';

/// 팩의 normal / selected / pressed 버튼 스프라이트.
class PixelSpriteButton extends StatelessWidget {
  const PixelSpriteButton({
    super.key,
    required this.child,
    this.onPressed,
    this.selected = false,
    this.enabled = true,
    this.expandWidth = false,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool selected;
  final bool enabled;
  final bool expandWidth;
  final double? height;
  final EdgeInsets padding;
  final String? tooltip;

  bool get _canPress => enabled && onPressed != null;

  Widget _face(RpgSlice slice) {
    Widget inner = child;
    if (height != null || expandWidth) {
      inner = Center(widthFactor: expandWidth ? null : 1, child: inner);
    }
    if (padding != EdgeInsets.zero) {
      inner = Padding(padding: padding, child: inner);
    }
    return PixelNineSlice(slice: slice, child: inner);
  }

  @override
  Widget build(BuildContext context) {
    final idleSlice = selected
        ? RpgUiAssets.buttonSelected
        : RpgUiAssets.buttonNormal;

    Widget button = PixelPressable(
      enabled: _canPress,
      onTap: onPressed,
      pressedScale: 1,
      pressedChild: _face(RpgUiAssets.buttonPressed),
      child: _face(idleSlice),
    );

    if (height != null || expandWidth) {
      button = SizedBox(
        width: expandWidth ? double.infinity : null,
        height: height,
        child: button,
      );
    }

    button = Opacity(
      opacity: _canPress ? 1 : 0.45,
      child: Semantics(button: true, enabled: _canPress, child: button),
    );

    if (tooltip == null) {
      return button;
    }
    return Tooltip(message: tooltip, child: button);
  }
}
