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
    final muted = AppColors.text.withValues(alpha: 0.45);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.textOnDark,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
          height: 64,
          backgroundColor: AppColors.textOnDark,
          surfaceTintColor: AppColors.textOnDark,
          indicatorColor: AppColors.accent.withValues(alpha: 0.16),
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
              icon: Icon(Icons.auto_awesome_outlined, color: muted),
              selectedIcon: const Icon(
                Icons.auto_awesome,
                color: AppColors.accent,
              ),
              label: l10n.tabRoutine,
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_outlined, color: muted),
              selectedIcon: const Icon(
                Icons.checklist,
                color: AppColors.accent,
              ),
              label: l10n.tabTodo,
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, color: muted),
              selectedIcon: const Icon(
                Icons.calendar_month,
                color: AppColors.accent,
              ),
              label: l10n.tabCalendar,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: muted),
              selectedIcon: const Icon(Icons.person, color: AppColors.accent),
              label: l10n.tabCharacter,
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, color: muted),
              selectedIcon: const Icon(
                Icons.grid_view,
                color: AppColors.accent,
              ),
              label: l10n.tabSummary,
            ),
          ],
        ),
      ),
    );
  }
}
