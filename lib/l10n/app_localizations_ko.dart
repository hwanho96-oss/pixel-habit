// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pixel Habit';

  @override
  String get tabRoutine => '루틴';

  @override
  String get tabTodo => 'To do';

  @override
  String get tabCalendar => '캘린더';

  @override
  String get tabCharacter => '캐릭터';

  @override
  String get tabSummary => '종합';

  @override
  String get addRoutine => '새로운 루틴을 추가할 수 있는 버튼';

  @override
  String get myProfile => '내 프로필';

  @override
  String get emptyRoutines => '아직 퀘스트가 없습니다.\n+ 버튼으로 첫 루틴을 등록하세요.';

  @override
  String get addRoutineTitle => '새 퀘스트 등록';

  @override
  String get routineNameHint => '루틴 이름 (예: 아침 수련)';

  @override
  String get routineNoteHint => '메모 (선택)';

  @override
  String get save => '등록';

  @override
  String get cancel => '닫기';

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
  String get comingSoon => '이 지역은 아직 봉인되어 있습니다.';

  @override
  String get deleteRoutine => '루틴 삭제';

  @override
  String get deleteRoutineConfirm => '이 퀘스트를 포기할까요?';

  @override
  String get completedStamp => '완료';

  @override
  String completedToast(int xp) {
    return '퀘스트 완료! +$xp XP';
  }

  @override
  String get sectionTitle => '퀘스트 이름';

  @override
  String get sectionChecklist => '세부 체크리스트';

  @override
  String get sectionDateTime => '날짜 · 시간';

  @override
  String get sectionRepeat => '반복 요일';

  @override
  String get sectionTags => '태그';

  @override
  String get suggestionCategoryStudent => '학생';

  @override
  String get suggestionCategoryWorker => '직장인';

  @override
  String get suggestionCategoryExercise => '운동';

  @override
  String get suggestionStudentMorningStudy => '아침 자습';

  @override
  String get suggestionStudentReview => '복습 30분';

  @override
  String get suggestionStudentHomework => '과제 끝내기';

  @override
  String get suggestionStudentVocabulary => '영어 단어';

  @override
  String get suggestionWorkerCommutePrep => '출근 준비';

  @override
  String get suggestionWorkerCheckMail => '업무 메일 확인';

  @override
  String get suggestionWorkerMeetingNotes => '회의 정리';

  @override
  String get suggestionWorkerLeaveRoutine => '퇴근 루틴';

  @override
  String get suggestionExerciseStretch => '스트레칭';

  @override
  String get suggestionExerciseRun => '러닝';

  @override
  String get suggestionExerciseStrength => '근력 운동';

  @override
  String get suggestionExerciseHydrate => '물 마시기';

  @override
  String get checklistItemHint => '세부 항목 (예: 당근 사기)';

  @override
  String get addChecklistItem => '추가';

  @override
  String get deleteChecklistItem => '항목 삭제';

  @override
  String get pickStartDate => '시작 날짜 선택';

  @override
  String get pickReminderTime => '알림 시간 선택';

  @override
  String get clearDateTime => '지우기';

  @override
  String get dateTimeUnset => '날짜 · 시간 미설정 (선택)';

  @override
  String dateTimeCombined(String date, String time) {
    return '$date · $time';
  }

  @override
  String get weekdayMon => '월';

  @override
  String get weekdayTue => '화';

  @override
  String get weekdayWed => '수';

  @override
  String get weekdayThu => '목';

  @override
  String get weekdayFri => '금';

  @override
  String get weekdaySat => '토';

  @override
  String get weekdaySun => '일';

  @override
  String get repeatEverydayHint => '선택 없으면 매일 반복으로 저장됩니다.';

  @override
  String get tagExercise => '운동';

  @override
  String get tagStudy => '학업';

  @override
  String get tagLife => '생활';

  @override
  String get tagWork => '업무';

  @override
  String get tagHealth => '건강';

  @override
  String get tagHobby => '취미';

  @override
  String get tagMeditation => '명상';

  @override
  String get tagSleep => '수면';

  @override
  String get saveFailed => '퀘스트 저장에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get titleRequired => '퀘스트 이름을 입력해 주세요.';
}
