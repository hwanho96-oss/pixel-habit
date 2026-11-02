import 'package:flutter/material.dart';

/// Scale-down press feedback matching routine cards.
class PixelPressable extends StatefulWidget {
  const PixelPressable({
    super.key,
    required this.child,
    this.pressedChild,
    this.onTap,
    this.enabled = true,
    this.pressedScale = 0.95,
  });

  final Widget child;
  final Widget? pressedChild;
  final VoidCallback? onTap;
  final bool enabled;
  final double pressedScale;

  @override
  State<PixelPressable> createState() => _PixelPressableState();
}

class _PixelPressableState extends State<PixelPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final canTap = widget.enabled && widget.onTap != null;
    final showPressed = _pressed && canTap && widget.pressedChild != null;
    final scaleDown = _pressed && canTap && widget.pressedChild == null;

    return AnimatedScale(
      scale: scaleDown ? widget.pressedScale : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: canTap ? (_) => _setPressed(true) : null,
        onTapUp: canTap ? (_) => _setPressed(false) : null,
        onTapCancel: canTap ? () => _setPressed(false) : null,
        onTap: canTap ? widget.onTap : null,
        child: showPressed ? widget.pressedChild! : widget.child,
      ),
    );
  }
}
