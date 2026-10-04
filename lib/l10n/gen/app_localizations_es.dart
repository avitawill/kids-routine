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
}
