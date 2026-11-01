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
  /// **'To do'**
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
  /// **'퀘스트 완료! +{xp} XP'**
  String completedToast(int xp);
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
