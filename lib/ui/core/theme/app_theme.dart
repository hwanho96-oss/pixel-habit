import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const pixelFontFamily = 'FantasyRPG';

  /// 숫자와 영문 전용. 글자 크기는 8의 배수로 둔다.
  static TextStyle pixelLatin({
    double fontSize = 16,
    Color color = AppColors.ink,
  }) {
    return TextStyle(
      fontFamily: pixelFontFamily,
      fontSize: fontSize,
      height: 1,
      color: color,
    );
  }

  static ThemeData dark() {
    final koreanTitle = GoogleFonts.jua(
      color: AppColors.gold,
      fontSize: 22,
      height: 1.3,
    );
    final body = GoogleFonts.jua(color: AppColors.ink, fontSize: 18);
    final pixel = pixelLatin();

    const squareBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: AppColors.outline, width: 2),
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
        titleMedium: pixel.copyWith(color: AppColors.gold),
        bodyLarge: body,
        bodyMedium: body.copyWith(fontSize: 16),
        labelSmall: body.copyWith(fontSize: 12, height: 1.2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dungeon,
        foregroundColor: AppColors.gold,
        elevation: 0,
        titleTextStyle: koreanTitle,
        shape: const Border(
          bottom: BorderSide(color: AppColors.antiqueGold, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.parchment,
        titleTextStyle: koreanTitle.copyWith(color: AppColors.ink),
        contentTextStyle: body,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.parchmentDark,
        hintStyle: body.copyWith(
          color: AppColors.ink.withValues(alpha: 0.45),
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: squareBorder,
        enabledBorder: squareBorder,
        focusedBorder: squareBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.antiqueGold, width: 3),
        ),
        errorBorder: squareBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.ruby, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.parchmentDark,
        selectedColor: AppColors.gold,
        disabledColor: AppColors.parchmentFaded,
        labelStyle: body.copyWith(fontSize: 14),
        secondaryLabelStyle: body.copyWith(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.outline, width: 2),
        ),
        side: const BorderSide(color: AppColors.outline, width: 2),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.parchment,
        headerBackgroundColor: AppColors.dungeon,
        headerForegroundColor: AppColors.gold,
        weekdayStyle: body.copyWith(fontSize: 14, color: AppColors.ink),
        dayStyle: pixel,
        yearStyle: pixel,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.ink.withValues(alpha: 0.35);
          }
          return AppColors.ink;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.gold;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: const WidgetStatePropertyAll(
          AppColors.antiqueGold,
        ),
        todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        todayBorder: const BorderSide(color: AppColors.antiqueGold, width: 2),
        yearForegroundColor: const WidgetStatePropertyAll(AppColors.ink),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.gold;
          }
          return Colors.transparent;
        }),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        dividerColor: AppColors.antiqueGold,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.parchment,
        hourMinuteColor: AppColors.parchmentDark,
        hourMinuteTextColor: AppColors.ink,
        dialHandColor: AppColors.gold,
        dialBackgroundColor: AppColors.parchmentDark,
        dialTextColor: AppColors.ink,
        entryModeIconColor: AppColors.antiqueGold,
        dayPeriodColor: AppColors.gold,
        dayPeriodTextColor: AppColors.ink,
        helpTextStyle: body.copyWith(color: AppColors.ink, fontSize: 14),
        hourMinuteTextStyle: pixel.copyWith(fontSize: 32),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.antiqueGold,
          textStyle: body.copyWith(fontSize: 16),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.ink,
          textStyle: body.copyWith(fontSize: 16),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.dungeon,
        indicatorColor: AppColors.gold.withValues(alpha: 0.28),
        surfaceTintColor: AppColors.dungeon,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gold : AppColors.parchment,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return koreanTitle.copyWith(
            fontSize: 12,
            color: selected ? AppColors.gold : AppColors.parchment,
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
