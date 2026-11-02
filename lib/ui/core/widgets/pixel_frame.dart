import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_nine_slice.dart';

enum PixelPanelStyle { parchment, warm, ornate }

/// 배경 박스 스프라이트를 9-slice로 깐 패널.
class PixelFrame extends StatelessWidget {
  const PixelFrame({
    super.key,
    required this.child,
    this.style = PixelPanelStyle.parchment,
    this.padding = const EdgeInsets.all(6),
  });

  final Widget child;
  final PixelPanelStyle style;

  /// 프레임 안쪽 여백. 스프라이트 테두리 두께에 더해진다.
  final EdgeInsets padding;

  RpgSlice get _slice => switch (style) {
    PixelPanelStyle.parchment => RpgUiAssets.panelParchment,
    PixelPanelStyle.warm => RpgUiAssets.panelWarm,
    PixelPanelStyle.ornate => RpgUiAssets.panelOrnate,
  };

  @override
  Widget build(BuildContext context) {
    final slice = _slice;
    return PixelNineSlice(
      slice: slice,
      child: Padding(padding: slice.capInsets + padding, child: child),
    );
  }
}
