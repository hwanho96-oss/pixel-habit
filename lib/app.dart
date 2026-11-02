import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/web_phone_frame.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PixelHabitApp extends StatefulWidget {
  const PixelHabitApp({
    super.key,
    required this.preferences,
    this.repository,
    this.showDebugBanner = true,
  });

  final SharedPreferences preferences;
  final RoutineRepository? repository;
  final bool showDebugBanner;

  @override
  State<PixelHabitApp> createState() => _PixelHabitAppState();
}

class _PixelHabitAppState extends State<PixelHabitApp> {
  late final GoRouter _router = createRouter();
  var _spritesWarmed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_spritesWarmed) {
      return;
    }
    _spritesWarmed = true;
    RpgUiAssets.warmUp(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LocalStorageService(widget.preferences)),
        Provider<RoutineRepository>(
          create: (context) =>
              widget.repository ??
              LocalRoutineRepository(context.read<LocalStorageService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RoutineViewModel(repository: context.read<RoutineRepository>())
                ..load(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pixel Habit',
        theme: AppTheme.light(),
        locale: const Locale('ko'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: widget.showDebugBanner,
        routerConfig: _router,
        builder: kIsWeb
            ? (context, child) =>
                  WebPhoneFrame(child: child ?? const SizedBox.shrink())
            : null,
      ),
    );
  }
}
