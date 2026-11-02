import 'package:flutter/material.dart';

/// Franuka, "RPG UI pack (demo)".
/// https://franuka.itch.io/rpg-ui-pack-demo
///
/// 1x 시트를 편집해 자른 뒤 최근접 이웃으로 2배 확대한 스프라이트다.
/// 상업적 사용과 편집은 가능하지만, 팩 원본을 그대로 재배포하면 안 된다.
/// 라이선스 원문: assets/rpg_ui/LICENSE.txt
@immutable
class RpgSlice {
  const RpgSlice({
    required this.path,
    required this.centerSlice,
    required this.width,
    required this.height,
  });

  final String path;

  /// 늘어나는 중앙 영역. 이미지 픽셀 좌표이며 가장자리는 고정된다.
  final Rect centerSlice;
  final double width;
  final double height;

  EdgeInsets get capInsets => EdgeInsets.fromLTRB(
    centerSlice.left,
    centerSlice.top,
    width - centerSlice.right,
    height - centerSlice.bottom,
  );
}

abstract final class RpgUiAssets {
  static const _ui = 'assets/rpg_ui/ui';

  static const panelParchment = RpgSlice(
    path: '$_ui/panel_parchment.png',
    centerSlice: Rect.fromLTRB(20, 20, 52, 52),
    width: 72,
    height: 72,
  );

  static const panelWarm = RpgSlice(
    path: '$_ui/panel_warm.png',
    centerSlice: Rect.fromLTRB(14, 20, 58, 56),
    width: 72,
    height: 72,
  );

  static const panelOrnate = RpgSlice(
    path: '$_ui/panel_ornate.png',
    centerSlice: Rect.fromLTRB(22, 22, 62, 60),
    width: 84,
    height: 84,
  );

  static const bannerDark = RpgSlice(
    path: '$_ui/banner_dark.png',
    centerSlice: Rect.fromLTRB(18, 8, 78, 18),
    width: 96,
    height: 26,
  );

  static const bannerRibbon = RpgSlice(
    path: '$_ui/banner_ribbon.png',
    centerSlice: Rect.fromLTRB(24, 8, 64, 20),
    width: 88,
    height: 28,
  );

  static const bannerLight = RpgSlice(
    path: '$_ui/banner_light.png',
    centerSlice: Rect.fromLTRB(10, 10, 82, 16),
    width: 92,
    height: 26,
  );

  static const buttonNormal = RpgSlice(
    path: '$_ui/button_normal.png',
    centerSlice: Rect.fromLTRB(8, 10, 84, 18),
    width: 92,
    height: 30,
  );

  static const buttonSelected = RpgSlice(
    path: '$_ui/button_selected.png',
    centerSlice: Rect.fromLTRB(10, 12, 86, 20),
    width: 96,
    height: 32,
  );

  static const buttonPressed = RpgSlice(
    path: '$_ui/button_pressed.png',
    centerSlice: Rect.fromLTRB(8, 12, 84, 20),
    width: 92,
    height: 30,
  );

  static const barTrack = RpgSlice(
    path: '$_ui/bar_track.png',
    centerSlice: Rect.fromLTRB(8, 8, 88, 12),
    width: 96,
    height: 22,
  );

  static const checkboxOff = '$_ui/checkbox_off.png';
  static const checkboxOn = '$_ui/checkbox_on.png';
  static const checkboxWidth = 20.0;
  static const checkboxHeight = 22.0;

  static const slices = <RpgSlice>[
    panelParchment,
    panelWarm,
    panelOrnate,
    bannerDark,
    bannerRibbon,
    bannerLight,
    buttonNormal,
    buttonSelected,
    buttonPressed,
    barTrack,
  ];

  static void warmUp(BuildContext context) {
    for (final slice in slices) {
      precacheImage(AssetImage(slice.path), context);
    }
    precacheImage(const AssetImage(checkboxOff), context);
    precacheImage(const AssetImage(checkboxOn), context);
  }
}
