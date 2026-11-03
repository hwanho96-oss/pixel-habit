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
  String get tabTodo => '할 일';

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
  String completedToast(int xp, int gold) {
    return '퀘스트 완료! +$xp XP · +$gold 골드';
  }

  @override
  String goldAmount(int gold) {
    return '$gold 골드';
  }

  @override
  String goldGain(int gold) {
    return '+$gold 골드';
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

  @override
  String get assetCredit => 'UI 에셋 - Franuka';

  @override
  String get assetCreditUrl => 'https://franuka.itch.io/rpg-ui-pack-demo';

  @override
  String get addTodo => '새로운 할 일을 추가할 수 있는 버튼';

  @override
  String get emptyTodos => '아직 할 일이 없습니다.\n+ 버튼으로 첫 할 일을 추가하세요.';

  @override
  String get addTodoTitle => '할 일 추가';

  @override
  String get sectionTodoName => '할 일 이름';

  @override
  String get todoNameHint => '할 일 이름 (예: 장보기)';

  @override
  String get sectionTodoDate => '날짜';

  @override
  String get choiceNone => '없음';

  @override
  String get dateToday => '오늘';

  @override
  String get dateTomorrow => '내일';

  @override
  String todoDate(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get sectionStat => '스탯';

  @override
  String get statStrength => '힘';

  @override
  String get statIntelligence => '지능';

  @override
  String get statWisdom => '지혜';

  @override
  String get deleteTodo => '할 일 삭제';

  @override
  String get deleteTodoConfirm => '이 할 일을 지울까요?';

  @override
  String todoCompletedToast(int xp, int gold) {
    return '할 일 완료! +$xp XP · +$gold 골드';
  }

  @override
  String get todoSaveFailed => '할 일 저장에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get tabHome => '홈';

  @override
  String get tabAvatar => '아바타';

  @override
  String get tabRecords => '기록';

  @override
  String get tabSettings => '설정';

  @override
  String get segmentTodo => '투두';

  @override
  String traineeLabel(int level) {
    return 'Lv.$level 훈련생';
  }

  @override
  String get emptyRoutineInvite => '함께 키워갈 첫 루틴을 골라볼까?';

  @override
  String get starterWater => '물 마시기';

  @override
  String get starterStretch => '스트레칭 5분';

  @override
  String get starterRead => '10분 독서';

  @override
  String get starterSleep => '일찍 자기';

  @override
  String get emptyTodoGentle => '오늘은 여유로운 하루네. 할 일이 생기면 + 를 눌러줘';

  @override
  String get allQuestsDone => '오늘 퀘스트 완료! 푹 쉬어, 모험가';

  @override
  String get restedYesterday => '어제는 쉬어갔구나. 오늘은 하나만 해볼까?';

  @override
  String get recordsPlaceholder => '캘린더는 다음에 이 자리에 들어올 거야.';

  @override
  String get sectionTodoTime => '시간';

  @override
  String get pickTodoTime => '시간 선택';

  @override
  String get soundCredit => '동전 효과음 - Kenney (CC0)';

  @override
  String get soundCreditUrl => 'https://kenney.nl/assets/rpg-audio';

  @override
  String get shopTab => '상점';

  @override
  String get personalityTab => '성격';

  @override
  String get personalityPlaceholder => '성격은 다음에 이 자리에 들어올 거야.';

  @override
  String get shopCategoryTop => '상의';

  @override
  String get shopCategoryBottom => '하의';

  @override
  String get shopCategoryWeapon => '무기';

  @override
  String get shopCategoryPet => '펫';

  @override
  String get shopCategoryBackground => '배경';

  @override
  String get shopNeedGold => '골드가 조금 모자라. 퀘스트를 해 보면 어때?';

  @override
  String get shopOwned => '보유';

  @override
  String get shopEquipped => '착용 중';
}
