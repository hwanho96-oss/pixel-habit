import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/item.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/equipment_provider.dart';
import 'package:provider/provider.dart';

/// 배경, 맨몸, 하의, 상의, 무기, 펫을 한 겹으로 쌓는다.
/// 픽셀은 [PixelAssetImage]가 [FilterQuality.none]으로 키운다.
class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    this.characterSize = 160,
    this.showBackground = true,
    this.characterAlignment = Alignment.center,
  });

  final double characterSize;
  final bool showBackground;
  final Alignment characterAlignment;

  @override
  Widget build(BuildContext context) {
    final equipment = context.watch<EquipmentProvider>();
    final character = _AvatarLayers(
      size: characterSize,
      bottom: equipment.layerAsset(ItemCategory.bottom),
      top: equipment.layerAsset(ItemCategory.top),
      weapon: equipment.layerAsset(ItemCategory.weapon),
      pet: equipment.layerAsset(ItemCategory.pet),
    );
    if (!showBackground) {
      return character;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        PixelAssetImage(path: equipment.backgroundAsset, fit: BoxFit.cover),
        Align(alignment: characterAlignment, child: character),
      ],
    );
  }
}

class _AvatarLayers extends StatelessWidget {
  const _AvatarLayers({
    required this.size,
    required this.bottom,
    required this.top,
    required this.weapon,
    required this.pet,
  });

  final double size;
  final String? bottom;
  final String? top;
  final String? weapon;
  final String? pet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const PixelAssetImage(path: EquipmentProvider.baseAsset),
          if (bottom != null) PixelAssetImage(path: bottom!),
          if (top != null) PixelAssetImage(path: top!),
          if (weapon != null) PixelAssetImage(path: weapon!),
          if (pet != null)
            Align(
              alignment: Alignment.bottomRight,
              // shortcut: 펫 원본은 16px가 아니다. 몸통 격자에 맞출 스프라이트가 생기면 같은 칸에 올린다.
              child: PixelAssetImage(
                path: pet!,
                width: size * 0.45,
                height: size * 0.45,
              ),
            ),
        ],
      ),
    );
  }
}
