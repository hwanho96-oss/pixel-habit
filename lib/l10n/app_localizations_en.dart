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
  String completedToast(int xp, int gold) {
    return 'Quest complete! +$xp XP · +$gold gold';
  }

  @override
  String goldAmount(int gold) {
    return '$gold gold';
  }

  @override
  String goldGain(int gold) {
    return '+$gold gold';
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

  @override
  String get assetCredit => 'UI assets - Franuka';

  @override
  String get assetCreditUrl => 'https://franuka.itch.io/rpg-ui-pack-demo';

  @override
  String get addTodo => 'Add a new to-do';

  @override
  String get emptyTodos => 'No to-dos yet.\nTap + to add the first one.';

  @override
  String get addTodoTitle => 'Add to-do';

  @override
  String get sectionTodoName => 'To-do name';

  @override
  String get todoNameHint => 'To-do name (e.g. Buy groceries)';

  @override
  String get sectionTodoDate => 'Date';

  @override
  String get choiceNone => 'None';

  @override
  String get dateToday => 'Today';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String todoDate(int month, int day) {
    return '$month/$day';
  }

  @override
  String get sectionStat => 'Stat';

  @override
  String get statStrength => 'Strength';

  @override
  String get statIntelligence => 'Intelligence';

  @override
  String get statWisdom => 'Wisdom';

  @override
  String get deleteTodo => 'Delete to-do';

  @override
  String get deleteTodoConfirm => 'Delete this to-do?';

  @override
  String todoCompletedToast(int xp, int gold) {
    return 'To-do complete! +$xp XP · +$gold gold';
  }

  @override
  String get todoSaveFailed => 'Failed to save the to-do. Please try again.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabAvatar => 'Avatar';

  @override
  String get tabRecords => 'Log';

  @override
  String get tabSettings => 'Settings';

  @override
  String get segmentTodo => 'To-do';

  @override
  String traineeLabel(int level) {
    return 'Lv.$level Trainee';
  }

  @override
  String get emptyRoutineInvite =>
      'Want to pick a first routine to grow together?';

  @override
  String get starterWater => 'Drink water';

  @override
  String get starterStretch => 'Stretch for 5 min';

  @override
  String get starterRead => 'Read for 10 min';

  @override
  String get starterSleep => 'Sleep early';

  @override
  String get emptyTodoGentle =>
      'Today is a quiet day. Tap + when a to-do comes up.';

  @override
  String get allQuestsDone =>
      'All quests for today are done! Rest well, adventurer';

  @override
  String get restedYesterday =>
      'Yesterday was a rest day. Want to try just one today?';

  @override
  String get recordsPlaceholder => 'A calendar will land here next.';

  @override
  String get sectionTodoTime => 'Time';

  @override
  String get pickTodoTime => 'Pick a time';

  @override
  String get soundCredit => 'Coin sound - Kenney (CC0)';

  @override
  String get soundCreditUrl => 'https://kenney.nl/assets/rpg-audio';
}
