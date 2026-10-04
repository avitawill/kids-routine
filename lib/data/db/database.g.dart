// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChildrenTable extends Children with TableInfo<$ChildrenTable, Child> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Gender, String> gender =
      GeneratedColumn<String>(
        'gender',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Gender>($ChildrenTable.$convertergender);
  @override
  late final GeneratedColumnWithTypeConverter<AppLanguage, String> language =
      GeneratedColumn<String>(
        'language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AppLanguage>($ChildrenTable.$converterlanguage);
  static const VerificationMeta _mascotNameMeta = const VerificationMeta(
    'mascotName',
  );
  @override
  late final GeneratedColumn<String> mascotName = GeneratedColumn<String>(
    'mascot_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    language,
    mascotName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(
    Insertable<Child> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('mascot_name')) {
      context.handle(
        _mascotNameMeta,
        mascotName.isAcceptableOrUnknown(data['mascot_name']!, _mascotNameMeta),
      );
    } else if (isInserting) {
      context.missing(_mascotNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Child map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Child(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: $ChildrenTable.$convertergender.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}gender'],
        )!,
      ),
      language: $ChildrenTable.$converterlanguage.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}language'],
        )!,
      ),
      mascotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mascot_name'],
      )!,
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Gender, String, String> $convertergender =
      const EnumNameConverter<Gender>(Gender.values);
  static JsonTypeConverter2<AppLanguage, String, String> $converterlanguage =
      const EnumNameConverter<AppLanguage>(AppLanguage.values);
}

class Child extends DataClass implements Insertable<Child> {
  final int id;
  final String name;
  final Gender gender;
  final AppLanguage language;
  final String mascotName;
  const Child({
    required this.id,
    required this.name,
    required this.gender,
    required this.language,
    required this.mascotName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['gender'] = Variable<String>(
        $ChildrenTable.$convertergender.toSql(gender),
      );
    }
    {
      map['language'] = Variable<String>(
        $ChildrenTable.$converterlanguage.toSql(language),
      );
    }
    map['mascot_name'] = Variable<String>(mascotName);
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      language: Value(language),
      mascotName: Value(mascotName),
    );
  }

  factory Child.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Child(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: $ChildrenTable.$convertergender.fromJson(
        serializer.fromJson<String>(json['gender']),
      ),
      language: $ChildrenTable.$converterlanguage.fromJson(
        serializer.fromJson<String>(json['language']),
      ),
      mascotName: serializer.fromJson<String>(json['mascotName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String>(
        $ChildrenTable.$convertergender.toJson(gender),
      ),
      'language': serializer.toJson<String>(
        $ChildrenTable.$converterlanguage.toJson(language),
      ),
      'mascotName': serializer.toJson<String>(mascotName),
    };
  }

  Child copyWith({
    int? id,
    String? name,
    Gender? gender,
    AppLanguage? language,
    String? mascotName,
  }) => Child(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    language: language ?? this.language,
    mascotName: mascotName ?? this.mascotName,
  );
  Child copyWithCompanion(ChildrenCompanion data) {
    return Child(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      language: data.language.present ? data.language.value : this.language,
      mascotName: data.mascotName.present
          ? data.mascotName.value
          : this.mascotName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Child(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('language: $language, ')
          ..write('mascotName: $mascotName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gender, language, mascotName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Child &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.language == this.language &&
          other.mascotName == this.mascotName);
}

class ChildrenCompanion extends UpdateCompanion<Child> {
  final Value<int> id;
  final Value<String> name;
  final Value<Gender> gender;
  final Value<AppLanguage> language;
  final Value<String> mascotName;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.language = const Value.absent(),
    this.mascotName = const Value.absent(),
  });
  ChildrenCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required Gender gender,
    required AppLanguage language,
    required String mascotName,
  }) : gender = Value(gender),
       language = Value(language),
       mascotName = Value(mascotName);
  static Insertable<Child> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<String>? language,
    Expression<String>? mascotName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (language != null) 'language': language,
      if (mascotName != null) 'mascot_name': mascotName,
    });
  }

  ChildrenCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<Gender>? gender,
    Value<AppLanguage>? language,
    Value<String>? mascotName,
  }) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      mascotName: mascotName ?? this.mascotName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(
        $ChildrenTable.$convertergender.toSql(gender.value),
      );
    }
    if (language.present) {
      map['language'] = Variable<String>(
        $ChildrenTable.$converterlanguage.toSql(language.value),
      );
    }
    if (mascotName.present) {
      map['mascot_name'] = Variable<String>(mascotName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('language: $language, ')
          ..write('mascotName: $mascotName')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoutineType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      ).withConverter<RoutineType>($RoutinesTable.$convertertype);
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<int> daysOfWeek = GeneratedColumn<int>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0x7f),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    startMinutes,
    daysOfWeek,
    reminderEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $RoutinesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_of_week'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoutineType, String, String> $convertertype =
      const EnumNameConverter<RoutineType>(RoutineType.values);
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final RoutineType type;

  /// Minutes after local midnight (07:00 = 420).
  final int startMinutes;

  /// Bit (weekday - 1) per [DateTime.weekday]: Monday = bit 0 ... Sunday = bit 6.
  final int daysOfWeek;
  final bool reminderEnabled;
  const Routine({
    required this.id,
    required this.type,
    required this.startMinutes,
    required this.daysOfWeek,
    required this.reminderEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>($RoutinesTable.$convertertype.toSql(type));
    }
    map['start_minutes'] = Variable<int>(startMinutes);
    map['days_of_week'] = Variable<int>(daysOfWeek);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      type: Value(type),
      startMinutes: Value(startMinutes),
      daysOfWeek: Value(daysOfWeek),
      reminderEnabled: Value(reminderEnabled),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      type: $RoutinesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      daysOfWeek: serializer.fromJson<int>(json['daysOfWeek']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $RoutinesTable.$convertertype.toJson(type),
      ),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'daysOfWeek': serializer.toJson<int>(daysOfWeek),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
    };
  }

  Routine copyWith({
    int? id,
    RoutineType? type,
    int? startMinutes,
    int? daysOfWeek,
    bool? reminderEnabled,
  }) => Routine(
    id: id ?? this.id,
    type: type ?? this.type,
    startMinutes: startMinutes ?? this.startMinutes,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('reminderEnabled: $reminderEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, startMinutes, daysOfWeek, reminderEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.type == this.type &&
          other.startMinutes == this.startMinutes &&
          other.daysOfWeek == this.daysOfWeek &&
          other.reminderEnabled == this.reminderEnabled);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<RoutineType> type;
  final Value<int> startMinutes;
  final Value<int> daysOfWeek;
  final Value<bool> reminderEnabled;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required RoutineType type,
    required int startMinutes,
    this.daysOfWeek = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
  }) : type = Value(type),
       startMinutes = Value(startMinutes);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? startMinutes,
    Expression<int>? daysOfWeek,
    Expression<bool>? reminderEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<RoutineType>? type,
    Value<int>? startMinutes,
    Value<int>? daysOfWeek,
    Value<bool>? reminderEnabled,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      startMinutes: startMinutes ?? this.startMinutes,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $RoutinesTable.$convertertype.toSql(type.value),
      );
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<int>(daysOfWeek.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('reminderEnabled: $reminderEnabled')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _builtInKeyMeta = const VerificationMeta(
    'builtInKey',
  );
  @override
  late final GeneratedColumn<String> builtInKey = GeneratedColumn<String>(
    'built_in_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameHeMeta = const VerificationMeta('nameHe');
  @override
  late final GeneratedColumn<String> nameHe = GeneratedColumn<String>(
    'name_he',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEsMeta = const VerificationMeta('nameEs');
  @override
  late final GeneratedColumn<String> nameEs = GeneratedColumn<String>(
    'name_es',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskPack, String> pack =
      GeneratedColumn<String>(
        'pack',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskPack>($TasksTable.$converterpack);
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    builtInKey,
    nameHe,
    nameEs,
    nameEn,
    emoji,
    photoPath,
    audioPath,
    targetMinutes,
    pack,
    isBuiltIn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('built_in_key')) {
      context.handle(
        _builtInKeyMeta,
        builtInKey.isAcceptableOrUnknown(
          data['built_in_key']!,
          _builtInKeyMeta,
        ),
      );
    }
    if (data.containsKey('name_he')) {
      context.handle(
        _nameHeMeta,
        nameHe.isAcceptableOrUnknown(data['name_he']!, _nameHeMeta),
      );
    } else if (isInserting) {
      context.missing(_nameHeMeta);
    }
    if (data.containsKey('name_es')) {
      context.handle(
        _nameEsMeta,
        nameEs.isAcceptableOrUnknown(data['name_es']!, _nameEsMeta),
      );
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMinutesMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      builtInKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}built_in_key'],
      ),
      nameHe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_he'],
      )!,
      nameEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_es'],
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      )!,
      pack: $TasksTable.$converterpack.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pack'],
        )!,
      ),
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskPack, String, String> $converterpack =
      const EnumNameConverter<TaskPack>(TaskPack.values);
}

