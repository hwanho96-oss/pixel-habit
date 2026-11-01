import 'package:flutter/material.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PixelHabitApp extends StatefulWidget {
  const PixelHabitApp({
    super.key,
    required this.preferences,
    this.repository,
  });

  final SharedPreferences preferences;
  final RoutineRepository? repository;

  @override
  State<PixelHabitApp> createState() => _PixelHabitAppState();
}

class _PixelHabitAppState extends State<PixelHabitApp> {
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => LocalStorageService(widget.preferences),
        ),
        Provider<RoutineRepository>(
          create: (context) =>
              widget.repository ??
              LocalRoutineRepository(context.read<LocalStorageService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => RoutineViewModel(
            repository: context.read<RoutineRepository>(),
          )..load(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pixel Habit',
        theme: AppTheme.dark(),
        locale: const Locale('ko'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _router,
      ),
    );
  }
}
