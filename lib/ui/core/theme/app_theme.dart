import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const bodyFontFamily = 'Pretendard';
  static const pixelFontFamily = 'Galmuri';

  /// Galmuri는 이 정수 크기에서만 쓴다. 본문에는 쓰지 않는다.
  static const pixelSizes = <double>[16, 24, 32];

  static TextStyle pixel({double fontSize = 16, Color color = AppColors.text}) {
    assert(
      pixelSizes.contains(fontSize),
      'Galmuri fontSize must be 16, 24, or 32.',
    );
    return TextStyle(
      fontFamily: pixelFontFamily,
      fontSize: fontSize,
      height: 1.15,
      color: color,
    );
  }

  static ThemeData light() {
    const body = TextStyle(
      fontFamily: bodyFontFamily,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
      fontSize: 16,
      height: 1.45,
    );
    final title = body.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      height: 1.3,
    );
    const radius = BorderRadius.all(Radius.circular(12));
    const border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.textOnDark,
        secondary: AppColors.gold,
        onSecondary: AppColors.text,
        surface: AppColors.textOnDark,
        onSurface: AppColors.text,
        error: AppColors.statStrength,
        onError: AppColors.textOnDark,
      ),
      textTheme: TextTheme(
        titleLarge: title,
        titleMedium: title.copyWith(fontSize: 16),
        bodyLarge: body,
        bodyMedium: body.copyWith(fontSize: 15),
        labelSmall: body.copyWith(
          fontSize: 13,
          height: 1.35,
          color: AppColors.text.withValues(alpha: 0.68),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: title,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.textOnDark,
        titleTextStyle: title.copyWith(fontSize: 18),
        contentTextStyle: body,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.textOnDark,
        hintStyle: body.copyWith(
          color: AppColors.text.withValues(alpha: 0.42),
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.statStrength),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.textOnDark,
        selectedColor: AppColors.accent,
        disabledColor: AppColors.border,
        labelStyle: body.copyWith(fontSize: 14),
        secondaryLabelStyle: body.copyWith(
          fontSize: 14,
          color: AppColors.textOnDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
        side: const BorderSide(color: AppColors.border),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.textOnDark,
        headerBackgroundColor: AppColors.accent,
        headerForegroundColor: AppColors.textOnDark,
        weekdayStyle: body.copyWith(fontSize: 13),
        dayStyle: pixel(),
        yearStyle: pixel(),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.text.withValues(alpha: 0.32);
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnDark;
          }
          return AppColors.text;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: const WidgetStatePropertyAll(AppColors.accent),
        todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        todayBorder: const BorderSide(color: AppColors.accent),
        yearForegroundColor: const WidgetStatePropertyAll(AppColors.text),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return Colors.transparent;
        }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        dividerColor: AppColors.border,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.textOnDark,
        hourMinuteColor: AppColors.background,
        hourMinuteTextColor: AppColors.text,
        dialHandColor: AppColors.accent,
        dialBackgroundColor: AppColors.background,
        dialTextColor: AppColors.text,
        entryModeIconColor: AppColors.accent,
        dayPeriodColor: AppColors.accent,
        dayPeriodTextColor: AppColors.text,
        helpTextStyle: body.copyWith(fontSize: 14),
        hourMinuteTextStyle: pixel(fontSize: 32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: body.copyWith(fontWeight: FontWeight.w600),
          shape: const StadiumBorder(),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnDark,
          textStyle: body.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.textOnDark,
        indicatorColor: AppColors.accent.withValues(alpha: 0.16),
        surfaceTintColor: AppColors.textOnDark,
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? AppColors.accent
                : AppColors.text.withValues(alpha: 0.45),
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return body.copyWith(
            fontSize: 11,
            height: 1.2,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? AppColors.accent
                : AppColors.text.withValues(alpha: 0.62),
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.dark,
        contentTextStyle: body.copyWith(color: AppColors.textOnDark),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
