import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    final latinTitle = GoogleFonts.cinzel(
      color: AppColors.gold,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.4,
      height: 1.4,
    );
    final koreanTitle = GoogleFonts.jua(
      color: AppColors.gold,
      fontSize: 22,
      height: 1.3,
    );
    final body = GoogleFonts.jua(
      color: AppColors.ink,
      fontSize: 18,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.night,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.arcane,
        surface: AppColors.dungeon,
        onPrimary: AppColors.ink,
        onSurface: AppColors.parchment,
        error: AppColors.ruby,
      ),
      textTheme: TextTheme(
        titleLarge: koreanTitle,
        titleMedium: latinTitle,
        bodyLarge: body,
        bodyMedium: body.copyWith(fontSize: 16),
        labelSmall: latinTitle.copyWith(
          fontSize: 10,
          color: AppColors.antiqueGold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dungeon,
        foregroundColor: AppColors.gold,
        elevation: 0,
        titleTextStyle: koreanTitle,
        shape: const Border(
          bottom: BorderSide(color: AppColors.gold, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.parchment,
        titleTextStyle: koreanTitle.copyWith(color: AppColors.ink),
        contentTextStyle: body,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.dungeon,
        indicatorColor: AppColors.arcane.withValues(alpha: 0.35),
        surfaceTintColor: AppColors.dungeon,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gold : AppColors.parchmentDark,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return koreanTitle.copyWith(
            fontSize: 12,
            color: selected ? AppColors.gold : AppColors.parchmentDark,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.arcane,
        contentTextStyle: body.copyWith(color: AppColors.parchment),
      ),
    );
  }
}