class Task extends DataClass implements Insertable<Task> {
  final int id;

  /// Stable id for built-in tasks (e.g. `brush_teeth`), so later versions can
  /// find them (Jewish pack placement, translations). Null for custom tasks.
  final String? builtInKey;
  final String nameHe;
  final String? nameEs;
  final String? nameEn;
  final String? emoji;
  final String? photoPath;
  final String? audioPath;
  final int targetMinutes;
  final TaskPack pack;
  final bool isBuiltIn;
  const Task({
    required this.id,
    this.builtInKey,
    required this.nameHe,
    this.nameEs,
    this.nameEn,
    this.emoji,
    this.photoPath,
    this.audioPath,
    required this.targetMinutes,
    required this.pack,
    required this.isBuiltIn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || builtInKey != null) {
      map['built_in_key'] = Variable<String>(builtInKey);
    }
    map['name_he'] = Variable<String>(nameHe);
    if (!nullToAbsent || nameEs != null) {
      map['name_es'] = Variable<String>(nameEs);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['target_minutes'] = Variable<int>(targetMinutes);
    {
      map['pack'] = Variable<String>($TasksTable.$converterpack.toSql(pack));
    }
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      builtInKey: builtInKey == null && nullToAbsent
          ? const Value.absent()
          : Value(builtInKey),
      nameHe: Value(nameHe),
      nameEs: nameEs == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEs),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      targetMinutes: Value(targetMinutes),
      pack: Value(pack),
      isBuiltIn: Value(isBuiltIn),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      builtInKey: serializer.fromJson<String?>(json['builtInKey']),
      nameHe: serializer.fromJson<String>(json['nameHe']),
      nameEs: serializer.fromJson<String?>(json['nameEs']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      targetMinutes: serializer.fromJson<int>(json['targetMinutes']),
      pack: $TasksTable.$converterpack.fromJson(
        serializer.fromJson<String>(json['pack']),
      ),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'builtInKey': serializer.toJson<String?>(builtInKey),
      'nameHe': serializer.toJson<String>(nameHe),
      'nameEs': serializer.toJson<String?>(nameEs),
      'nameEn': serializer.toJson<String?>(nameEn),
      'emoji': serializer.toJson<String?>(emoji),
      'photoPath': serializer.toJson<String?>(photoPath),
      'audioPath': serializer.toJson<String?>(audioPath),
      'targetMinutes': serializer.toJson<int>(targetMinutes),
      'pack': serializer.toJson<String>(
        $TasksTable.$converterpack.toJson(pack),
      ),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
    };
  }

