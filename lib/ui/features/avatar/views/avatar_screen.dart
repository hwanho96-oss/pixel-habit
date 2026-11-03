import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/item.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/sound/coin_sound.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/avatar_view.dart';
import 'package:pixel_habit/ui/core/widgets/gold_badge.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_coin.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/equipment_provider.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:provider/provider.dart';

/// 아바타 탭. 위는 상점과 성격, 상점은 미리보기와 칸 목록이다.
class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  var _shop = true;
  var _category = ItemCategory.top;
  var _busy = false;

  Future<void> _onItem(Item item) async {
    if (_busy) {
      return;
    }
    _busy = true;
    try {
      final equipment = context.read<EquipmentProvider>();
      if (equipment.ownedIds.contains(item.id)) {
        if (equipment.equippedId(item.category) == item.id) {
          await equipment.unequip(item.category);
        } else {
          await equipment.equip(item.id);
        }
        return;
      }
      final spent = await context.read<RoutineViewModel>().spendGold(
        item.price,
      );
      if (!spent) {
        if (mounted) {
          _sayNeedGold();
        }
        return;
      }
      await equipment.ownAndEquip(item.id);
      if (mounted) {
        await context.read<CoinSound>().play(asset: CoinSound.purchaseAsset);
      }
    } finally {
      _busy = false;
    }
  }

  void _sayNeedGold() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.shopNeedGold,
          style: const TextStyle(color: AppColors.textOnDark),
        ),
        backgroundColor: AppColors.panelRaised,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.watch<RoutineViewModel>().progress.gold;
    final equipment = context.watch<EquipmentProvider>();

    return Scaffold(
      backgroundColor: AppColors.panel,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = constraints.maxHeight * 0.4;
          return Stack(
            children: [
              if (_shop)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: previewHeight,
                  child: const AvatarView(
                    characterSize: 256,
                    characterAlignment: Alignment(0, 0.35),
                  ),
                ),
              if (_shop)
                Positioned(
                  top: previewHeight - 20,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ShopPanel(
                    l10n: l10n,
                    equipment: equipment,
                    category: _category,
                    onCategory: (category) =>
                        setState(() => _category = category),
                    onItem: _onItem,
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
                    child: Text(
                      l10n.personalityPlaceholder,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: AppColors.textOnDark),
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            label: l10n.shopTab,
                            selected: _shop,
                            onTap: () => setState(() => _shop = true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TabButton(
                            label: l10n.personalityTab,
                            selected: !_shop,
                            onTap: () => setState(() => _shop = false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GoldBadge(amount: gold),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShopPanel extends StatelessWidget {
  const _ShopPanel({
    required this.l10n,
    required this.equipment,
    required this.category,
    required this.onCategory,
    required this.onItem,
  });

  final AppLocalizations l10n;
  final EquipmentProvider equipment;
  final ItemCategory category;
  final ValueChanged<ItemCategory> onCategory;
  final Future<void> Function(Item item) onItem;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final item in equipment.items)
        if (item.category == category) item,
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: ColoredBox(
        color: AppColors.panel,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
              child: Row(
                children: [
                  for (final entry in ItemCategory.values) ...[
                    if (entry != ItemCategory.top) const SizedBox(width: 4),
                    Expanded(
                      child: _TabButton(
                        label: _categoryLabel(l10n, entry),
                        selected: entry == category,
                        onTap: () => onCategory(entry),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 118,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _ShopTile(
                    item: item,
                    owned: equipment.ownedIds.contains(item.id),
                    equipped: equipment.equippedId(item.category) == item.id,
                    ownedLabel: l10n.shopOwned,
                    equippedLabel: l10n.shopEquipped,
                    onTap: () => onItem(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryLabel(AppLocalizations l10n, ItemCategory category) {
  return switch (category) {
    ItemCategory.top => l10n.shopCategoryTop,
    ItemCategory.bottom => l10n.shopCategoryBottom,
    ItemCategory.weapon => l10n.shopCategoryWeapon,
    ItemCategory.pet => l10n.shopCategoryPet,
    ItemCategory.background => l10n.shopCategoryBackground,
  };
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.gold : AppColors.panelRaised,
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? AppColors.text : AppColors.panelMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  const _ShopTile({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.ownedLabel,
    required this.equippedLabel,
    required this.onTap,
  });

  final Item item;
  final bool owned;
  final bool equipped;
  final String ownedLabel;
  final String equippedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nameStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: AppColors.textOnDark,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
    final priceStyle = nameStyle?.copyWith(color: AppColors.gold);

    return PixelPressable(
      onTap: onTap,
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.panelRaised,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: equipped ? AppColors.gold : AppColors.panelBorder,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: PixelAssetImage(
                    path: item.asset,
                    fit: item.category == ItemCategory.background
                        ? BoxFit.cover
                        : BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: nameStyle,
                ),
                const Spacer(),
                if (equipped)
                  Text(equippedLabel, style: priceStyle)
                else if (owned)
                  Text(ownedLabel, style: priceStyle)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PixelCoin(size: 14),
                      const SizedBox(width: 2),
                      Text('${item.price}', style: priceStyle),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
