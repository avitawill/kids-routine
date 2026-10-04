// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'השגרה שלי';

  @override
  String greetingMorning(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'בוקר טוב$_temp0!';
  }

  @override
  String greetingNoon(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'צהריים טובים$_temp0!';
  }

  @override
  String greetingEvening(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'ערב טוב$_temp0!';
  }

  @override
  String letsStart(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'בואי נתחיל!',
      'other': 'בוא נתחיל!',
    });
    return '$_temp0';
  }

  @override
  String get routineMorning => 'בוקר';

  @override
  String get routineNoon => 'צהריים';

  @override
  String get routineEvening => 'ערב';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String routineProgress(int done, int total) {
    return '$done מתוך $total';
  }

  @override
  String get routineFinished => 'כל הכבוד! ✨';

  @override
  String get doneButton => 'סיימתי!';

  @override
  String get nextUp => 'אחר כך:';

  @override
  String get replayAudio => 'להשמיע שוב';

  @override
  String get goHome => 'חזרה הביתה';

  @override
  String get parentMode => 'מצב הורים';

  @override
  String starCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count כוכבים',
      one: 'כוכב אחד',
    );
    return '$_temp0';
  }

  @override
  String celebrationTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'את אלופה!',
      'other': 'אתה אלוף!',
    });
    return '$_temp0';
  }

  @override
  String celebrationRoutineDone(String routine) {
    return 'סיימנו את שגרת ה$routine!';
  }

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'קיבלת $count כוכבים!',
      one: 'קיבלת כוכב אחד!',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String starsTotal(int count) {
    return 'יש לך $count ⭐';
  }

  @override
  String rewardToGo(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'עוד $count כוכבים ל$name!',
      one: 'עוד כוכב אחד ל$name!',
    );
    return '$_temp0';
  }

  @override
  String rewardReady(String name) {
    return 'יש מספיק כוכבים ל$name! 🎉';
  }

  @override
  String get holdForParents => 'לחיצה ארוכה למצב הורים';

  @override
  String get exitParentMode => 'יציאה ממצב הורים';

  @override
  String get gateTitle => 'רק להורים';

  @override
  String gateQuestion(int a, int b) {
    return '$a × $b = ?';
  }

  @override
  String get gateTryAgain => 'לא בדיוק. הנה שאלה אחרת.';

  @override
  String get gateConfirm => 'אישור';

  @override
  String get gateBackspace => 'מחיקת ספרה';

  @override
  String get cancel => 'ביטול';

  @override
  String get save => 'שמירה';

  @override
  String get delete => 'מחיקה';

  @override
  String get parentRoutines => 'שגרות';

  @override
  String get parentTasks => 'ספריית משימות';

  @override
  String get parentRewards => 'פרסים';

  @override
  String get parentSummary => 'סיכום יומי';

  @override
  String get parentSettings => 'הגדרות';

  @override
  String get routineStartTime => 'שעת התחלה';

  @override
  String get routineDays => 'ימים';

  @override
  String dayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'sun': 'א׳',
      'mon': 'ב׳',
      'tue': 'ג׳',
      'wed': 'ד׳',
      'thu': 'ה׳',
      'fri': 'ו׳',
      'sat': 'ש׳',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get routineReminder => 'תזכורת';

  @override
  String get routineReminderLater => 'התזכורות יתחילו לפעול בשלב הבא';

  @override
  String get routineTasks => 'משימות';

  @override
  String get routineEmpty => 'אין עדיין משימות בשגרה';

  @override
  String get addTask => 'הוספת משימה';

  @override
  String get newTask => 'משימה חדשה';

  @override
  String get removeFromRoutine => 'הסרה מהשגרה';

  @override
  String get dragToReorder => 'גרירה לשינוי הסדר';

  @override
  String minutesShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count דק׳',
      one: 'דקה',
    );
    return '$_temp0';
  }

  @override
  String get builtIn => 'מובנית';

  @override
  String get taskEditTitle => 'עריכת משימה';

  @override
  String get taskNameHe => 'שם בעברית';

  @override
  String get taskNameEs => 'שם בספרדית (לא חובה)';

  @override
  String get taskNameEn => 'שם באנגלית (לא חובה)';

  @override
  String get taskNameRequired => 'צריך שם בעברית';

  @override
  String get chooseEmoji => 'אימוג׳י';

  @override
  String get takePhoto => 'מצלמה';

  @override
  String get choosePhoto => 'גלריה';

  @override
  String get removePhoto => 'הסרת התמונה';

  @override
  String get taskVoice => 'הקלטה';

  @override
  String get recordVoice => 'הקלטה';

  @override
  String get stopRecording => 'עצירה';

  @override
  String get playRecording => 'השמעה';

  @override
  String get deleteRecording => 'מחיקת ההקלטה';

  @override
  String recordingNow(int seconds) {
    return 'מקליט… $seconds שנ׳';
  }

  @override
  String get noRecordingHint => 'בלי הקלטה, הטלפון יקריא את שם המשימה';

  @override
  String get micDenied => 'אין הרשאה למיקרופון. אפשר לאשר בהגדרות הטלפון.';

  @override
  String get taskMinutes => 'זמן מטרה';

  @override
  String deleteTaskConfirm(String name) {
    return 'למחוק את המשימה \"$name\"? היא תוסר מכל השגרות.';
  }

  @override
  String get discardChanges => 'לצאת בלי לשמור?';

  @override
  String get discard => 'יציאה בלי שמירה';

  @override
  String get keepEditing => 'המשך עריכה';

  @override
  String get rewardsEmpty => 'אין עדיין פרסים. אפשר להוסיף פרס עם הכפתור למטה.';

  @override
  String get addReward => 'הוספת פרס';

  @override
  String get rewardNew => 'פרס חדש';

  @override
  String get rewardEdit => 'עריכת פרס';

  @override
  String get rewardName => 'שם הפרס';

  @override
  String get rewardNameRequired => 'צריך שם לפרס';

  @override
  String get rewardCost => 'מחיר בכוכבים';

  @override
  String get redeem => 'מימוש';

  @override
  String redeemConfirmTitle(String name) {
    return 'לממש את \"$name\"?';
  }

  @override
  String redeemConfirmBody(int cost) {
    return 'זה הרגע לעשות את זה ביחד! ירדו $cost כוכבים.';
  }

  @override
  String get redeemDone => 'מומש! 🎉';

  @override
  String rewardStarsHave(int have, int cost) {
    return '$have מתוך $cost ⭐';
  }

  @override
  String get redeemedSection => 'מומשו';

  @override
  String redeemedOn(String date) {
    return 'מומש ב־$date';
  }

  @override
  String get offerAgain => 'להציע שוב';

  @override
  String deleteRewardConfirm(String name) {
    return 'למחוק את הפרס \"$name\"?';
  }

  @override
  String starBalance(int count) {
    return 'יתרה: $count ⭐';
  }

  @override
  String get today => 'היום';

  @override
  String get previousDay => 'יום קודם';

  @override
  String get nextDay => 'יום הבא';

  @override
  String summaryStars(int count) {
    return 'כוכבים שנאספו: $count';
  }

  @override
  String get summaryEmpty => 'אין פעילות ביום הזה';

  @override
  String summaryFinished(String start, String end, String duration) {
    return '$start–$end · $duration';
  }

  @override
  String summaryInProgress(String start, int done, int total) {
    return 'התחילה ב־$start · $done מתוך $total';
  }

  @override
  String summaryTaken(String taken, String target) {
    return '$taken (יעד $target)';
  }

  @override
  String get summaryNotDone => 'לא סומנה';

  @override
  String get lessThanMinute => 'פחות מדקה';

  @override
  String get childName => 'שם הילד/ה';

  @override
  String get childGender => 'מגדר (לנוסח הפנייה)';

  @override
  String get genderFemale => 'בת';

  @override
  String get genderMale => 'בן';

  @override
  String get mascotName => 'שם הדמות';

  @override
  String get saved => 'נשמר';
}