  Task copyWith({
    int? id,
    Value<String?> builtInKey = const Value.absent(),
    String? nameHe,
    Value<String?> nameEs = const Value.absent(),
    Value<String?> nameEn = const Value.absent(),
    Value<String?> emoji = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    int? targetMinutes,
    TaskPack? pack,
    bool? isBuiltIn,
  }) => Task(
    id: id ?? this.id,
    builtInKey: builtInKey.present ? builtInKey.value : this.builtInKey,
    nameHe: nameHe ?? this.nameHe,
    nameEs: nameEs.present ? nameEs.value : this.nameEs,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    emoji: emoji.present ? emoji.value : this.emoji,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    targetMinutes: targetMinutes ?? this.targetMinutes,
    pack: pack ?? this.pack,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      builtInKey: data.builtInKey.present
          ? data.builtInKey.value
          : this.builtInKey,
      nameHe: data.nameHe.present ? data.nameHe.value : this.nameHe,
      nameEs: data.nameEs.present ? data.nameEs.value : this.nameEs,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      pack: data.pack.present ? data.pack.value : this.pack,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('builtInKey: $builtInKey, ')
          ..write('nameHe: $nameHe, ')
          ..write('nameEs: $nameEs, ')
          ..write('nameEn: $nameEn, ')
          ..write('emoji: $emoji, ')
          ..write('photoPath: $photoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('pack: $pack, ')
          ..write('isBuiltIn: $isBuiltIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    builtInKey,
    nameHe,
    nameEs,
    nameEn,
    emoji,
    photoPath,
    audioPath,
    targetMinutes,
    pack,
    isBuiltIn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.builtInKey == this.builtInKey &&
          other.nameHe == this.nameHe &&
          other.nameEs == this.nameEs &&
          other.nameEn == this.nameEn &&
          other.emoji == this.emoji &&
          other.photoPath == this.photoPath &&
          other.audioPath == this.audioPath &&
          other.targetMinutes == this.targetMinutes &&
          other.pack == this.pack &&
          other.isBuiltIn == this.isBuiltIn);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String?> builtInKey;
  final Value<String> nameHe;
  final Value<String?> nameEs;
  final Value<String?> nameEn;
  final Value<String?> emoji;
  final Value<String?> photoPath;
  final Value<String?> audioPath;
  final Value<int> targetMinutes;
  final Value<TaskPack> pack;
  final Value<bool> isBuiltIn;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.builtInKey = const Value.absent(),
    this.nameHe = const Value.absent(),
    this.nameEs = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.pack = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.builtInKey = const Value.absent(),
    required String nameHe,
    this.nameEs = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    required int targetMinutes,
    required TaskPack pack,
    this.isBuiltIn = const Value.absent(),
  }) : nameHe = Value(nameHe),
       targetMinutes = Value(targetMinutes),
       pack = Value(pack);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? builtInKey,
    Expression<String>? nameHe,
    Expression<String>? nameEs,
    Expression<String>? nameEn,
    Expression<String>? emoji,
    Expression<String>? photoPath,
    Expression<String>? audioPath,
    Expression<int>? targetMinutes,
    Expression<String>? pack,
    Expression<bool>? isBuiltIn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (builtInKey != null) 'built_in_key': builtInKey,
      if (nameHe != null) 'name_he': nameHe,
      if (nameEs != null) 'name_es': nameEs,
      if (nameEn != null) 'name_en': nameEn,
      if (emoji != null) 'emoji': emoji,
      if (photoPath != null) 'photo_path': photoPath,
      if (audioPath != null) 'audio_path': audioPath,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (pack != null) 'pack': pack,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String?>? builtInKey,
    Value<String>? nameHe,
    Value<String?>? nameEs,
    Value<String?>? nameEn,
    Value<String?>? emoji,
    Value<String?>? photoPath,
    Value<String?>? audioPath,
    Value<int>? targetMinutes,
    Value<TaskPack>? pack,
    Value<bool>? isBuiltIn,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      builtInKey: builtInKey ?? this.builtInKey,
      nameHe: nameHe ?? this.nameHe,
      nameEs: nameEs ?? this.nameEs,
      nameEn: nameEn ?? this.nameEn,
      emoji: emoji ?? this.emoji,
      photoPath: photoPath ?? this.photoPath,
      audioPath: audioPath ?? this.audioPath,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      pack: pack ?? this.pack,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (builtInKey.present) {
      map['built_in_key'] = Variable<String>(builtInKey.value);
    }
    if (nameHe.present) {
      map['name_he'] = Variable<String>(nameHe.value);
    }
    if (nameEs.present) {
      map['name_es'] = Variable<String>(nameEs.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (pack.present) {
      map['pack'] = Variable<String>(
        $TasksTable.$converterpack.toSql(pack.value),
      );
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('builtInKey: $builtInKey, ')
          ..write('nameHe: $nameHe, ')
          ..write('nameEs: $nameEs, ')
          ..write('nameEn: $nameEn, ')
          ..write('emoji: $emoji, ')
          ..write('photoPath: $photoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('pack: $pack, ')
          ..write('isBuiltIn: $isBuiltIn')
          ..write(')'))
        .toString();
  }
}

class $RoutineTasksTable extends RoutineTasks
    with TableInfo<$RoutineTasksTable, RoutineTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, routineId, taskId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $RoutineTasksTable createAlias(String alias) {
    return $RoutineTasksTable(attachedDatabase, alias);
  }
}

class RoutineTask extends DataClass implements Insertable<RoutineTask> {
  final int id;
  final int routineId;
  final int taskId;
  final int position;
  const RoutineTask({
    required this.id,
    required this.routineId,
    required this.taskId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['task_id'] = Variable<int>(taskId);
    map['position'] = Variable<int>(position);
    return map;
  }

  RoutineTasksCompanion toCompanion(bool nullToAbsent) {
    return RoutineTasksCompanion(
      id: Value(id),
      routineId: Value(routineId),
      taskId: Value(taskId),
      position: Value(position),
    );
  }

  factory RoutineTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineTask(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      taskId: serializer.fromJson<int>(json['taskId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'taskId': serializer.toJson<int>(taskId),
      'position': serializer.toJson<int>(position),
    };
  }

  RoutineTask copyWith({int? id, int? routineId, int? taskId, int? position}) =>
      RoutineTask(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        taskId: taskId ?? this.taskId,
        position: position ?? this.position,
      );
  RoutineTask copyWithCompanion(RoutineTasksCompanion data) {
    return RoutineTask(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTask(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('taskId: $taskId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, taskId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineTask &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.taskId == this.taskId &&
          other.position == this.position);
}

class RoutineTasksCompanion extends UpdateCompanion<RoutineTask> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<int> taskId;
  final Value<int> position;
  const RoutineTasksCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.position = const Value.absent(),
  });
  RoutineTasksCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required int taskId,
    required int position,
  }) : routineId = Value(routineId),
       taskId = Value(taskId),
       position = Value(position);
  static Insertable<RoutineTask> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<int>? taskId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (taskId != null) 'task_id': taskId,
      if (position != null) 'position': position,
    });
  }

  RoutineTasksCompanion copyWith({
    Value<int>? id,
    Value<int>? routineId,
    Value<int>? taskId,
    Value<int>? position,
  }) {
    return RoutineTasksCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      taskId: taskId ?? this.taskId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTasksCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('taskId: $taskId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $RunLogsTable extends RunLogs with TableInfo<$RunLogsTable, RunLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    routineId,
    taskId,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'run_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RunLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, routineId, taskId},
  ];
  @override
  RunLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RunLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $RunLogsTable createAlias(String alias) {
    return $RunLogsTable(attachedDatabase, alias);
  }
}

