import 'package:drift/drift.dart';

import '../../domain/enums.dart';

@DataClassName('Child')
class Children extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get gender => textEnum<Gender>()();
  TextColumn get language => textEnum<AppLanguage>()();
  TextColumn get mascotName => text()();
}

@DataClassName('Routine')
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<RoutineType>().unique()();

  /// Minutes after local midnight (07:00 = 420).
  IntColumn get startMinutes => integer()();

  /// Bit (weekday - 1) per [DateTime.weekday]: Monday = bit 0 ... Sunday = bit 6.
  IntColumn get daysOfWeek => integer().withDefault(const Constant(0x7f))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
}

@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable id for built-in tasks (e.g. `brush_teeth`), so later versions can
  /// find them (Jewish pack placement, translations). Null for custom tasks.
  TextColumn get builtInKey => text().nullable().unique()();
  TextColumn get nameHe => text()();
  TextColumn get nameEs => text().nullable()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get emoji => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get targetMinutes => integer()();
  TextColumn get pack => textEnum<TaskPack>()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
}

@DataClassName('RoutineTask')
class RoutineTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId =>
      integer().references(Routines, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId =>
      integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
}

/// One row per task shown to the child on a given day. Created when the task
/// first appears on screen (its timer starts at [startedAt]) and completed
/// when Done is tapped.
@DataClassName('RunLog')
class RunLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Local calendar day, `yyyy-MM-dd`.
  TextColumn get date => text()();
  IntColumn get routineId =>
      integer().references(Routines, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId =>
      integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {date, routineId, taskId},
  ];
}

@DataClassName('Reward')
class Rewards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get starCost => integer()();
  DateTimeColumn get redeemedAt => dateTime().nullable()();
}

/// Append-only. Balance = sum(delta). Only redemptions are negative.
@DataClassName('StarEntry')
class StarLedger extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Local calendar day, `yyyy-MM-dd`.
  TextColumn get date => text()();
  IntColumn get delta => integer()();
  TextColumn get reason => textEnum<StarReason>()();

  /// RunLog id for [StarReason.taskDone], Reward id for [StarReason.redemption].
  IntColumn get refId => integer().nullable()();
}
