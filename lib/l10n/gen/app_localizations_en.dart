// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Routine';

  @override
  String greetingMorning(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'Good morning$_temp0!';
  }

  @override
  String greetingNoon(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'Good afternoon$_temp0!';
  }

  @override
  String greetingEvening(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return 'Good evening$_temp0!';
  }

  @override
  String letsStart(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Ready? Let\'s go!',
      'other': 'Ready? Let\'s go!',
    });
    return '$_temp0';
  }

  @override
  String get routineMorning => 'Morning';

  @override
  String get routineNoon => 'Afternoon';

  @override
  String get routineEvening => 'Evening';

  @override
  String routineProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String get routineFinished => 'Well done! ✨';

  @override
  String get doneButton => 'Done!';

  @override
  String get nextUp => 'Next:';

  @override
  String get replayAudio => 'Play again';

  @override
  String get goHome => 'Back home';

  @override
  String get parentMode => 'Parent mode';

  @override
  String starCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: 'one star',
    );
    return '$_temp0';
  }

  @override
  String celebrationTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'You\'re a champion!',
      'other': 'You\'re a champion!',
    });
    return '$_temp0';
  }

  @override
  String celebrationRoutineDone(String routine) {
    String _temp0 = intl.Intl.selectLogic(routine, {
      'morning': 'Morning routine done!',
      'noon': 'Afternoon routine done!',
      'evening': 'Evening routine done!',
      'other': 'All done!',
    });
    return '$_temp0';
  }

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You got $count stars!',
      one: 'You got a star!',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String starsTotal(int count) {
    return 'You have $count ⭐';
  }

  @override
  String rewardToGo(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more stars for $name!',
      one: 'One more star for $name!',
    );
    return '$_temp0';
  }

  @override
  String rewardReady(String name) {
    return 'Enough stars for $name! 🎉';
  }

  @override
  String get holdForParents => 'Press and hold for parent mode';

  @override
  String get exitParentMode => 'Exit parent mode';

  @override
  String get gateTitle => 'Parents only';

  @override
  String gateQuestion(int a, int b) {
    return '$a × $b = ?';
  }

  @override
  String get gateTryAgain => 'Not quite. Here\'s another one.';

  @override
  String get gateConfirm => 'OK';

  @override
  String get gateBackspace => 'Delete digit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get parentRoutines => 'Routines';

  @override
  String get parentTasks => 'Task library';

  @override
  String get parentRewards => 'Rewards';

  @override
  String get parentSummary => 'Daily summary';

  @override
  String get parentSettings => 'Settings';

  @override
  String get routineStartTime => 'Start time';

  @override
  String get routineDays => 'Days';

  @override
  String dayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'sun': 'Su',
      'mon': 'Mo',
      'tue': 'Tu',
      'wed': 'We',
      'thu': 'Th',
      'fri': 'Fr',
      'sat': 'Sa',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get routineReminder => 'Reminder';

  @override
  String get routineTasks => 'Tasks';

  @override
  String get routineEmpty => 'No tasks in this routine yet';

  @override
  String get addTask => 'Add task';

  @override
  String get newTask => 'New task';

  @override
  String get removeFromRoutine => 'Remove from routine';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String minutesShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get builtIn => 'Built-in';

  @override
  String get taskEditTitle => 'Edit task';

  @override
  String get taskNameHe => 'Name in Hebrew';

  @override
  String get taskNameEs => 'Name in Spanish (optional)';

  @override
  String get taskNameEn => 'Name in English (optional)';

  @override
  String get taskNameRequired => 'A Hebrew name is needed';

  @override
  String get chooseEmoji => 'Emoji';

  @override
  String get takePhoto => 'Camera';

  @override
  String get choosePhoto => 'Gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get taskVoice => 'Recording';

  @override
  String get recordVoice => 'Record';

  @override
  String get stopRecording => 'Stop';

  @override
  String get playRecording => 'Play';

  @override
  String get deleteRecording => 'Delete recording';

  @override
  String recordingNow(int seconds) {
    return 'Recording… $seconds s';
  }

  @override
  String get noRecordingHint =>
      'Without a recording, the phone reads the task name aloud';

  @override
  String get micDenied =>
      'No microphone permission. You can allow it in the phone settings.';

  @override
  String get taskMinutes => 'Target time';

  @override
  String deleteTaskConfirm(String name) {
    return 'Delete the task \"$name\"? It will be removed from every routine.';
  }

  @override
  String get discardChanges => 'Leave without saving?';

  @override
  String get discard => 'Leave without saving';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get rewardsEmpty => 'No rewards yet. Add one with the button below.';

  @override
  String get addReward => 'Add reward';

  @override
  String get rewardNew => 'New reward';

  @override
  String get rewardEdit => 'Edit reward';

  @override
  String get rewardName => 'Reward name';

  @override
  String get rewardNameRequired => 'A name is needed';

  @override
  String get rewardCost => 'Price in stars';

  @override
  String get redeem => 'Redeem';

  @override
  String redeemConfirmTitle(String name) {
    return 'Redeem \"$name\"?';
  }

  @override
  String redeemConfirmBody(int cost) {
    return 'Do it together now! $cost stars will be spent.';
  }

  @override
  String get redeemDone => 'Redeemed! 🎉';

  @override
  String rewardStarsHave(int have, int cost) {
    return '$have of $cost ⭐';
  }

  @override
  String get redeemedSection => 'Redeemed';

  @override
  String redeemedOn(String date) {
    return 'Redeemed on $date';
  }

  @override
  String get offerAgain => 'Offer again';

  @override
  String deleteRewardConfirm(String name) {
    return 'Delete the reward \"$name\"?';
  }

  @override
  String starBalance(int count) {
    return 'Balance: $count ⭐';
  }

  @override
  String get today => 'Today';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String summaryStars(int count) {
    return 'Stars earned: $count';
  }

  @override
  String get summaryEmpty => 'No activity on this day';

  @override
  String summaryFinished(String start, String end, String duration) {
    return '$start–$end · $duration';
  }

  @override
  String summaryInProgress(String start, int done, int total) {
    return 'Started at $start · $done of $total';
  }

  @override
  String summaryTaken(String taken, String target) {
    return '$taken (target $target)';
  }

  @override
  String get summaryNotDone => 'Not marked';

  @override
  String get lessThanMinute => 'under 1 min';

  @override
  String get childName => 'Child\'s name';

  @override
  String get childGender => 'Gender (for how the app speaks)';

  @override
  String get genderFemale => 'Girl';

  @override
  String get genderMale => 'Boy';

  @override
  String get mascotName => 'Mascot name';

  @override
  String get saved => 'Saved';

  @override
  String get routineReminderHint =>
      'A notification at the start time, on the chosen days';

  @override
  String notificationTitle(String routine) {
    String _temp0 = intl.Intl.selectLogic(routine, {
      'morning': '🌅 Time for the morning routine!',
      'noon': '☀️ Time for the afternoon routine!',
      'evening': '🌙 Time for the evening routine!',
      'other': 'Routine time!',
    });
    return '$_temp0';
  }

  @override
  String get reminderChannelName => 'Routine reminders';

  @override
  String get notificationsDenied =>
      'No notification permission. You can allow it in the phone settings.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get jewishPack => 'Jewish customs';

  @override
  String get jewishPackHint =>
      'Adds Modeh Ani, Netilat Yadayim, Birchot Hashachar, the blessing before food and the bedtime Shema';

  @override
  String get backupSection => 'Backup';

  @override
  String get backupExport => 'Save a backup file';

  @override
  String get backupImport => 'Restore from a backup file';

  @override
  String get backupImportConfirm =>
      'Restoring replaces all app data (tasks, stars, rewards, photos and recordings). Continue?';

  @override
  String get restore => 'Restore';

  @override
  String get backupDone => 'Backup saved';

  @override
  String get restoreDone => 'Restore complete';

  @override
  String get backupFailed => 'That file couldn\'t be read as a backup';

  @override
  String taskTimeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes left',
      one: '1 minute left',
      zero: 'Time is up',
    );
    return '$_temp0';
  }

  @override
  String get progressRail => 'Routine tasks';

  @override
  String get languageHe => 'עברית';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'English';
}
