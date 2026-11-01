import 'package:pixel_habit/domain/data/routine_suggestions.dart';
import 'package:pixel_habit/domain/data/routine_tags.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';

extension RoutineFormL10n on AppLocalizations {
  String suggestionCategoryLabel(String categoryId) {
    return switch (categoryId) {
      RoutineSuggestions.student => suggestionCategoryStudent,
      RoutineSuggestions.worker => suggestionCategoryWorker,
      RoutineSuggestions.exercise => suggestionCategoryExercise,
      _ => categoryId,
    };
  }

  String suggestionLabel(String suggestionId) {
    return switch (suggestionId) {
      'studentMorningStudy' => suggestionStudentMorningStudy,
      'studentReview' => suggestionStudentReview,
      'studentHomework' => suggestionStudentHomework,
      'studentVocabulary' => suggestionStudentVocabulary,
      'workerCommutePrep' => suggestionWorkerCommutePrep,
      'workerCheckMail' => suggestionWorkerCheckMail,
      'workerMeetingNotes' => suggestionWorkerMeetingNotes,
      'workerLeaveRoutine' => suggestionWorkerLeaveRoutine,
      'exerciseStretch' => suggestionExerciseStretch,
      'exerciseRun' => suggestionExerciseRun,
      'exerciseStrength' => suggestionExerciseStrength,
      'exerciseHydrate' => suggestionExerciseHydrate,
      _ => suggestionId,
    };
  }

  String tagLabel(String tagId) {
    return switch (tagId) {
      RoutineTags.exercise => tagExercise,
      RoutineTags.study => tagStudy,
      RoutineTags.life => tagLife,
      RoutineTags.work => tagWork,
      RoutineTags.health => tagHealth,
      RoutineTags.hobby => tagHobby,
      RoutineTags.meditation => tagMeditation,
      RoutineTags.sleep => tagSleep,
      _ => tagId,
    };
  }

  List<String> get weekdayLabels => [
        weekdayMon,
        weekdayTue,
        weekdayWed,
        weekdayThu,
        weekdayFri,
        weekdaySat,
        weekdaySun,
      ];
}
