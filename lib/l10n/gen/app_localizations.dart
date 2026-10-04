import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
    Locale('he'),
  ];

  /// App name shown in the task switcher.
  ///
  /// In he, this message translates to:
  /// **'השגרה שלי'**
  String get appTitle;

  /// Mascot greeting on Home before noon. `name` is the child's name, or the literal 'empty' when not set yet.
  ///
  /// In he, this message translates to:
  /// **'בוקר טוב{name, select, empty{} other{, {name}}}!'**
  String greetingMorning(String name);

  /// No description provided for @greetingNoon.
  ///
  /// In he, this message translates to:
  /// **'צהריים טובים{name, select, empty{} other{, {name}}}!'**
  String greetingNoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In he, this message translates to:
  /// **'ערב טוב{name, select, empty{} other{, {name}}}!'**
  String greetingEvening(String name);

  /// Mascot invitation on Home. Gendered by the child's gender.
  ///
  /// In he, this message translates to:
  /// **'{gender, select, female{בואי נתחיל!} other{בוא נתחיל!}}'**
  String letsStart(String gender);

  /// No description provided for @routineMorning.
  ///
  /// In he, this message translates to:
  /// **'בוקר'**
  String get routineMorning;

  /// No description provided for @routineNoon.
  ///
  /// In he, this message translates to:
  /// **'צהריים'**
  String get routineNoon;

  /// No description provided for @routineEvening.
  ///
  /// In he, this message translates to:
  /// **'ערב'**
  String get routineEvening;

  /// Shown on routine cards that are not available yet.
  ///
  /// In he, this message translates to:
  /// **'בקרוב'**
  String get comingSoon;

  /// No description provided for @routineProgress.
  ///
  /// In he, this message translates to:
  /// **'{done} מתוך {total}'**
  String routineProgress(int done, int total);

  /// Shown on a routine card that was completed today.
  ///
  /// In he, this message translates to:
  /// **'כל הכבוד! ✨'**
  String get routineFinished;

  /// The big Done button on the Task screen. 'סיימתי' is the same for both genders.
  ///
  /// In he, this message translates to:
  /// **'סיימתי!'**
  String get doneButton;

  /// Label before the small next-task peek.
  ///
  /// In he, this message translates to:
  /// **'אחר כך:'**
  String get nextUp;

  /// Tooltip / screen-reader label for the replay-audio button.
  ///
  /// In he, this message translates to:
  /// **'להשמיע שוב'**
  String get replayAudio;

  /// No description provided for @goHome.
  ///
  /// In he, this message translates to:
  /// **'חזרה הביתה'**
  String get goHome;

  /// Tooltip for the gear icon.
  ///
  /// In he, this message translates to:
  /// **'מצב הורים'**
  String get parentMode;

  /// Screen-reader label for the star counter.
  ///
  /// In he, this message translates to:
  /// **'{count, plural, =1{כוכב אחד} other{{count} כוכבים}}'**
  String starCount(int count);

  /// No description provided for @celebrationTitle.
  ///
  /// In he, this message translates to:
  /// **'{gender, select, female{את אלופה!} other{אתה אלוף!}}'**
  String celebrationTitle(String gender);

  /// No description provided for @celebrationRoutineDone.
  ///
  /// In he, this message translates to:
  /// **'סיימנו את שגרת ה{routine}!'**
  String celebrationRoutineDone(String routine);

  /// 'קיבלת' is spelled the same for both genders.
  ///
  /// In he, this message translates to:
  /// **'{count, plural, =0{} =1{קיבלת כוכב אחד!} other{קיבלת {count} כוכבים!}}'**
  String starsEarned(int count);

  /// No description provided for @starsTotal.
  ///
  /// In he, this message translates to:
  /// **'יש לך {count} ⭐'**
  String starsTotal(int count);
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
      <String>['en', 'es', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