class RunLog extends DataClass implements Insertable<RunLog> {
  final int id;

  /// Local calendar day, `yyyy-MM-dd`.
  final String date;
  final int routineId;
  final int taskId;
  final DateTime startedAt;
  final DateTime? completedAt;
  const RunLog({
    required this.id,
    required this.date,
    required this.routineId,
    required this.taskId,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['routine_id'] = Variable<int>(routineId);
    map['task_id'] = Variable<int>(taskId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  RunLogsCompanion toCompanion(bool nullToAbsent) {
    return RunLogsCompanion(
      id: Value(id),
      date: Value(date),
      routineId: Value(routineId),
      taskId: Value(taskId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory RunLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RunLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      routineId: serializer.fromJson<int>(json['routineId']),
      taskId: serializer.fromJson<int>(json['taskId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'routineId': serializer.toJson<int>(routineId),
      'taskId': serializer.toJson<int>(taskId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  RunLog copyWith({
    int? id,
    String? date,
    int? routineId,
    int? taskId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => RunLog(
    id: id ?? this.id,
    date: date ?? this.date,
    routineId: routineId ?? this.routineId,
    taskId: taskId ?? this.taskId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  RunLog copyWithCompanion(RunLogsCompanion data) {
    return RunLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RunLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('routineId: $routineId, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, routineId, taskId, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.routineId == this.routineId &&
          other.taskId == this.taskId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class RunLogsCompanion extends UpdateCompanion<RunLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> routineId;
  final Value<int> taskId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  const RunLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.routineId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  RunLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int routineId,
    required int taskId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
  }) : date = Value(date),
       routineId = Value(routineId),
       taskId = Value(taskId),
       startedAt = Value(startedAt);
  static Insertable<RunLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? routineId,
    Expression<int>? taskId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (routineId != null) 'routine_id': routineId,
      if (taskId != null) 'task_id': taskId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  RunLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? routineId,
    Value<int>? taskId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
  }) {
    return RunLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      routineId: routineId ?? this.routineId,
      taskId: taskId ?? this.taskId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('routineId: $routineId, ')
          ..write('taskId: $taskId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $RewardsTable extends Rewards with TableInfo<$RewardsTable, Reward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _starCostMeta = const VerificationMeta(
    'starCost',
  );
  @override
  late final GeneratedColumn<int> starCost = GeneratedColumn<int>(
    'star_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _redeemedAtMeta = const VerificationMeta(
    'redeemedAt',
  );
  @override
  late final GeneratedColumn<DateTime> redeemedAt = GeneratedColumn<DateTime>(
    'redeemed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    photoPath,
    starCost,
    redeemedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('star_cost')) {
      context.handle(
        _starCostMeta,
        starCost.isAcceptableOrUnknown(data['star_cost']!, _starCostMeta),
      );
    } else if (isInserting) {
      context.missing(_starCostMeta);
    }
    if (data.containsKey('redeemed_at')) {
      context.handle(
        _redeemedAtMeta,
        redeemedAt.isAcceptableOrUnknown(data['redeemed_at']!, _redeemedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reward(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      starCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}star_cost'],
      )!,
      redeemedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}redeemed_at'],
      ),
    );
  }

  @override
  $RewardsTable createAlias(String alias) {
    return $RewardsTable(attachedDatabase, alias);
  }
}

class Reward extends DataClass implements Insertable<Reward> {
  final int id;
  final String name;
  final String? photoPath;
  final int starCost;
  final DateTime? redeemedAt;
  const Reward({
    required this.id,
    required this.name,
    this.photoPath,
    required this.starCost,
    this.redeemedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['star_cost'] = Variable<int>(starCost);
    if (!nullToAbsent || redeemedAt != null) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt);
    }
    return map;
  }

  RewardsCompanion toCompanion(bool nullToAbsent) {
    return RewardsCompanion(
      id: Value(id),
      name: Value(name),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      starCost: Value(starCost),
      redeemedAt: redeemedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(redeemedAt),
    );
  }

  factory Reward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reward(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      starCost: serializer.fromJson<int>(json['starCost']),
      redeemedAt: serializer.fromJson<DateTime?>(json['redeemedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'photoPath': serializer.toJson<String?>(photoPath),
      'starCost': serializer.toJson<int>(starCost),
      'redeemedAt': serializer.toJson<DateTime?>(redeemedAt),
    };
  }

  Reward copyWith({
    int? id,
    String? name,
    Value<String?> photoPath = const Value.absent(),
    int? starCost,
    Value<DateTime?> redeemedAt = const Value.absent(),
  }) => Reward(
    id: id ?? this.id,
    name: name ?? this.name,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    starCost: starCost ?? this.starCost,
    redeemedAt: redeemedAt.present ? redeemedAt.value : this.redeemedAt,
  );
  Reward copyWithCompanion(RewardsCompanion data) {
    return Reward(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      starCost: data.starCost.present ? data.starCost.value : this.starCost,
      redeemedAt: data.redeemedAt.present
          ? data.redeemedAt.value
          : this.redeemedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reward(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('starCost: $starCost, ')
          ..write('redeemedAt: $redeemedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, photoPath, starCost, redeemedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reward &&
          other.id == this.id &&
          other.name == this.name &&
          other.photoPath == this.photoPath &&
          other.starCost == this.starCost &&
          other.redeemedAt == this.redeemedAt);
}

class RewardsCompanion extends UpdateCompanion<Reward> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> photoPath;
  final Value<int> starCost;
  final Value<DateTime?> redeemedAt;
  const RewardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.starCost = const Value.absent(),
    this.redeemedAt = const Value.absent(),
  });
  RewardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.photoPath = const Value.absent(),
    required int starCost,
    this.redeemedAt = const Value.absent(),
  }) : name = Value(name),
       starCost = Value(starCost);
  static Insertable<Reward> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? photoPath,
    Expression<int>? starCost,
    Expression<DateTime>? redeemedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (photoPath != null) 'photo_path': photoPath,
      if (starCost != null) 'star_cost': starCost,
      if (redeemedAt != null) 'redeemed_at': redeemedAt,
    });
  }

  RewardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? photoPath,
    Value<int>? starCost,
    Value<DateTime?>? redeemedAt,
  }) {
    return RewardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      starCost: starCost ?? this.starCost,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (starCost.present) {
      map['star_cost'] = Variable<int>(starCost.value);
    }
    if (redeemedAt.present) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('starCost: $starCost, ')
          ..write('redeemedAt: $redeemedAt')
          ..write(')'))
        .toString();
  }
}

class $StarLedgerTable extends StarLedger
    with TableInfo<$StarLedgerTable, StarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StarLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StarReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StarReason>($StarLedgerTable.$converterreason);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<int> refId = GeneratedColumn<int>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, delta, reason, refId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'star_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<StarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      reason: $StarLedgerTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ref_id'],
      ),
    );
  }

  @override
  $StarLedgerTable createAlias(String alias) {
    return $StarLedgerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StarReason, String, String> $converterreason =
      const EnumNameConverter<StarReason>(StarReason.values);
}

