// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi rutina';

  @override
  String greetingMorning(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return '¡Buenos días$_temp0!';
  }

  @override
  String greetingNoon(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return '¡Buenas tardes$_temp0!';
  }

  @override
  String greetingEvening(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'empty': '',
      'other': ', $name',
    });
    return '¡Buenas noches$_temp0!';
  }

  @override
  String letsStart(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': '¿Lista? ¡Empecemos!',
      'other': '¿Listo? ¡Empecemos!',
    });
    return '$_temp0';
  }

  @override
  String get routineMorning => 'Mañana';

  @override
  String get routineNoon => 'Mediodía';

  @override
  String get routineEvening => 'Noche';

  @override
  String routineProgress(int done, int total) {
    return '$done de $total';
  }

  @override
  String get routineFinished => '¡Muy bien! ✨';

  @override
  String get doneButton => '¡Hecho!';

  @override
  String get nextUp => 'Después:';

  @override
  String get replayAudio => 'Escuchar otra vez';

  @override
  String get goHome => 'Volver al inicio';

  @override
  String get parentMode => 'Modo padres';

  @override
  String starCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrellas',
      one: 'una estrella',
    );
    return '$_temp0';
  }

  @override
  String celebrationTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': '¡Eres una campeona!',
      'other': '¡Eres un campeón!',
    });
    return '$_temp0';
  }

  @override
  String celebrationRoutineDone(String routine) {
    String _temp0 = intl.Intl.selectLogic(routine, {
      'morning': '¡Terminamos la rutina de la mañana!',
      'noon': '¡Terminamos la rutina del mediodía!',
      'evening': '¡Terminamos la rutina de la noche!',
      'other': '¡Terminamos!',
    });
    return '$_temp0';
  }

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡Ganaste $count estrellas!',
      one: '¡Ganaste una estrella!',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String starsTotal(int count) {
    return 'Tienes $count ⭐';
  }

  @override
  String rewardToGo(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡Faltan $count estrellas para $name!',
      one: '¡Falta una estrella para $name!',
    );
    return '$_temp0';
  }

  @override
  String rewardReady(String name) {
    return '¡Ya tienes estrellas para $name! 🎉';
  }

  @override
  String get holdForParents => 'Mantén pulsado para el modo padres';

  @override
  String get exitParentMode => 'Salir del modo padres';

  @override
  String get gateTitle => 'Solo para padres';

  @override
  String gateQuestion(int a, int b) {
    return '$a × $b = ?';
  }

  @override
  String get gateTryAgain => 'No exactamente. Aquí hay otra pregunta.';

  @override
  String get gateConfirm => 'Aceptar';

  @override
  String get gateBackspace => 'Borrar dígito';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get parentRoutines => 'Rutinas';

  @override
  String get parentTasks => 'Biblioteca de tareas';

  @override
  String get parentRewards => 'Premios';

  @override
  String get parentSummary => 'Resumen del día';

  @override
  String get parentSettings => 'Ajustes';

  @override
  String get routineStartTime => 'Hora de inicio';

  @override
  String get routineDays => 'Días';

  @override
  String dayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'sun': 'D',
      'mon': 'L',
      'tue': 'M',
      'wed': 'X',
      'thu': 'J',
      'fri': 'V',
      'sat': 'S',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get routineReminder => 'Recordatorio';

  @override
  String get routineTasks => 'Tareas';

  @override
  String get routineEmpty => 'Todavía no hay tareas en esta rutina';

  @override
  String get addTask => 'Añadir tarea';

  @override
  String get newTask => 'Tarea nueva';

  @override
  String get removeFromRoutine => 'Quitar de la rutina';

  @override
  String get dragToReorder => 'Arrastra para cambiar el orden';

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
  String get builtIn => 'Incluida';

  @override
  String get taskEditTitle => 'Editar tarea';

  @override
  String get taskNameHe => 'Nombre en hebreo';

  @override
  String get taskNameEs => 'Nombre en español (opcional)';

  @override
  String get taskNameEn => 'Nombre en inglés (opcional)';

  @override
  String get taskNameRequired => 'Hace falta un nombre en hebreo';

  @override
  String get chooseEmoji => 'Emoji';

  @override
  String get takePhoto => 'Cámara';

  @override
  String get choosePhoto => 'Galería';

  @override
  String get removePhoto => 'Quitar la foto';

  @override
  String get taskVoice => 'Grabación';

  @override
  String get recordVoice => 'Grabar';

  @override
  String get stopRecording => 'Detener';

  @override
  String get playRecording => 'Escuchar';

  @override
  String get deleteRecording => 'Borrar la grabación';

  @override
  String recordingNow(int seconds) {
    return 'Grabando… $seconds s';
  }

  @override
  String get noRecordingHint =>
      'Sin grabación, el teléfono leerá el nombre de la tarea';

  @override
  String get micDenied =>
      'No hay permiso para el micrófono. Puedes darlo en los ajustes del teléfono.';

  @override
  String get taskMinutes => 'Tiempo objetivo';

  @override
  String deleteTaskConfirm(String name) {
    return '¿Eliminar la tarea \"$name\"? Se quitará de todas las rutinas.';
  }

  @override
  String get discardChanges => '¿Salir sin guardar?';

  @override
  String get discard => 'Salir sin guardar';

  @override
  String get keepEditing => 'Seguir editando';

  @override
  String get rewardsEmpty =>
      'Todavía no hay premios. Añade uno con el botón de abajo.';

  @override
  String get addReward => 'Añadir premio';

  @override
  String get rewardNew => 'Premio nuevo';

  @override
  String get rewardEdit => 'Editar premio';

  @override
  String get rewardName => 'Nombre del premio';

  @override
  String get rewardNameRequired => 'Hace falta un nombre';

  @override
  String get rewardCost => 'Precio en estrellas';

  @override
  String get redeem => 'Canjear';

  @override
  String redeemConfirmTitle(String name) {
    return '¿Canjear \"$name\"?';
  }

  @override
  String redeemConfirmBody(int cost) {
    return '¡Es el momento de hacerlo juntos! Se restarán $cost estrellas.';
  }

  @override
  String get redeemDone => '¡Canjeado! 🎉';

  @override
  String rewardStarsHave(int have, int cost) {
    return '$have de $cost ⭐';
  }

  @override
  String get redeemedSection => 'Canjeados';

  @override
  String redeemedOn(String date) {
    return 'Canjeado el $date';
  }

  @override
  String get offerAgain => 'Ofrecer otra vez';

  @override
  String deleteRewardConfirm(String name) {
    return '¿Eliminar el premio \"$name\"?';
  }

  @override
  String starBalance(int count) {
    return 'Saldo: $count ⭐';
  }

  @override
  String get today => 'Hoy';

  @override
  String get previousDay => 'Día anterior';

  @override
  String get nextDay => 'Día siguiente';

  @override
  String summaryStars(int count) {
    return 'Estrellas ganadas: $count';
  }

  @override
  String get summaryEmpty => 'No hubo actividad este día';

  @override
  String summaryFinished(String start, String end, String duration) {
    return '$start–$end · $duration';
  }

  @override
  String summaryInProgress(String start, int done, int total) {
    return 'Empezó a las $start · $done de $total';
  }

  @override
  String summaryTaken(String taken, String target) {
    return '$taken (objetivo $target)';
  }

  @override
  String get summaryNotDone => 'Sin marcar';

  @override
  String get lessThanMinute => 'menos de 1 min';

  @override
  String get childName => 'Nombre del niño o la niña';

  @override
  String get childGender => 'Género (para cómo le hablamos)';

  @override
  String get genderFemale => 'Niña';

  @override
  String get genderMale => 'Niño';

  @override
  String get mascotName => 'Nombre de la mascota';

  @override
  String get saved => 'Guardado';

  @override
  String get routineReminderHint =>
      'Aviso a la hora de inicio, los días elegidos';

  @override
  String notificationTitle(String routine) {
    String _temp0 = intl.Intl.selectLogic(routine, {
      'morning': '🌅 ¡Hora de la rutina de la mañana!',
      'noon': '☀️ ¡Hora de la rutina del mediodía!',
      'evening': '🌙 ¡Hora de la rutina de la noche!',
      'other': '¡Hora de la rutina!',
    });
    return '$_temp0';
  }

  @override
  String get reminderChannelName => 'Recordatorios de rutina';

  @override
  String get notificationsDenied =>
      'No hay permiso para notificaciones. Puedes darlo en los ajustes del teléfono.';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get jewishPack => 'Costumbres judías';

  @override
  String get jewishPackHint =>
      'Añade Modé Aní, Netilat Yadáyim, Birjot Hashájar, la bendición antes de comer y el Shemá';

  @override
  String get backupSection => 'Copia de seguridad';

  @override
  String get backupExport => 'Guardar copia en un archivo';

  @override
  String get backupImport => 'Restaurar desde un archivo';

  @override
  String get backupImportConfirm =>
      'Restaurar reemplazará todos los datos de la app (tareas, estrellas, premios, fotos y grabaciones). ¿Continuar?';

  @override
  String get restore => 'Restaurar';

  @override
  String get backupDone => 'Copia guardada';

  @override
  String get restoreDone => 'Restauración completada';

  @override
  String get backupFailed =>
      'No pudimos leer el archivo como copia de seguridad';

  @override
  String taskTimeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count minutos',
      one: 'Queda 1 minuto',
      zero: 'Se acabó el tiempo',
    );
    return '$_temp0';
  }

  @override
  String get progressRail => 'Las tareas de la rutina';

  @override
  String get languageHe => 'עברית';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'English';

  @override
  String get uncheckTask => 'Marcar como no hecha';

  @override
  String uncheckConfirm(String name) {
    return '¿Marcar \"$name\" como no hecha? La estrella ganada se queda.';
  }

  @override
  String get resetRoutine => 'Reiniciar la rutina de hoy';

  @override
  String get resetRoutineConfirm =>
      '¿Empezar la rutina de nuevo hoy? Las estrellas ganadas se quedan.';

  @override
  String get summaryTapHint => 'Toca una tarea hecha para desmarcarla';
}
