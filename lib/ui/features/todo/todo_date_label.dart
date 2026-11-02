import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';

String todoDateLabel(DateTime date, AppLocalizations l10n, {DateTime? now}) {
  final clock = now ?? DateTime.now();
  final today = DateTime(clock.year, clock.month, clock.day);
  final target = DateTime(date.year, date.month, date.day);
  if (target == today) {
    return l10n.dateToday;
  }
  if (target == today.add(const Duration(days: 1))) {
    return l10n.dateTomorrow;
  }
  return l10n.todoDate(target.month, target.day);
}

/// 날짜와 시간을 `오늘 · 오전 9:00`처럼 붙인다. 둘 다 없으면 null.
String? todoScheduleLabel(
  Todo todo,
  AppLocalizations l10n,
  MaterialLocalizations material,
) {
  final parts = <String>[];
  if (todo.date != null) {
    parts.add(todoDateLabel(todo.date!, l10n));
  }
  if (todo.hasTime) {
    parts.add(
      material.formatTimeOfDay(
        TimeOfDay(hour: todo.timeHour!, minute: todo.timeMinute!),
        alwaysUse24HourFormat: false,
      ),
    );
  }
  if (parts.isEmpty) {
    return null;
  }
  return parts.join(' · ');
}
