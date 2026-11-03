import 'package:go_router/go_router.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/widgets/placeholder_tab.dart';
import 'package:pixel_habit/ui/core/widgets/rpg_asset_credit.dart';
import 'package:pixel_habit/ui/features/avatar/views/avatar_screen.dart';
import 'package:pixel_habit/ui/features/home/views/home_view.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';
import 'package:pixel_habit/ui/routing/app_shell.dart';
import 'package:provider/provider.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) {
                  return HomeView(
                    routines: context.read<RoutineViewModel>(),
                    todos: context.read<TodoViewModel>(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/avatar',
                builder: (context, state) => const AvatarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/records',
                builder: (context, state) {
                  final l10n = AppLocalizations.of(context)!;
                  return PlaceholderTab(
                    title: l10n.tabRecords,
                    message: l10n.recordsPlaceholder,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) {
                  final l10n = AppLocalizations.of(context)!;
                  return PlaceholderTab(
                    title: l10n.tabSettings,
                    message: l10n.comingSoon,
                    footer: const RpgAssetCredit(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
