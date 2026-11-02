import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.panel,
          border: Border(top: BorderSide(color: AppColors.panelBorder)),
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: AppColors.panel,
          surfaceTintColor: AppColors.panel,
          shadowColor: AppColors.panel,
          indicatorColor: AppColors.gold.withValues(alpha: 0.18),
          selectedIndex: navigationShell.currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: const PixelIcon(
                asset: PixelIcons.home,
                size: 32,
                color: AppColors.panelMuted,
              ),
              selectedIcon: const PixelIcon(
                asset: PixelIcons.home,
                size: 32,
                color: AppColors.gold,
              ),
              label: l10n.tabHome,
            ),
            NavigationDestination(
              icon: const PixelIcon(
                asset: PixelIcons.avatar,
                size: 32,
                color: AppColors.panelMuted,
              ),
              selectedIcon: const PixelIcon(
                asset: PixelIcons.avatar,
                size: 32,
                color: AppColors.gold,
              ),
              label: l10n.tabAvatar,
            ),
            NavigationDestination(
              icon: const PixelIcon(
                asset: PixelIcons.records,
                size: 32,
                color: AppColors.panelMuted,
              ),
              selectedIcon: const PixelIcon(
                asset: PixelIcons.records,
                size: 32,
                color: AppColors.gold,
              ),
              label: l10n.tabRecords,
            ),
            NavigationDestination(
              icon: const PixelIcon(
                asset: PixelIcons.settings,
                size: 32,
                color: AppColors.panelMuted,
              ),
              selectedIcon: const PixelIcon(
                asset: PixelIcons.settings,
                size: 32,
                color: AppColors.gold,
              ),
              label: l10n.tabSettings,
            ),
          ],
        ),
      ),
    );
  }
}
