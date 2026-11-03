import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'Pixel Habit'**
  String get appTitle;

  /// No description provided for @tabRoutine.
  ///
  /// In ko, this message translates to:
  /// **'루틴'**
  String get tabRoutine;

  /// No description provided for @tabTodo.
  ///
  /// In ko, this message translates to:
  /// **'할 일'**
  String get tabTodo;

  /// No description provided for @tabCalendar.
  ///
  /// In ko, this message translates to:
  /// **'캘린더'**
  String get tabCalendar;

  /// No description provided for @tabCharacter.
  ///
  /// In ko, this message translates to:
  /// **'캐릭터'**
  String get tabCharacter;

  /// No description provided for @tabSummary.
  ///
  /// In ko, this message translates to:
  /// **'종합'**
  String get tabSummary;

  /// No description provided for @addRoutine.
  ///
  /// In ko, this message translates to:
  /// **'새로운 루틴을 추가할 수 있는 버튼'**
  String get addRoutine;

  /// No description provided for @myProfile.
  ///
  /// In ko, this message translates to:
  /// **'내 프로필'**
  String get myProfile;

  /// No description provided for @emptyRoutines.
  ///
  /// In ko, this message translates to:
  /// **'아직 퀘스트가 없습니다.\n+ 버튼으로 첫 루틴을 등록하세요.'**
  String get emptyRoutines;

  /// No description provided for @addRoutineTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 퀘스트 등록'**
  String get addRoutineTitle;

  /// No description provided for @routineNameHint.
  ///
  /// In ko, this message translates to:
  /// **'루틴 이름 (예: 아침 수련)'**
  String get routineNameHint;

  /// No description provided for @routineNoteHint.
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get routineNoteHint;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'등록'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get cancel;

  /// No description provided for @xpLabel.
  ///
  /// In ko, this message translates to:
  /// **'+{xp} XP'**
  String xpLabel(int xp);

  /// No description provided for @levelLabel.
  ///
  /// In ko, this message translates to:
  /// **'Lv.{level}'**
  String levelLabel(int level);

  /// No description provided for @expLabel.
  ///
  /// In ko, this message translates to:
  /// **'EXP'**
  String get expLabel;

  /// No description provided for @expProgress.
  ///
  /// In ko, this message translates to:
  /// **'{current}/{max}'**
  String expProgress(int current, int max);

  /// No description provided for @comingSoon.
  ///
  /// In ko, this message translates to:
  /// **'이 지역은 아직 봉인되어 있습니다.'**
  String get comingSoon;

  /// No description provided for @deleteRoutine.
  ///
  /// In ko, this message translates to:
  /// **'루틴 삭제'**
  String get deleteRoutine;

  /// No description provided for @deleteRoutineConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 퀘스트를 포기할까요?'**
  String get deleteRoutineConfirm;

  /// No description provided for @completedStamp.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completedStamp;

  /// No description provided for @completedToast.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 완료! +{xp} XP · +{gold} 골드'**
  String completedToast(int xp, int gold);

  /// No description provided for @goldAmount.
  ///
  /// In ko, this message translates to:
  /// **'{gold} 골드'**
  String goldAmount(int gold);

  /// No description provided for @goldGain.
  ///
  /// In ko, this message translates to:
  /// **'+{gold} 골드'**
  String goldGain(int gold);

  /// No description provided for @sectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 이름'**
  String get sectionTitle;

  /// No description provided for @sectionChecklist.
  ///
  /// In ko, this message translates to:
  /// **'세부 체크리스트'**
  String get sectionChecklist;

  /// No description provided for @sectionDateTime.
  ///
  /// In ko, this message translates to:
  /// **'날짜 · 시간'**
  String get sectionDateTime;

  /// No description provided for @sectionRepeat.
  ///
  /// In ko, this message translates to:
  /// **'반복 요일'**
  String get sectionRepeat;

  /// No description provided for @sectionTags.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get sectionTags;

  /// No description provided for @suggestionCategoryStudent.
  ///
  /// In ko, this message translates to:
  /// **'학생'**
  String get suggestionCategoryStudent;

  /// No description provided for @suggestionCategoryWorker.
  ///
  /// In ko, this message translates to:
  /// **'직장인'**
  String get suggestionCategoryWorker;

  /// No description provided for @suggestionCategoryExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get suggestionCategoryExercise;

  /// No description provided for @suggestionStudentMorningStudy.
  ///
  /// In ko, this message translates to:
  /// **'아침 자습'**
  String get suggestionStudentMorningStudy;

  /// No description provided for @suggestionStudentReview.
  ///
  /// In ko, this message translates to:
  /// **'복습 30분'**
  String get suggestionStudentReview;

  /// No description provided for @suggestionStudentHomework.
  ///
  /// In ko, this message translates to:
  /// **'과제 끝내기'**
  String get suggestionStudentHomework;

  /// No description provided for @suggestionStudentVocabulary.
  ///
  /// In ko, this message translates to:
  /// **'영어 단어'**
  String get suggestionStudentVocabulary;

  /// No description provided for @suggestionWorkerCommutePrep.
  ///
  /// In ko, this message translates to:
  /// **'출근 준비'**
  String get suggestionWorkerCommutePrep;

  /// No description provided for @suggestionWorkerCheckMail.
  ///
  /// In ko, this message translates to:
  /// **'업무 메일 확인'**
  String get suggestionWorkerCheckMail;

  /// No description provided for @suggestionWorkerMeetingNotes.
  ///
  /// In ko, this message translates to:
  /// **'회의 정리'**
  String get suggestionWorkerMeetingNotes;

  /// No description provided for @suggestionWorkerLeaveRoutine.
  ///
  /// In ko, this message translates to:
  /// **'퇴근 루틴'**
  String get suggestionWorkerLeaveRoutine;

  /// No description provided for @suggestionExerciseStretch.
  ///
  /// In ko, this message translates to:
  /// **'스트레칭'**
  String get suggestionExerciseStretch;

  /// No description provided for @suggestionExerciseRun.
  ///
  /// In ko, this message translates to:
  /// **'러닝'**
  String get suggestionExerciseRun;

  /// No description provided for @suggestionExerciseStrength.
  ///
  /// In ko, this message translates to:
  /// **'근력 운동'**
  String get suggestionExerciseStrength;

  /// No description provided for @suggestionExerciseHydrate.
  ///
  /// In ko, this message translates to:
  /// **'물 마시기'**
  String get suggestionExerciseHydrate;

  /// No description provided for @checklistItemHint.
  ///
  /// In ko, this message translates to:
  /// **'세부 항목 (예: 당근 사기)'**
  String get checklistItemHint;

  /// No description provided for @addChecklistItem.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get addChecklistItem;

  /// No description provided for @deleteChecklistItem.
  ///
  /// In ko, this message translates to:
  /// **'항목 삭제'**
  String get deleteChecklistItem;

  /// No description provided for @pickStartDate.
  ///
  /// In ko, this message translates to:
  /// **'시작 날짜 선택'**
  String get pickStartDate;

  /// No description provided for @pickReminderTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간 선택'**
  String get pickReminderTime;

  /// No description provided for @clearDateTime.
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get clearDateTime;

  /// No description provided for @dateTimeUnset.
  ///
  /// In ko, this message translates to:
  /// **'날짜 · 시간 미설정 (선택)'**
  String get dateTimeUnset;

  /// No description provided for @dateTimeCombined.
  ///
  /// In ko, this message translates to:
  /// **'{date} · {time}'**
  String dateTimeCombined(String date, String time);

  /// No description provided for @weekdayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get weekdaySun;

  /// No description provided for @repeatEverydayHint.
  ///
  /// In ko, this message translates to:
  /// **'선택 없으면 매일 반복으로 저장됩니다.'**
  String get repeatEverydayHint;

  /// No description provided for @tagExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get tagExercise;

  /// No description provided for @tagStudy.
  ///
  /// In ko, this message translates to:
  /// **'학업'**
  String get tagStudy;

  /// No description provided for @tagLife.
  ///
  /// In ko, this message translates to:
  /// **'생활'**
  String get tagLife;

  /// No description provided for @tagWork.
  ///
  /// In ko, this message translates to:
  /// **'업무'**
  String get tagWork;

  /// No description provided for @tagHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get tagHealth;

  /// No description provided for @tagHobby.
  ///
  /// In ko, this message translates to:
  /// **'취미'**
  String get tagHobby;

  /// No description provided for @tagMeditation.
  ///
  /// In ko, this message translates to:
  /// **'명상'**
  String get tagMeditation;

  /// No description provided for @tagSleep.
  ///
  /// In ko, this message translates to:
  /// **'수면'**
  String get tagSleep;

  /// No description provided for @saveFailed.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 저장에 실패했습니다. 다시 시도해 주세요.'**
  String get saveFailed;

  /// No description provided for @titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 이름을 입력해 주세요.'**
  String get titleRequired;

  /// No description provided for @assetCredit.
  ///
  /// In ko, this message translates to:
  /// **'UI 에셋 - Franuka'**
  String get assetCredit;

  /// No description provided for @assetCreditUrl.
  ///
  /// In ko, this message translates to:
  /// **'https://franuka.itch.io/rpg-ui-pack-demo'**
  String get assetCreditUrl;

  /// No description provided for @addTodo.
  ///
  /// In ko, this message translates to:
  /// **'새로운 할 일을 추가할 수 있는 버튼'**
  String get addTodo;

  /// No description provided for @emptyTodos.
  ///
  /// In ko, this message translates to:
  /// **'아직 할 일이 없습니다.\n+ 버튼으로 첫 할 일을 추가하세요.'**
  String get emptyTodos;

  /// No description provided for @addTodoTitle.
  ///
  /// In ko, this message translates to:
  /// **'할 일 추가'**
  String get addTodoTitle;

  /// No description provided for @sectionTodoName.
  ///
  /// In ko, this message translates to:
  /// **'할 일 이름'**
  String get sectionTodoName;

  /// No description provided for @todoNameHint.
  ///
  /// In ko, this message translates to:
  /// **'할 일 이름 (예: 장보기)'**
  String get todoNameHint;

  /// No description provided for @sectionTodoDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get sectionTodoDate;

  /// No description provided for @choiceNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get choiceNone;

  /// No description provided for @dateToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get dateToday;

  /// No description provided for @dateTomorrow.
  ///
  /// In ko, this message translates to:
  /// **'내일'**
  String get dateTomorrow;

  /// No description provided for @todoDate.
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {day}일'**
  String todoDate(int month, int day);

  /// No description provided for @sectionStat.
  ///
  /// In ko, this message translates to:
  /// **'스탯'**
  String get sectionStat;

  /// No description provided for @statStrength.
  ///
  /// In ko, this message translates to:
  /// **'힘'**
  String get statStrength;

  /// No description provided for @statIntelligence.
  ///
  /// In ko, this message translates to:
  /// **'지능'**
  String get statIntelligence;

  /// No description provided for @statWisdom.
  ///
  /// In ko, this message translates to:
  /// **'지혜'**
  String get statWisdom;

  /// No description provided for @deleteTodo.
  ///
  /// In ko, this message translates to:
  /// **'할 일 삭제'**
  String get deleteTodo;

  /// No description provided for @deleteTodoConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 할 일을 지울까요?'**
  String get deleteTodoConfirm;

  /// No description provided for @todoCompletedToast.
  ///
  /// In ko, this message translates to:
  /// **'할 일 완료! +{xp} XP · +{gold} 골드'**
  String todoCompletedToast(int xp, int gold);

  /// No description provided for @todoSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'할 일 저장에 실패했습니다. 다시 시도해 주세요.'**
  String get todoSaveFailed;

  /// No description provided for @tabHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get tabHome;

  /// No description provided for @tabAvatar.
  ///
  /// In ko, this message translates to:
  /// **'아바타'**
  String get tabAvatar;

  /// No description provided for @tabRecords.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get tabRecords;

  /// No description provided for @tabSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get tabSettings;

  /// No description provided for @segmentTodo.
  ///
  /// In ko, this message translates to:
  /// **'투두'**
  String get segmentTodo;

  /// No description provided for @traineeLabel.
  ///
  /// In ko, this message translates to:
  /// **'Lv.{level} 훈련생'**
  String traineeLabel(int level);

  /// No description provided for @emptyRoutineInvite.
  ///
  /// In ko, this message translates to:
  /// **'함께 키워갈 첫 루틴을 골라볼까?'**
  String get emptyRoutineInvite;

  /// No description provided for @starterWater.
  ///
  /// In ko, this message translates to:
  /// **'물 마시기'**
  String get starterWater;

  /// No description provided for @starterStretch.
  ///
  /// In ko, this message translates to:
  /// **'스트레칭 5분'**
  String get starterStretch;

  /// No description provided for @starterRead.
  ///
  /// In ko, this message translates to:
  /// **'10분 독서'**
  String get starterRead;

  /// No description provided for @starterSleep.
  ///
  /// In ko, this message translates to:
  /// **'일찍 자기'**
  String get starterSleep;

  /// No description provided for @emptyTodoGentle.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 여유로운 하루네. 할 일이 생기면 + 를 눌러줘'**
  String get emptyTodoGentle;

  /// No description provided for @allQuestsDone.
  ///
  /// In ko, this message translates to:
  /// **'오늘 퀘스트 완료! 푹 쉬어, 모험가'**
  String get allQuestsDone;

  /// No description provided for @restedYesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제는 쉬어갔구나. 오늘은 하나만 해볼까?'**
  String get restedYesterday;

  /// No description provided for @recordsPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'캘린더는 다음에 이 자리에 들어올 거야.'**
  String get recordsPlaceholder;

  /// No description provided for @sectionTodoTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get sectionTodoTime;

  /// No description provided for @pickTodoTime.
  ///
  /// In ko, this message translates to:
  /// **'시간 선택'**
  String get pickTodoTime;

  /// No description provided for @soundCredit.
  ///
  /// In ko, this message translates to:
  /// **'동전 효과음 - Kenney (CC0)'**
  String get soundCredit;

  /// No description provided for @soundCreditUrl.
  ///
  /// In ko, this message translates to:
  /// **'https://kenney.nl/assets/rpg-audio'**
  String get soundCreditUrl;

  /// No description provided for @shopTab.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get shopTab;

  /// No description provided for @personalityTab.
  ///
  /// In ko, this message translates to:
  /// **'성격'**
  String get personalityTab;

  /// No description provided for @personalityPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'성격은 다음에 이 자리에 들어올 거야.'**
  String get personalityPlaceholder;

  /// No description provided for @shopCategoryTop.
  ///
  /// In ko, this message translates to:
  /// **'상의'**
  String get shopCategoryTop;

  /// No description provided for @shopCategoryBottom.
  ///
  /// In ko, this message translates to:
  /// **'하의'**
  String get shopCategoryBottom;

  /// No description provided for @shopCategoryWeapon.
  ///
  /// In ko, this message translates to:
  /// **'무기'**
  String get shopCategoryWeapon;

  /// No description provided for @shopCategoryPet.
  ///
  /// In ko, this message translates to:
  /// **'펫'**
  String get shopCategoryPet;

  /// No description provided for @shopCategoryBackground.
  ///
  /// In ko, this message translates to:
  /// **'배경'**
  String get shopCategoryBackground;

  /// No description provided for @shopNeedGold.
  ///
  /// In ko, this message translates to:
  /// **'골드가 조금 모자라. 퀘스트를 해 보면 어때?'**
  String get shopNeedGold;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
