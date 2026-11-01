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

  @override
  String get sectionTitle => 'Quest name';

  @override
  String get sectionChecklist => 'Detail checklist';

  @override
  String get sectionDateTime => 'Date · time';

  @override
  String get sectionRepeat => 'Repeat weekdays';

  @override
  String get sectionTags => 'Tags';

  @override
  String get suggestionCategoryStudent => 'Student';

  @override
  String get suggestionCategoryWorker => 'Office';

  @override
  String get suggestionCategoryExercise => 'Fitness';

  @override
  String get suggestionStudentMorningStudy => 'Morning study';

  @override
  String get suggestionStudentReview => 'Review 30 min';

  @override
  String get suggestionStudentHomework => 'Finish homework';

  @override
  String get suggestionStudentVocabulary => 'Vocabulary drill';

  @override
  String get suggestionWorkerCommutePrep => 'Commute prep';

  @override
  String get suggestionWorkerCheckMail => 'Check work mail';

  @override
  String get suggestionWorkerMeetingNotes => 'Meeting notes';

  @override
  String get suggestionWorkerLeaveRoutine => 'Leave-work routine';

  @override
  String get suggestionExerciseStretch => 'Stretching';

  @override
  String get suggestionExerciseRun => 'Running';

  @override
  String get suggestionExerciseStrength => 'Strength training';

  @override
  String get suggestionExerciseHydrate => 'Drink water';

  @override
  String get checklistItemHint => 'Detail item (e.g. buy carrots)';

  @override
  String get addChecklistItem => 'Add';

  @override
  String get deleteChecklistItem => 'Delete item';

  @override
  String get pickStartDate => 'Pick start date';

  @override
  String get pickReminderTime => 'Pick reminder time';

  @override
  String get clearDateTime => 'Clear';

  @override
  String get dateTimeUnset => 'Date · time unset (optional)';

  @override
  String dateTimeCombined(String date, String time) {
    return '$date · $time';
  }

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get repeatEverydayHint => 'Leave empty to repeat every day.';

  @override
  String get tagExercise => 'Fitness';

  @override
  String get tagStudy => 'Study';

  @override
  String get tagLife => 'Life';

  @override
  String get tagWork => 'Work';

  @override
  String get tagHealth => 'Health';

  @override
  String get tagHobby => 'Hobby';

  @override
  String get tagMeditation => 'Meditation';

  @override
  String get tagSleep => 'Sleep';

  @override
  String get saveFailed => 'Failed to save the quest. Please try again.';

  @override
  String get titleRequired => 'Please enter a quest name.';
}
