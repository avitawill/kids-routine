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

  /// Celebration: stars left to the next reward.
  ///
  /// In he, this message translates to:
  /// **'{count, plural, =1{עוד כוכב אחד ל{name}!} other{עוד {count} כוכבים ל{name}!}}'**
  String rewardToGo(int count, String name);

  /// No description provided for @rewardReady.
  ///
  /// In he, this message translates to:
  /// **'יש מספיק כוכבים ל{name}! 🎉'**
  String rewardReady(String name);

  /// Gear tooltip.
  ///
  /// In he, this message translates to:
  /// **'לחיצה ארוכה למצב הורים'**
  String get holdForParents;

  /// No description provided for @exitParentMode.
  ///
  /// In he, this message translates to:
  /// **'יציאה ממצב הורים'**
  String get exitParentMode;

  /// No description provided for @gateTitle.
  ///
  /// In he, this message translates to:
  /// **'רק להורים'**
  String get gateTitle;

  /// No description provided for @gateQuestion.
  ///
  /// In he, this message translates to:
  /// **'{a} × {b} = ?'**
  String gateQuestion(int a, int b);

  /// No description provided for @gateTryAgain.
  ///
  /// In he, this message translates to:
  /// **'לא בדיוק. הנה שאלה אחרת.'**
  String get gateTryAgain;

  /// No description provided for @gateConfirm.
  ///
  /// In he, this message translates to:
  /// **'אישור'**
  String get gateConfirm;

  /// No description provided for @gateBackspace.
  ///
  /// In he, this message translates to:
  /// **'מחיקת ספרה'**
  String get gateBackspace;

  /// No description provided for @cancel.
  ///
  /// In he, this message translates to:
  /// **'ביטול'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In he, this message translates to:
  /// **'שמירה'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In he, this message translates to:
  /// **'מחיקה'**
  String get delete;

  /// No description provided for @parentRoutines.
  ///
  /// In he, this message translates to:
  /// **'שגרות'**
  String get parentRoutines;

  /// No description provided for @parentTasks.
  ///
  /// In he, this message translates to:
  /// **'ספריית משימות'**
  String get parentTasks;

  /// No description provided for @parentRewards.
  ///
  /// In he, this message translates to:
  /// **'פרסים'**
  String get parentRewards;

  /// No description provided for @parentSummary.
  ///
  /// In he, this message translates to:
  /// **'סיכום יומי'**
  String get parentSummary;

  /// No description provided for @parentSettings.
  ///
  /// In he, this message translates to:
  /// **'הגדרות'**
  String get parentSettings;

  /// No description provided for @routineStartTime.
  ///
  /// In he, this message translates to:
  /// **'שעת התחלה'**
  String get routineStartTime;

  /// No description provided for @routineDays.
  ///
  /// In he, this message translates to:
  /// **'ימים'**
  String get routineDays;

  /// Short weekday name.
  ///
  /// In he, this message translates to:
  /// **'{day, select, sun{א׳} mon{ב׳} tue{ג׳} wed{ד׳} thu{ה׳} fri{ו׳} sat{ש׳} other{}}'**
  String dayShort(String day);

  /// No description provided for @routineReminder.
  ///
  /// In he, this message translates to:
  /// **'תזכורת'**
  String get routineReminder;

  /// No description provided for @routineReminderLater.
  ///
  /// In he, this message translates to:
  /// **'התזכורות יתחילו לפעול בשלב הבא'**
  String get routineReminderLater;

  /// No description provided for @routineTasks.
  ///
  /// In he, this message translates to:
  /// **'משימות'**
  String get routineTasks;

  /// No description provided for @routineEmpty.
  ///
  /// In he, this message translates to:
  /// **'אין עדיין משימות בשגרה'**
  String get routineEmpty;

  /// No description provided for @addTask.
  ///
  /// In he, this message translates to:
  /// **'הוספת משימה'**
  String get addTask;

  /// No description provided for @newTask.
  ///
  /// In he, this message translates to:
  /// **'משימה חדשה'**
  String get newTask;

  /// No description provided for @removeFromRoutine.
  ///
  /// In he, this message translates to:
  /// **'הסרה מהשגרה'**
  String get removeFromRoutine;

  /// No description provided for @dragToReorder.
  ///
  /// In he, this message translates to:
  /// **'גרירה לשינוי הסדר'**
  String get dragToReorder;

  /// No description provided for @minutesShort.
  ///
  /// In he, this message translates to:
  /// **'{count, plural, =1{דקה} other{{count} דק׳}}'**
  String minutesShort(int count);

  /// No description provided for @builtIn.
  ///
  /// In he, this message translates to:
  /// **'מובנית'**
  String get builtIn;

  /// No description provided for @taskEditTitle.
  ///
  /// In he, this message translates to:
  /// **'עריכת משימה'**
  String get taskEditTitle;

  /// No description provided for @taskNameHe.
  ///
  /// In he, this message translates to:
  /// **'שם בעברית'**
  String get taskNameHe;

  /// No description provided for @taskNameEs.
  ///
  /// In he, this message translates to:
  /// **'שם בספרדית (לא חובה)'**
  String get taskNameEs;

  /// No description provided for @taskNameEn.
  ///
  /// In he, this message translates to:
  /// **'שם באנגלית (לא חובה)'**
  String get taskNameEn;

  /// No description provided for @taskNameRequired.
  ///
  /// In he, this message translates to:
  /// **'צריך שם בעברית'**
  String get taskNameRequired;

  /// No description provided for @taskPicture.
  ///
  /// In he, this message translates to:
  /// **'תמונה'**
  String get taskPicture;

  /// No description provided for @chooseEmoji.
  ///
  /// In he, this message translates to:
  /// **'אימוג׳י'**
  String get chooseEmoji;

  /// No description provided for @takePhoto.
  ///
  /// In he, this message translates to:
  /// **'מצלמה'**
  String get takePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In he, this message translates to:
  /// **'גלריה'**
  String get choosePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In he, this message translates to:
  /// **'הסרת התמונה'**
  String get removePhoto;

  /// No description provided for @taskVoice.
  ///
  /// In he, this message translates to:
  /// **'הקלטה'**
  String get taskVoice;

  /// No description provided for @recordVoice.
  ///
  /// In he, this message translates to:
  /// **'הקלטה'**
  String get recordVoice;

  /// No description provided for @stopRecording.
  ///
  /// In he, this message translates to:
  /// **'עצירה'**
  String get stopRecording;

  /// No description provided for @playRecording.
  ///
  /// In he, this message translates to:
  /// **'השמעה'**
  String get playRecording;

  /// No description provided for @deleteRecording.
  ///
  /// In he, this message translates to:
  /// **'מחיקת ההקלטה'**
  String get deleteRecording;

  /// No description provided for @recordingNow.
  ///
  /// In he, this message translates to:
  /// **'מקליט… {seconds} שנ׳'**
  String recordingNow(int seconds);

  /// No description provided for @noRecordingHint.
  ///
  /// In he, this message translates to:
  /// **'בלי הקלטה, הטלפון יקריא את שם המשימה'**
  String get noRecordingHint;

  /// No description provided for @micDenied.
  ///
  /// In he, this message translates to:
  /// **'אין הרשאה למיקרופון. אפשר לאשר בהגדרות הטלפון.'**
  String get micDenied;

  /// No description provided for @taskMinutes.
  ///
  /// In he, this message translates to:
  /// **'זמן מטרה'**
  String get taskMinutes;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In he, this message translates to:
  /// **'למחוק את המשימה \"{name}\"? היא תוסר מכל השגרות.'**
  String deleteTaskConfirm(String name);

  /// No description provided for @discardChanges.
  ///
  /// In he, this message translates to:
  /// **'לצאת בלי לשמור?'**
  String get discardChanges;

  /// No description provided for @discard.
  ///
  /// In he, this message translates to:
  /// **'יציאה בלי שמירה'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In he, this message translates to:
  /// **'המשך עריכה'**
  String get keepEditing;

  /// No description provided for @rewardsEmpty.
  ///
  /// In he, this message translates to:
  /// **'אין עדיין פרסים. אפשר להוסיף פרס עם הכפתור למטה.'**
  String get rewardsEmpty;

  /// No description provided for @addReward.
  ///
  /// In he, this message translates to:
  /// **'הוספת פרס'**
  String get addReward;

  /// No description provided for @rewardNew.
  ///
  /// In he, this message translates to:
  /// **'פרס חדש'**
  String get rewardNew;

  /// No description provided for @rewardEdit.
  ///
  /// In he, this message translates to:
  /// **'עריכת פרס'**
  String get rewardEdit;

  /// No description provided for @rewardName.
  ///
  /// In he, this message translates to:
  /// **'שם הפרס'**
  String get rewardName;

  /// No description provided for @rewardNameRequired.
  ///
  /// In he, this message translates to:
  /// **'צריך שם לפרס'**
  String get rewardNameRequired;

  /// No description provided for @rewardCost.
  ///
  /// In he, this message translates to:
  /// **'מחיר בכוכבים'**
  String get rewardCost;

  /// No description provided for @redeem.
  ///
  /// In he, this message translates to:
  /// **'מימוש'**
  String get redeem;

  /// No description provided for @redeemConfirmTitle.
  ///
  /// In he, this message translates to:
  /// **'לממש את \"{name}\"?'**
  String redeemConfirmTitle(String name);

  /// No description provided for @redeemConfirmBody.
  ///
  /// In he, this message translates to:
  /// **'זה הרגע לעשות את זה ביחד! ירדו {cost} כוכבים.'**
  String redeemConfirmBody(int cost);

  /// No description provided for @redeemDone.
  ///
  /// In he, this message translates to:
  /// **'מומש! 🎉'**
  String get redeemDone;

  /// No description provided for @rewardStarsHave.
  ///
  /// In he, this message translates to:
  /// **'{have} מתוך {cost} ⭐'**
  String rewardStarsHave(int have, int cost);

  /// No description provided for @redeemedSection.
  ///
  /// In he, this message translates to:
  /// **'מומשו'**
  String get redeemedSection;

  /// No description provided for @redeemedOn.
  ///
  /// In he, this message translates to:
  /// **'מומש ב־{date}'**
  String redeemedOn(String date);

  /// No description provided for @offerAgain.
  ///
  /// In he, this message translates to:
  /// **'להציע שוב'**
  String get offerAgain;

  /// No description provided for @deleteRewardConfirm.
  ///
  /// In he, this message translates to:
  /// **'למחוק את הפרס \"{name}\"?'**
  String deleteRewardConfirm(String name);

  /// No description provided for @starBalance.
  ///
  /// In he, this message translates to:
  /// **'יתרה: {count} ⭐'**
  String starBalance(int count);

  /// No description provided for @today.
  ///
  /// In he, this message translates to:
  /// **'היום'**
  String get today;

  /// No description provided for @previousDay.
  ///
  /// In he, this message translates to:
  /// **'יום קודם'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In he, this message translates to:
  /// **'יום הבא'**
  String get nextDay;

  /// No description provided for @summaryStars.
  ///
  /// In he, this message translates to:
  /// **'כוכבים שנאספו: {count}'**
  String summaryStars(int count);

  /// No description provided for @summaryEmpty.
  ///
  /// In he, this message translates to:
  /// **'אין פעילות ביום הזה'**
  String get summaryEmpty;

  /// No description provided for @summaryFinished.
  ///
  /// In he, this message translates to:
  /// **'{start}–{end} · {duration}'**
  String summaryFinished(String start, String end, String duration);

  /// No description provided for @summaryInProgress.
  ///
  /// In he, this message translates to:
  /// **'התחילה ב־{start} · {done} מתוך {total}'**
  String summaryInProgress(String start, int done, int total);

  /// No description provided for @summaryTaken.
  ///
  /// In he, this message translates to:
  /// **'{taken} (יעד {target})'**
  String summaryTaken(String taken, String target);

  /// No description provided for @summaryNotDone.
  ///
  /// In he, this message translates to:
  /// **'לא סומנה'**
  String get summaryNotDone;

  /// No description provided for @lessThanMinute.
  ///
  /// In he, this message translates to:
  /// **'פחות מדקה'**
  String get lessThanMinute;

  /// No description provided for @childName.
  ///
  /// In he, this message translates to:
  /// **'שם הילד/ה'**
  String get childName;

  /// No description provided for @childGender.
  ///
  /// In he, this message translates to:
  /// **'מגדר (לנוסח הפנייה)'**
  String get childGender;

  /// No description provided for @genderFemale.
  ///
  /// In he, this message translates to:
  /// **'בת'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In he, this message translates to:
  /// **'בן'**
  String get genderMale;

  /// No description provided for @mascotName.
  ///
  /// In he, this message translates to:
  /// **'שם הדמות'**
  String get mascotName;

  /// No description provided for @saved.
  ///
  /// In he, this message translates to:
  /// **'נשמר'**
  String get saved;
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
