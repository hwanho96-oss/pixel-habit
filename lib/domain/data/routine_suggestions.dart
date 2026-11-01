/// Suggestion catalog keys. Display strings come from l10n.
abstract final class RoutineSuggestions {
  static const student = 'student';
  static const worker = 'worker';
  static const exercise = 'exercise';

  static const categories = <String>[
    student,
    worker,
    exercise,
  ];

  static const Map<String, List<String>> byCategory = {
    student: [
      'studentMorningStudy',
      'studentReview',
      'studentHomework',
      'studentVocabulary',
    ],
    worker: [
      'workerCommutePrep',
      'workerCheckMail',
      'workerMeetingNotes',
      'workerLeaveRoutine',
    ],
    exercise: [
      'exerciseStretch',
      'exerciseRun',
      'exerciseStrength',
      'exerciseHydrate',
    ],
  };
}
