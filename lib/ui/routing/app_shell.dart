import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

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
          color: AppColors.dungeon,
          border: Border(
            top: BorderSide(color: AppColors.gold, width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.outline,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: AppColors.dungeon,
          surfaceTintColor: AppColors.dungeon,
          indicatorColor: AppColors.arcane.withValues(alpha: 0.35),
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
              icon: const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.parchmentDark,
              ),
              selectedIcon: const Icon(
                Icons.auto_awesome,
                color: AppColors.gold,
              ),
              label: l10n.tabRoutine,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.checklist_outlined,
                color: AppColors.parchmentDark,
              ),
              selectedIcon: const Icon(
                Icons.checklist,
                color: AppColors.gold,
              ),
              label: l10n.tabTodo,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.parchmentDark,
              ),
              selectedIcon: const Icon(
                Icons.calendar_month,
                color: AppColors.gold,
              ),
              label: l10n.tabCalendar,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.person_outline,
                color: AppColors.parchmentDark,
              ),
              selectedIcon: const Icon(
                Icons.person,
                color: AppColors.gold,
              ),
              label: l10n.tabCharacter,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu, color: AppColors.parchmentDark),
              selectedIcon: const Icon(
                Icons.grid_view,
                color: AppColors.gold,
              ),
              label: l10n.tabSummary,
            ),
          ],
        ),
      ),
    );
  }
}