class StarEntry extends DataClass implements Insertable<StarEntry> {
  final int id;

  /// Local calendar day, `yyyy-MM-dd`.
  final String date;
  final int delta;
  final StarReason reason;

  /// RunLog id for [StarReason.taskDone], Reward id for [StarReason.redemption].
  final int? refId;
  const StarEntry({
    required this.id,
    required this.date,
    required this.delta,
    required this.reason,
    this.refId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['delta'] = Variable<int>(delta);
    {
      map['reason'] = Variable<String>(
        $StarLedgerTable.$converterreason.toSql(reason),
      );
    }
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<int>(refId);
    }
    return map;
  }

  StarLedgerCompanion toCompanion(bool nullToAbsent) {
    return StarLedgerCompanion(
      id: Value(id),
      date: Value(date),
      delta: Value(delta),
      reason: Value(reason),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
    );
  }

  factory StarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StarEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      delta: serializer.fromJson<int>(json['delta']),
      reason: $StarLedgerTable.$converterreason.fromJson(
        serializer.fromJson<String>(json['reason']),
      ),
      refId: serializer.fromJson<int?>(json['refId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'delta': serializer.toJson<int>(delta),
      'reason': serializer.toJson<String>(
        $StarLedgerTable.$converterreason.toJson(reason),
      ),
      'refId': serializer.toJson<int?>(refId),
    };
  }

  StarEntry copyWith({
    int? id,
    String? date,
    int? delta,
    StarReason? reason,
    Value<int?> refId = const Value.absent(),
  }) => StarEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    delta: delta ?? this.delta,
    reason: reason ?? this.reason,
    refId: refId.present ? refId.value : this.refId,
  );
  StarEntry copyWithCompanion(StarLedgerCompanion data) {
    return StarEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      delta: data.delta.present ? data.delta.value : this.delta,
      reason: data.reason.present ? data.reason.value : this.reason,
      refId: data.refId.present ? data.refId.value : this.refId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StarEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, delta, reason, refId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StarEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.delta == this.delta &&
          other.reason == this.reason &&
          other.refId == this.refId);
}

