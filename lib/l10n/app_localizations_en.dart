// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pixel Habit';

  @override
  String get tabRoutine => 'Routine';

  @override
  String get tabTodo => 'To do';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabCharacter => 'Character';

  @override
  String get tabSummary => 'Summary';

  @override
  String get addRoutine => 'Add a new routine';

  @override
  String get myProfile => 'My profile';

  @override
  String get emptyRoutines =>
      'No quests yet.\nTap + to register your first routine.';

  @override
  String get addRoutineTitle => 'New quest';

  @override
  String get routineNameHint => 'Routine name (e.g. Morning drill)';

  @override
  String get routineNoteHint => 'Note (optional)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Close';

  @override
  String xpLabel(int xp) {
    return '+$xp XP';
  }

  @override
  String levelLabel(int level) {
    return 'Lv.$level';
  }

  @override
  String get expLabel => 'EXP';

  @override
  String expProgress(int current, int max) {
    return '$current/$max';
  }

  @override
  String get comingSoon => 'This region is still sealed.';

  @override
  String get deleteRoutine => 'Delete routine';

  @override
  String get deleteRoutineConfirm => 'Abandon this quest?';

  @override
  String get completedStamp => 'DONE';

  @override
  String completedToast(int xp) {
    return 'Quest complete! +$xp XP';
  }
}
