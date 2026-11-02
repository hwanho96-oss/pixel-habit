import 'package:flutter/material.dart';

/// 홈 장면에 쓰는 그림. 픽셀은 [FilterQuality.none]으로 그린다.
abstract final class HomeAssets {
  static const background = 'assets/images/home_background.png';
  static const avatar = 'assets/images/avatar_wizard.png';
  static const coin = 'assets/images/coin.png';

  static void warmUp(BuildContext context) {
    for (final path in const [background, avatar, coin]) {
      precacheImage(AssetImage(path), context);
    }
  }
}