class StarLedgerCompanion extends UpdateCompanion<StarEntry> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> delta;
  final Value<StarReason> reason;
  final Value<int?> refId;
  const StarLedgerCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.delta = const Value.absent(),
    this.reason = const Value.absent(),
    this.refId = const Value.absent(),
  });
  StarLedgerCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int delta,
    required StarReason reason,
    this.refId = const Value.absent(),
  }) : date = Value(date),
       delta = Value(delta),
       reason = Value(reason);
  static Insertable<StarEntry> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? delta,
    Expression<String>? reason,
    Expression<int>? refId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (delta != null) 'delta': delta,
      if (reason != null) 'reason': reason,
      if (refId != null) 'ref_id': refId,
    });
  }

  StarLedgerCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? delta,
    Value<StarReason>? reason,
    Value<int?>? refId,
  }) {
    return StarLedgerCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      delta: delta ?? this.delta,
      reason: reason ?? this.reason,
      refId: refId ?? this.refId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $StarLedgerTable.$converterreason.toSql(reason.value),
      );
    }
    if (refId.present) {
      map['ref_id'] = Variable<int>(refId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StarLedgerCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $RoutineTasksTable routineTasks = $RoutineTasksTable(this);
  late final $RunLogsTable runLogs = $RunLogsTable(this);
  late final $RewardsTable rewards = $RewardsTable(this);
  late final $StarLedgerTable starLedger = $StarLedgerTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    children,
    routines,
    tasks,
    routineTasks,
    runLogs,
    rewards,
    starLedger,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('run_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('run_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ChildrenTableCreateCompanionBuilder = ChildrenCompanion Function({
  Value<int> id,
  Value<String> name,
  required Gender gender,
  required AppLanguage language,
  required String mascotName,
});
typedef $$ChildrenTableUpdateCompanionBuilder = ChildrenCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<Gender> gender,
  Value<AppLanguage> language,
  Value<String> mascotName,
});

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Gender, Gender, String> get gender =>
      $composableBuilder(
        column: $table.gender,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<AppLanguage, AppLanguage, String>
  get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mascotName => $composableBuilder(
    column: $table.mascotName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mascotName => $composableBuilder(
    column: $table.mascotName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Gender, String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppLanguage, String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get mascotName => $composableBuilder(
    column: $table.mascotName,
    builder: (column) => column,
  );
}

class $$ChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildrenTable,
          Child,
          $$ChildrenTableFilterComposer,
          $$ChildrenTableOrderingComposer,
          $$ChildrenTableAnnotationComposer,
          $$ChildrenTableCreateCompanionBuilder,
          $$ChildrenTableUpdateCompanionBuilder,
          (Child, BaseReferences<_$AppDatabase, $ChildrenTable, Child>),
          Child,
          PrefetchHooks Function()
        > {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Gender> gender = const Value.absent(),
                Value<AppLanguage> language = const Value.absent(),
                Value<String> mascotName = const Value.absent(),
              }) => ChildrenCompanion(
                id: id,
                name: name,
                gender: gender,
                language: language,
                mascotName: mascotName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                required Gender gender,
                required AppLanguage language,
                required String mascotName,
              }) => ChildrenCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                language: language,
                mascotName: mascotName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChildrenTable, Child>(table),
                  BaseReferences<_$AppDatabase, $ChildrenTable, Child>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildrenTable,
      Child,
      $$ChildrenTableFilterComposer,
      $$ChildrenTableOrderingComposer,
      $$ChildrenTableAnnotationComposer,
      $$ChildrenTableCreateCompanionBuilder,
      $$ChildrenTableUpdateCompanionBuilder,
      (Child, BaseReferences<_$AppDatabase, $ChildrenTable, Child>),
      Child,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required RoutineType type,
  required int startMinutes,
  Value<int> daysOfWeek,
  Value<bool> reminderEnabled,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<RoutineType> type,
  Value<int> startMinutes,
  Value<int> daysOfWeek,
  Value<bool> reminderEnabled,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineTasksTable, List<RoutineTask>>
  _routineTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineTasks,
    aliasName: 'routines__id__routine_tasks__routine_id',
  );

  $$RoutineTasksTableProcessedTableManager get routineTasksRefs {
    final manager = $$RoutineTasksTableTableManager(
      $_db,
      $_db.routineTasks,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RunLogsTable, List<RunLog>> _runLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.runLogs,
    aliasName: 'routines__id__run_logs__routine_id',
  );

  $$RunLogsTableProcessedTableManager get runLogsRefs {
    final manager = $$RunLogsTableTableManager(
      $_db,
      $_db.runLogs,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_runLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoutineType, RoutineType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineTasksRefs(
    Expression<bool> Function($$RoutineTasksTableFilterComposer f) f,
  ) {
    final $$RoutineTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineTasks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineTasksTableFilterComposer(
            $db: $db,
            $table: $db.routineTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> runLogsRefs(
    Expression<bool> Function($$RunLogsTableFilterComposer f) f,
  ) {
    final $$RunLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runLogs,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunLogsTableFilterComposer(
            $db: $db,
            $table: $db.runLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoutineType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  Expression<T> routineTasksRefs<T extends Object>(
    Expression<T> Function($$RoutineTasksTableAnnotationComposer a) f,
  ) {
    final $$RoutineTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineTasks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.routineTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> runLogsRefs<T extends Object>(
    Expression<T> Function($$RunLogsTableAnnotationComposer a) f,
  ) {
    final $$RunLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runLogs,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.runLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({bool routineTasksRefs, bool runLogsRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<RoutineType> type = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> daysOfWeek = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                type: type,
                startMinutes: startMinutes,
                daysOfWeek: daysOfWeek,
                reminderEnabled: reminderEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required RoutineType type,
                required int startMinutes,
                Value<int> daysOfWeek = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                type: type,
                startMinutes: startMinutes,
                daysOfWeek: daysOfWeek,
                reminderEnabled: reminderEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, Routine>(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineTasksRefs = false, runLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineTasksRefs) db.routineTasks,
                    if (runLogsRefs) db.runLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineTasksRefs)
                        await $_getPrefetchedData<
                          Routine,
                          $RoutinesTable,
                          RoutineTask
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._routineTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (runLogsRefs)
                        await $_getPrefetchedData<
                          Routine,
                          $RoutinesTable,
                          RunLog
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._runLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).runLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({bool routineTasksRefs, bool runLogsRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String?> builtInKey,
  required String nameHe,
  Value<String?> nameEs,
  Value<String?> nameEn,
  Value<String?> emoji,
  Value<String?> photoPath,
  Value<String?> audioPath,
  required int targetMinutes,
  required TaskPack pack,
  Value<bool> isBuiltIn,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String?> builtInKey,
  Value<String> nameHe,
  Value<String?> nameEs,
  Value<String?> nameEn,
  Value<String?> emoji,
  Value<String?> photoPath,
  Value<String?> audioPath,
  Value<int> targetMinutes,
  Value<TaskPack> pack,
  Value<bool> isBuiltIn,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineTasksTable, List<RoutineTask>>
  _routineTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineTasks,
    aliasName: 'tasks__id__routine_tasks__task_id',
  );

  $$RoutineTasksTableProcessedTableManager get routineTasksRefs {
    final manager = $$RoutineTasksTableTableManager(
      $_db,
      $_db.routineTasks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RunLogsTable, List<RunLog>> _runLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.runLogs,
    aliasName: 'tasks__id__run_logs__task_id',
  );

  $$RunLogsTableProcessedTableManager get runLogsRefs {
    final manager = $$RunLogsTableTableManager(
      $_db,
      $_db.runLogs,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_runLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameHe => $composableBuilder(
    column: $table.nameHe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskPack, TaskPack, String> get pack =>
      $composableBuilder(
        column: $table.pack,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineTasksRefs(
    Expression<bool> Function($$RoutineTasksTableFilterComposer f) f,
  ) {
    final $$RoutineTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineTasksTableFilterComposer(
            $db: $db,
            $table: $db.routineTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> runLogsRefs(
    Expression<bool> Function($$RunLogsTableFilterComposer f) f,
  ) {
    final $$RunLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runLogs,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunLogsTableFilterComposer(
            $db: $db,
            $table: $db.runLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameHe => $composableBuilder(
    column: $table.nameHe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pack => $composableBuilder(
    column: $table.pack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameHe =>
      $composableBuilder(column: $table.nameHe, builder: (column) => column);

  GeneratedColumn<String> get nameEs =>
      $composableBuilder(column: $table.nameEs, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskPack, String> get pack =>
      $composableBuilder(column: $table.pack, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  Expression<T> routineTasksRefs<T extends Object>(
    Expression<T> Function($$RoutineTasksTableAnnotationComposer a) f,
  ) {
    final $$RoutineTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.routineTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> runLogsRefs<T extends Object>(
    Expression<T> Function($$RunLogsTableAnnotationComposer a) f,
  ) {
    final $$RunLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runLogs,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.runLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool routineTasksRefs, bool runLogsRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> builtInKey = const Value.absent(),
                Value<String> nameHe = const Value.absent(),
                Value<String?> nameEs = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int> targetMinutes = const Value.absent(),
                Value<TaskPack> pack = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                builtInKey: builtInKey,
                nameHe: nameHe,
                nameEs: nameEs,
                nameEn: nameEn,
                emoji: emoji,
                photoPath: photoPath,
                audioPath: audioPath,
                targetMinutes: targetMinutes,
                pack: pack,
                isBuiltIn: isBuiltIn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> builtInKey = const Value.absent(),
                required String nameHe,
                Value<String?> nameEs = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                required int targetMinutes,
                required TaskPack pack,
                Value<bool> isBuiltIn = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                builtInKey: builtInKey,
                nameHe: nameHe,
                nameEs: nameEs,
                nameEn: nameEn,
                emoji: emoji,
                photoPath: photoPath,
                audioPath: audioPath,
                targetMinutes: targetMinutes,
                pack: pack,
                isBuiltIn: isBuiltIn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineTasksRefs = false, runLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineTasksRefs) db.routineTasks,
                    if (runLogsRefs) db.runLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineTasksRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          RoutineTask
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._routineTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).routineTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (runLogsRefs)
                        await $_getPrefetchedData<Task, $TasksTable, RunLog>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._runLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(db, table, p0).runLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool routineTasksRefs, bool runLogsRefs})
    >;
typedef $$RoutineTasksTableCreateCompanionBuilder =
    RoutineTasksCompanion Function({
      Value<int> id,
      required int routineId,
      required int taskId,
      required int position,
    });
typedef $$RoutineTasksTableUpdateCompanionBuilder =
    RoutineTasksCompanion Function({
      Value<int> id,
      Value<int> routineId,
      Value<int> taskId,
      Value<int> position,
    });

final class $$RoutineTasksTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineTasksTable, RoutineTask> {
  $$RoutineTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_tasks__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('routine_tasks__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineTasksTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineTasksTable> {
  $$RoutineTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineTasksTable> {
  $$RoutineTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineTasksTable> {
  $$RoutineTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineTasksTable,
          RoutineTask,
          $$RoutineTasksTableFilterComposer,
          $$RoutineTasksTableOrderingComposer,
          $$RoutineTasksTableAnnotationComposer,
          $$RoutineTasksTableCreateCompanionBuilder,
          $$RoutineTasksTableUpdateCompanionBuilder,
          (RoutineTask, $$RoutineTasksTableReferences),
          RoutineTask,
          PrefetchHooks Function({bool routineId, bool taskId})
        > {
  $$RoutineTasksTableTableManager(_$AppDatabase db, $RoutineTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RoutineTasksCompanion(
                id: id,
                routineId: routineId,
                taskId: taskId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineId,
                required int taskId,
                required int position,
              }) => RoutineTasksCompanion.insert(
                id: id,
                routineId: routineId,
                taskId: taskId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineTasksTable, RoutineTask>(table),
                  $$RoutineTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$RoutineTasksTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$RoutineTasksTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$RoutineTasksTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$RoutineTasksTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineTasksTable,
      RoutineTask,
      $$RoutineTasksTableFilterComposer,
      $$RoutineTasksTableOrderingComposer,
      $$RoutineTasksTableAnnotationComposer,
      $$RoutineTasksTableCreateCompanionBuilder,
      $$RoutineTasksTableUpdateCompanionBuilder,
      (RoutineTask, $$RoutineTasksTableReferences),
      RoutineTask,
      PrefetchHooks Function({bool routineId, bool taskId})
    >;
typedef $$RunLogsTableCreateCompanionBuilder = RunLogsCompanion Function({
  Value<int> id,
  required String date,
  required int routineId,
  required int taskId,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
});
typedef $$RunLogsTableUpdateCompanionBuilder = RunLogsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<int> routineId,
  Value<int> taskId,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
});

final class $$RunLogsTableReferences
    extends BaseReferences<_$AppDatabase, $RunLogsTable, RunLog> {
  $$RunLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('run_logs__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('run_logs__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RunLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RunLogsTable> {
  $$RunLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RunLogsTable> {
  $$RunLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunLogsTable> {
  $$RunLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunLogsTable,
          RunLog,
          $$RunLogsTableFilterComposer,
          $$RunLogsTableOrderingComposer,
          $$RunLogsTableAnnotationComposer,
          $$RunLogsTableCreateCompanionBuilder,
          $$RunLogsTableUpdateCompanionBuilder,
          (RunLog, $$RunLogsTableReferences),
          RunLog,
          PrefetchHooks Function({bool routineId, bool taskId})
        > {
  $$RunLogsTableTableManager(_$AppDatabase db, $RunLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => RunLogsCompanion(
                id: id,
                date: date,
                routineId: routineId,
                taskId: taskId,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int routineId,
                required int taskId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => RunLogsCompanion.insert(
                id: id,
                date: date,
                routineId: routineId,
                taskId: taskId,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RunLogsTable, RunLog>(table),
                  $$RunLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$RunLogsTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$RunLogsTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$RunLogsTableReferences._taskIdTable(
                          db,
                        ),
                        referencedColumn: $$RunLogsTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RunLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunLogsTable,
      RunLog,
      $$RunLogsTableFilterComposer,
      $$RunLogsTableOrderingComposer,
      $$RunLogsTableAnnotationComposer,
      $$RunLogsTableCreateCompanionBuilder,
      $$RunLogsTableUpdateCompanionBuilder,
      (RunLog, $$RunLogsTableReferences),
      RunLog,
      PrefetchHooks Function({bool routineId, bool taskId})
    >;
typedef $$RewardsTableCreateCompanionBuilder = RewardsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> photoPath,
  required int starCost,
  Value<DateTime?> redeemedAt,
});
typedef $$RewardsTableUpdateCompanionBuilder = RewardsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> photoPath,
  Value<int> starCost,
  Value<DateTime?> redeemedAt,
});

class $$RewardsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starCost => $composableBuilder(
    column: $table.starCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starCost => $composableBuilder(
    column: $table.starCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get starCost =>
      $composableBuilder(column: $table.starCost, builder: (column) => column);

  GeneratedColumn<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => column,
  );
}

class $$RewardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardsTable,
          Reward,
          $$RewardsTableFilterComposer,
          $$RewardsTableOrderingComposer,
          $$RewardsTableAnnotationComposer,
          $$RewardsTableCreateCompanionBuilder,
          $$RewardsTableUpdateCompanionBuilder,
          (Reward, BaseReferences<_$AppDatabase, $RewardsTable, Reward>),
          Reward,
          PrefetchHooks Function()
        > {
  $$RewardsTableTableManager(_$AppDatabase db, $RewardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> starCost = const Value.absent(),
                Value<DateTime?> redeemedAt = const Value.absent(),
              }) => RewardsCompanion(
                id: id,
                name: name,
                photoPath: photoPath,
                starCost: starCost,
                redeemedAt: redeemedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> photoPath = const Value.absent(),
                required int starCost,
                Value<DateTime?> redeemedAt = const Value.absent(),
              }) => RewardsCompanion.insert(
                id: id,
                name: name,
                photoPath: photoPath,
                starCost: starCost,
                redeemedAt: redeemedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardsTable, Reward>(table),
                  BaseReferences<_$AppDatabase, $RewardsTable, Reward>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardsTable,
      Reward,
      $$RewardsTableFilterComposer,
      $$RewardsTableOrderingComposer,
      $$RewardsTableAnnotationComposer,
      $$RewardsTableCreateCompanionBuilder,
      $$RewardsTableUpdateCompanionBuilder,
      (Reward, BaseReferences<_$AppDatabase, $RewardsTable, Reward>),
      Reward,
      PrefetchHooks Function()
    >;
typedef $$StarLedgerTableCreateCompanionBuilder = StarLedgerCompanion Function({
  Value<int> id,
  required String date,
  required int delta,
  required StarReason reason,
  Value<int?> refId,
});
typedef $$StarLedgerTableUpdateCompanionBuilder = StarLedgerCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<int> delta,
  Value<StarReason> reason,
  Value<int?> refId,
});

class $$StarLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $StarLedgerTable> {
  $$StarLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StarReason, StarReason, String> get reason =>
      $composableBuilder(
        column: $table.reason,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StarLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $StarLedgerTable> {
  $$StarLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StarLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $StarLedgerTable> {
  $$StarLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StarReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);
}

class $$StarLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StarLedgerTable,
          StarEntry,
          $$StarLedgerTableFilterComposer,
          $$StarLedgerTableOrderingComposer,
          $$StarLedgerTableAnnotationComposer,
          $$StarLedgerTableCreateCompanionBuilder,
          $$StarLedgerTableUpdateCompanionBuilder,
          (
            StarEntry,
            BaseReferences<_$AppDatabase, $StarLedgerTable, StarEntry>,
          ),
          StarEntry,
          PrefetchHooks Function()
        > {
  $$StarLedgerTableTableManager(_$AppDatabase db, $StarLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StarLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StarLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StarLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<StarReason> reason = const Value.absent(),
                Value<int?> refId = const Value.absent(),
              }) => StarLedgerCompanion(
                id: id,
                date: date,
                delta: delta,
                reason: reason,
                refId: refId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int delta,
                required StarReason reason,
                Value<int?> refId = const Value.absent(),
              }) => StarLedgerCompanion.insert(
                id: id,
                date: date,
                delta: delta,
                reason: reason,
                refId: refId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StarLedgerTable, StarEntry>(table),
                  BaseReferences<_$AppDatabase, $StarLedgerTable, StarEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StarLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StarLedgerTable,
      StarEntry,
      $$StarLedgerTableFilterComposer,
      $$StarLedgerTableOrderingComposer,
      $$StarLedgerTableAnnotationComposer,
      $$StarLedgerTableCreateCompanionBuilder,
      $$StarLedgerTableUpdateCompanionBuilder,
      (StarEntry, BaseReferences<_$AppDatabase, $StarLedgerTable, StarEntry>),
      StarEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$RoutineTasksTableTableManager get routineTasks =>
      $$RoutineTasksTableTableManager(_db, _db.routineTasks);
  $$RunLogsTableTableManager get runLogs =>
      $$RunLogsTableTableManager(_db, _db.runLogs);
  $$RewardsTableTableManager get rewards =>
      $$RewardsTableTableManager(_db, _db.rewards);
  $$StarLedgerTableTableManager get starLedger =>
      $$StarLedgerTableTableManager(_db, _db.starLedger);
}
