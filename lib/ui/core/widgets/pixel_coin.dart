import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/home_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';

class PixelCoin extends StatelessWidget {
  const PixelCoin({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    return PixelAssetImage(path: HomeAssets.coin, width: size, height: size);
  }
}
