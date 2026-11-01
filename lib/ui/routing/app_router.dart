import 'package:flutter/material.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_habit/ui/core/widgets/placeholder_tab.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/routine/views/routine_view.dart';
import 'package:pixel_habit/ui/routing/app_shell.dart';
import 'package:provider/provider.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/routine',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/routine',
                builder: (context, state) {
                  return RoutineView(viewModel: context.read<RoutineViewModel>());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/todo',
                builder: (context, state) {
                  return PlaceholderTab(
                    title: 'To do',
                    message: _sealed(context),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) {
                  return PlaceholderTab(
                    title: '캘린더',
                    message: _sealed(context),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/character',
                builder: (context, state) {
                  return PlaceholderTab(
                    title: '캐릭터',
                    message: _sealed(context),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/summary',
                builder: (context, state) {
                  return PlaceholderTab(
                    title: '종합',
                    message: _sealed(context),
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

String _sealed(BuildContext context) {
  return AppLocalizations.of(context)!.comingSoon;
}
