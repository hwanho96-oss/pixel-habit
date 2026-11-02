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
