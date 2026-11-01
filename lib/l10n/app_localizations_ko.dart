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
}
