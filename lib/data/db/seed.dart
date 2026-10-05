import '../../domain/enums.dart';

/// A built-in task.
class SeedTask {
  const SeedTask(
    this.key,
    this.emoji,
    this.nameHe,
    this.minutes, {
    this.pack = TaskPack.core,
  });

  final String key;
  final String emoji;
  final String nameHe;
  final int minutes;
  final TaskPack pack;

  String get nameEs => seedNamesEs[key]!;
  String get nameEn => seedNamesEn[key]!;
}

/// Infinitives / nouns, so they work for both genders.
const seedNamesEs = {
  'wake_up': 'Levantarse de la cama',
  'toilet': 'Baño',
  'brush_teeth': 'Cepillarse los dientes',
  'wash_face': 'Lavarse la cara',
  'get_dressed': 'Vestirse',
  'brush_hair': 'Peinarse',
  'breakfast': 'Desayuno',
  'pack_bag': 'Preparar la mochila',
  'shoes': 'Ponerse los zapatos',
  'coat': 'Abrigo',
  'wash_hands': 'Lavarse las manos',
  'lunch': 'Almuerzo',
  'unpack_bag': 'Vaciar la mochila',
  'homework': 'Deberes',
  'tidy_toys': 'Ordenar los juguetes',
  'shower': 'Ducha',
  'pajamas': 'Pijama',
  'clothes_for_tomorrow': 'Preparar la ropa de mañana',
  'bedtime_story': 'Cuento antes de dormir',
  'modeh_ani': 'Modé Aní',
  'netilat_yadayim': 'Netilat Yadáyim',
  'birchot_hashachar': 'Birjot Hashájar',
  'bracha_before_food': 'Bendición antes de comer',
  'shema_bedtime': 'Shemá antes de dormir',
};

const seedNamesEn = {
  'wake_up': 'Get out of bed',
  'toilet': 'Toilet',
  'brush_teeth': 'Brush teeth',
  'wash_face': 'Wash face',
  'get_dressed': 'Get dressed',
  'brush_hair': 'Brush hair',
  'breakfast': 'Breakfast',
  'pack_bag': 'Pack school bag',
  'shoes': 'Put on shoes',
  'coat': 'Coat',
  'wash_hands': 'Wash hands',
  'lunch': 'Lunch',
  'unpack_bag': 'Unpack school bag',
  'homework': 'Homework',
  'tidy_toys': 'Tidy up toys',
  'shower': 'Shower',
  'pajamas': 'Pajamas',
  'clothes_for_tomorrow': "Lay out tomorrow's clothes",
  'bedtime_story': 'Bedtime story',
  'modeh_ani': 'Modeh Ani',
  'netilat_yadayim': 'Netilat Yadayim',
  'birchot_hashachar': 'Birchot Hashachar',
  'bracha_before_food': 'Blessing before food',
  'shema_bedtime': 'Bedtime Shema',
};

/// Names are nouns, so they work for both genders.
const seedTasks = <SeedTask>[
  // Morning
  SeedTask('wake_up', '🌅', 'קימה מהמיטה', 2),
  SeedTask('toilet', '🚽', 'שירותים', 3),
  SeedTask('brush_teeth', '🪥', 'צחצוח שיניים', 3),
  SeedTask('wash_face', '💦', 'שטיפת פנים', 2),
  SeedTask('get_dressed', '👕', 'התלבשות', 7),
  SeedTask('brush_hair', '💇', 'סירוק', 3),
  SeedTask('breakfast', '🥣', 'ארוחת בוקר', 15),
  SeedTask('pack_bag', '🎒', 'הכנת תיק', 3),
  SeedTask('shoes', '👟', 'נעילת נעליים', 3),
  SeedTask('coat', '🧥', 'מעיל', 2),
  // Noon
  SeedTask('wash_hands', '🧼', 'רחיצת ידיים', 2),
  SeedTask('lunch', '🍽️', 'ארוחת צהריים', 20),
  SeedTask('unpack_bag', '🎒', 'פריקת התיק', 3),
  SeedTask('homework', '📚', 'שיעורי בית', 20),
  // Evening (brush_teeth is shared with the morning)
  SeedTask('tidy_toys', '🧸', 'סידור צעצועים', 5),
  SeedTask('shower', '🛁', 'מקלחת', 10),
  SeedTask('pajamas', '🌙', "פיג'מה", 3),
  SeedTask('clothes_for_tomorrow', '👗', 'הכנת בגדים למחר', 5),
  SeedTask('bedtime_story', '📖', 'סיפור לפני השינה', 10),
  // Jewish pack: seeded as tasks, but placed in routines only while the
  // parent has the pack on (see pack_placement.dart).
  SeedTask('modeh_ani', '🙏', 'מודה אני', 1, pack: TaskPack.jewish),
  SeedTask('netilat_yadayim', '💧', 'נטילת ידיים', 2, pack: TaskPack.jewish),
  SeedTask('birchot_hashachar', '📜', 'ברכות השחר', 3, pack: TaskPack.jewish),
  SeedTask(
    'bracha_before_food',
    '🍞',
    'ברכה לפני האוכל',
    1,
    pack: TaskPack.jewish,
  ),
  SeedTask(
    'shema_bedtime',
    '✨',
    'קריאת שמע על המיטה',
    3,
    pack: TaskPack.jewish,
  ),
];

class SeedRoutine {
  const SeedRoutine(this.type, this.startMinutes, this.taskKeys);

  final RoutineType type;
  final int startMinutes;
  final List<String> taskKeys;
}

const seedRoutines = <SeedRoutine>[
  SeedRoutine(RoutineType.morning, 7 * 60, [
    'wake_up', 'toilet', 'brush_teeth', 'wash_face', 'get_dressed', //
    'brush_hair', 'breakfast', 'pack_bag', 'shoes', 'coat',
  ]),
  SeedRoutine(RoutineType.noon, 13 * 60 + 30, [
    'wash_hands',
    'lunch',
    'unpack_bag',
    'homework',
  ]),
  SeedRoutine(RoutineType.evening, 19 * 60, [
    'tidy_toys', 'shower', 'pajamas', 'brush_teeth', //
    'clothes_for_tomorrow', 'bedtime_story',
  ]),
];

const defaultMascotName = 'פומי';
