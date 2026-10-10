// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VendorsTable extends Vendors with TableInfo<$VendorsTable, Vendor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendorsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultQtyMeta = const VerificationMeta(
    'defaultQty',
  );
  @override
  late final GeneratedColumn<double> defaultQty = GeneratedColumn<double>(
    'default_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleDaysMeta = const VerificationMeta(
    'scheduleDays',
  );
  @override
  late final GeneratedColumn<int> scheduleDays = GeneratedColumn<int>(
    'schedule_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    name,
    unit,
    defaultQty,
    rate,
    scheduleDays,
    archived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vendor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('default_qty')) {
      context.handle(
        _defaultQtyMeta,
        defaultQty.isAcceptableOrUnknown(data['default_qty']!, _defaultQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_defaultQtyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('schedule_days')) {
      context.handle(
        _scheduleDaysMeta,
        scheduleDays.isAcceptableOrUnknown(
          data['schedule_days']!,
          _scheduleDaysMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vendor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vendor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      defaultQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_qty'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      scheduleDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_days'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VendorsTable createAlias(String alias) {
    return $VendorsTable(attachedDatabase, alias);
  }
}

class Vendor extends DataClass implements Insertable<Vendor> {
  final int id;
  final String type;
  final String name;
  final String unit;
  final double defaultQty;
  final double rate;
  final int scheduleDays;
  final bool archived;
  final String createdAt;
  const Vendor({
    required this.id,
    required this.type,
    required this.name,
    required this.unit,
    required this.defaultQty,
    required this.rate,
    required this.scheduleDays,
    required this.archived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['default_qty'] = Variable<double>(defaultQty);
    map['rate'] = Variable<double>(rate);
    map['schedule_days'] = Variable<int>(scheduleDays);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  VendorsCompanion toCompanion(bool nullToAbsent) {
    return VendorsCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      unit: Value(unit),
      defaultQty: Value(defaultQty),
      rate: Value(rate),
      scheduleDays: Value(scheduleDays),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory Vendor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vendor(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      defaultQty: serializer.fromJson<double>(json['defaultQty']),
      rate: serializer.fromJson<double>(json['rate']),
      scheduleDays: serializer.fromJson<int>(json['scheduleDays']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'defaultQty': serializer.toJson<double>(defaultQty),
      'rate': serializer.toJson<double>(rate),
      'scheduleDays': serializer.toJson<int>(scheduleDays),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Vendor copyWith({
    int? id,
    String? type,
    String? name,
    String? unit,
    double? defaultQty,
    double? rate,
    int? scheduleDays,
    bool? archived,
    String? createdAt,
  }) => Vendor(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    defaultQty: defaultQty ?? this.defaultQty,
    rate: rate ?? this.rate,
    scheduleDays: scheduleDays ?? this.scheduleDays,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );
  Vendor copyWithCompanion(VendorsCompanion data) {
    return Vendor(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      defaultQty: data.defaultQty.present
          ? data.defaultQty.value
          : this.defaultQty,
      rate: data.rate.present ? data.rate.value : this.rate,
      scheduleDays: data.scheduleDays.present
          ? data.scheduleDays.value
          : this.scheduleDays,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vendor(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('defaultQty: $defaultQty, ')
          ..write('rate: $rate, ')
          ..write('scheduleDays: $scheduleDays, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    unit,
    defaultQty,
    rate,
    scheduleDays,
    archived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vendor &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.defaultQty == this.defaultQty &&
          other.rate == this.rate &&
          other.scheduleDays == this.scheduleDays &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class VendorsCompanion extends UpdateCompanion<Vendor> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> defaultQty;
  final Value<double> rate;
  final Value<int> scheduleDays;
  final Value<bool> archived;
  final Value<String> createdAt;
  const VendorsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.defaultQty = const Value.absent(),
    this.rate = const Value.absent(),
    this.scheduleDays = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VendorsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.name = const Value.absent(),
    required String unit,
    required double defaultQty,
    required double rate,
    this.scheduleDays = const Value.absent(),
    this.archived = const Value.absent(),
    required String createdAt,
  }) : type = Value(type),
       unit = Value(unit),
       defaultQty = Value(defaultQty),
       rate = Value(rate),
       createdAt = Value(createdAt);
  static Insertable<Vendor> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? defaultQty,
    Expression<double>? rate,
    Expression<int>? scheduleDays,
    Expression<bool>? archived,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (defaultQty != null) 'default_qty': defaultQty,
      if (rate != null) 'rate': rate,
      if (scheduleDays != null) 'schedule_days': scheduleDays,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VendorsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? name,
    Value<String>? unit,
    Value<double>? defaultQty,
    Value<double>? rate,
    Value<int>? scheduleDays,
    Value<bool>? archived,
    Value<String>? createdAt,
  }) {
    return VendorsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      defaultQty: defaultQty ?? this.defaultQty,
      rate: rate ?? this.rate,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (defaultQty.present) {
      map['default_qty'] = Variable<double>(defaultQty.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (scheduleDays.present) {
      map['schedule_days'] = Variable<int>(scheduleDays.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendorsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('defaultQty: $defaultQty, ')
          ..write('rate: $rate, ')
          ..write('scheduleDays: $scheduleDays, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id)',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [vendorId, date, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId, date};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class Entry extends DataClass implements Insertable<Entry> {
  final int vendorId;
  final String date;
  final String status;
  const Entry({
    required this.vendorId,
    required this.date,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<int>(vendorId);
    map['date'] = Variable<String>(date);
    map['status'] = Variable<String>(status);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      vendorId: Value(vendorId),
      date: Value(date),
      status: Value(status),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      vendorId: serializer.fromJson<int>(json['vendorId']),
      date: serializer.fromJson<String>(json['date']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<int>(vendorId),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(status),
    };
  }

  Entry copyWith({int? vendorId, String? date, String? status}) => Entry(
    vendorId: vendorId ?? this.vendorId,
    date: date ?? this.date,
    status: status ?? this.status,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendorId, date, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.vendorId == this.vendorId &&
          other.date == this.date &&
          other.status == this.status);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<int> vendorId;
  final Value<String> date;
  final Value<String> status;
  final Value<int> rowid;
  const EntriesCompanion({
    this.vendorId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required int vendorId,
    required String date,
    required String status,
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       date = Value(date),
       status = Value(status);
  static Insertable<Entry> custom({
    Expression<int>? vendorId,
    Expression<String>? date,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<int>? vendorId,
    Value<String>? date,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      vendorId: vendorId ?? this.vendorId,
      date: date ?? this.date,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthRatesTable extends MonthRates
    with TableInfo<$MonthRatesTable, MonthRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id)',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [vendorId, month, rate, qty];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'month_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId, month};
  @override
  MonthRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthRate(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      )!,
    );
  }

  @override
  $MonthRatesTable createAlias(String alias) {
    return $MonthRatesTable(attachedDatabase, alias);
  }
}

class MonthRate extends DataClass implements Insertable<MonthRate> {
  final int vendorId;
  final String month;
  final double rate;
  final double qty;
  const MonthRate({
    required this.vendorId,
    required this.month,
    required this.rate,
    required this.qty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<int>(vendorId);
    map['month'] = Variable<String>(month);
    map['rate'] = Variable<double>(rate);
    map['qty'] = Variable<double>(qty);
    return map;
  }

  MonthRatesCompanion toCompanion(bool nullToAbsent) {
    return MonthRatesCompanion(
      vendorId: Value(vendorId),
      month: Value(month),
      rate: Value(rate),
      qty: Value(qty),
    );
  }

  factory MonthRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthRate(
      vendorId: serializer.fromJson<int>(json['vendorId']),
      month: serializer.fromJson<String>(json['month']),
      rate: serializer.fromJson<double>(json['rate']),
      qty: serializer.fromJson<double>(json['qty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<int>(vendorId),
      'month': serializer.toJson<String>(month),
      'rate': serializer.toJson<double>(rate),
      'qty': serializer.toJson<double>(qty),
    };
  }

  MonthRate copyWith({
    int? vendorId,
    String? month,
    double? rate,
    double? qty,
  }) => MonthRate(
    vendorId: vendorId ?? this.vendorId,
    month: month ?? this.month,
    rate: rate ?? this.rate,
    qty: qty ?? this.qty,
  );
  MonthRate copyWithCompanion(MonthRatesCompanion data) {
    return MonthRate(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      month: data.month.present ? data.month.value : this.month,
      rate: data.rate.present ? data.rate.value : this.rate,
      qty: data.qty.present ? data.qty.value : this.qty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthRate(')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('rate: $rate, ')
          ..write('qty: $qty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendorId, month, rate, qty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthRate &&
          other.vendorId == this.vendorId &&
          other.month == this.month &&
          other.rate == this.rate &&
          other.qty == this.qty);
}

class MonthRatesCompanion extends UpdateCompanion<MonthRate> {
  final Value<int> vendorId;
  final Value<String> month;
  final Value<double> rate;
  final Value<double> qty;
  final Value<int> rowid;
  const MonthRatesCompanion({
    this.vendorId = const Value.absent(),
    this.month = const Value.absent(),
    this.rate = const Value.absent(),
    this.qty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthRatesCompanion.insert({
    required int vendorId,
    required String month,
    required double rate,
    required double qty,
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       month = Value(month),
       rate = Value(rate),
       qty = Value(qty);
  static Insertable<MonthRate> custom({
    Expression<int>? vendorId,
    Expression<String>? month,
    Expression<double>? rate,
    Expression<double>? qty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (month != null) 'month': month,
      if (rate != null) 'rate': rate,
      if (qty != null) 'qty': qty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthRatesCompanion copyWith({
    Value<int>? vendorId,
    Value<String>? month,
    Value<double>? rate,
    Value<double>? qty,
    Value<int>? rowid,
  }) {
    return MonthRatesCompanion(
      vendorId: vendorId ?? this.vendorId,
      month: month ?? this.month,
      rate: rate ?? this.rate,
      qty: qty ?? this.qty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthRatesCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('rate: $rate, ')
          ..write('qty: $qty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id)',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<String> paidAt = GeneratedColumn<String>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [vendorId, month, paidAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId, month};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int vendorId;
  final String month;
  final String paidAt;
  const Payment({
    required this.vendorId,
    required this.month,
    required this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<int>(vendorId);
    map['month'] = Variable<String>(month);
    map['paid_at'] = Variable<String>(paidAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      vendorId: Value(vendorId),
      month: Value(month),
      paidAt: Value(paidAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      vendorId: serializer.fromJson<int>(json['vendorId']),
      month: serializer.fromJson<String>(json['month']),
      paidAt: serializer.fromJson<String>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<int>(vendorId),
      'month': serializer.toJson<String>(month),
      'paidAt': serializer.toJson<String>(paidAt),
    };
  }

  Payment copyWith({int? vendorId, String? month, String? paidAt}) => Payment(
    vendorId: vendorId ?? this.vendorId,
    month: month ?? this.month,
    paidAt: paidAt ?? this.paidAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      month: data.month.present ? data.month.value : this.month,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendorId, month, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.vendorId == this.vendorId &&
          other.month == this.month &&
          other.paidAt == this.paidAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> vendorId;
  final Value<String> month;
  final Value<String> paidAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.vendorId = const Value.absent(),
    this.month = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required int vendorId,
    required String month,
    required String paidAt,
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       month = Value(month),
       paidAt = Value(paidAt);
  static Insertable<Payment> custom({
    Expression<int>? vendorId,
    Expression<String>? month,
    Expression<String>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (month != null) 'month': month,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? vendorId,
    Value<String>? month,
    Value<String>? paidAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      vendorId: vendorId ?? this.vendorId,
      month: month ?? this.month,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<String>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyDetailsTable extends DailyDetails
    with TableInfo<$DailyDetailsTable, DailyDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id) ON DELETE CASCADE',
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
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [vendorId, date, quantity, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId, date};
  @override
  DailyDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyDetail(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $DailyDetailsTable createAlias(String alias) {
    return $DailyDetailsTable(attachedDatabase, alias);
  }
}

class DailyDetail extends DataClass implements Insertable<DailyDetail> {
  final int vendorId;
  final String date;
  final double? quantity;
  final String note;
  const DailyDetail({
    required this.vendorId,
    required this.date,
    this.quantity,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<int>(vendorId);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  DailyDetailsCompanion toCompanion(bool nullToAbsent) {
    return DailyDetailsCompanion(
      vendorId: Value(vendorId),
      date: Value(date),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      note: Value(note),
    );
  }

  factory DailyDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyDetail(
      vendorId: serializer.fromJson<int>(json['vendorId']),
      date: serializer.fromJson<String>(json['date']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<int>(vendorId),
      'date': serializer.toJson<String>(date),
      'quantity': serializer.toJson<double?>(quantity),
      'note': serializer.toJson<String>(note),
    };
  }

  DailyDetail copyWith({
    int? vendorId,
    String? date,
    Value<double?> quantity = const Value.absent(),
    String? note,
  }) => DailyDetail(
    vendorId: vendorId ?? this.vendorId,
    date: date ?? this.date,
    quantity: quantity.present ? quantity.value : this.quantity,
    note: note ?? this.note,
  );
  DailyDetail copyWithCompanion(DailyDetailsCompanion data) {
    return DailyDetail(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyDetail(')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendorId, date, quantity, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyDetail &&
          other.vendorId == this.vendorId &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.note == this.note);
}

class DailyDetailsCompanion extends UpdateCompanion<DailyDetail> {
  final Value<int> vendorId;
  final Value<String> date;
  final Value<double?> quantity;
  final Value<String> note;
  final Value<int> rowid;
  const DailyDetailsCompanion({
    this.vendorId = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyDetailsCompanion.insert({
    required int vendorId,
    required String date,
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       date = Value(date);
  static Insertable<DailyDetail> custom({
    Expression<int>? vendorId,
    Expression<String>? date,
    Expression<double>? quantity,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyDetailsCompanion copyWith({
    Value<int>? vendorId,
    Value<String>? date,
    Value<double?>? quantity,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return DailyDetailsCompanion(
      vendorId: vendorId ?? this.vendorId,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyDetailsCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RateChangesTable extends RateChanges
    with TableInfo<$RateChangesTable, RateChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RateChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    vendorId,
    effectiveDate,
    quantity,
    rate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rate_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RateChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId, effectiveDate};
  @override
  RateChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateChange(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  $RateChangesTable createAlias(String alias) {
    return $RateChangesTable(attachedDatabase, alias);
  }
}

class RateChange extends DataClass implements Insertable<RateChange> {
  final int vendorId;
  final String effectiveDate;
  final double quantity;
  final double rate;
  const RateChange({
    required this.vendorId,
    required this.effectiveDate,
    required this.quantity,
    required this.rate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<int>(vendorId);
    map['effective_date'] = Variable<String>(effectiveDate);
    map['quantity'] = Variable<double>(quantity);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  RateChangesCompanion toCompanion(bool nullToAbsent) {
    return RateChangesCompanion(
      vendorId: Value(vendorId),
      effectiveDate: Value(effectiveDate),
      quantity: Value(quantity),
      rate: Value(rate),
    );
  }

  factory RateChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateChange(
      vendorId: serializer.fromJson<int>(json['vendorId']),
      effectiveDate: serializer.fromJson<String>(json['effectiveDate']),
      quantity: serializer.fromJson<double>(json['quantity']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<int>(vendorId),
      'effectiveDate': serializer.toJson<String>(effectiveDate),
      'quantity': serializer.toJson<double>(quantity),
      'rate': serializer.toJson<double>(rate),
    };
  }

  RateChange copyWith({
    int? vendorId,
    String? effectiveDate,
    double? quantity,
    double? rate,
  }) => RateChange(
    vendorId: vendorId ?? this.vendorId,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    quantity: quantity ?? this.quantity,
    rate: rate ?? this.rate,
  );
  RateChange copyWithCompanion(RateChangesCompanion data) {
    return RateChange(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateChange(')
          ..write('vendorId: $vendorId, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('quantity: $quantity, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendorId, effectiveDate, quantity, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateChange &&
          other.vendorId == this.vendorId &&
          other.effectiveDate == this.effectiveDate &&
          other.quantity == this.quantity &&
          other.rate == this.rate);
}

class RateChangesCompanion extends UpdateCompanion<RateChange> {
  final Value<int> vendorId;
  final Value<String> effectiveDate;
  final Value<double> quantity;
  final Value<double> rate;
  final Value<int> rowid;
  const RateChangesCompanion({
    this.vendorId = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RateChangesCompanion.insert({
    required int vendorId,
    required String effectiveDate,
    required double quantity,
    required double rate,
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       effectiveDate = Value(effectiveDate),
       quantity = Value(quantity),
       rate = Value(rate);
  static Insertable<RateChange> custom({
    Expression<int>? vendorId,
    Expression<String>? effectiveDate,
    Expression<double>? quantity,
    Expression<double>? rate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (quantity != null) 'quantity': quantity,
      if (rate != null) 'rate': rate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RateChangesCompanion copyWith({
    Value<int>? vendorId,
    Value<String>? effectiveDate,
    Value<double>? quantity,
    Value<double>? rate,
    Value<int>? rowid,
  }) {
    return RateChangesCompanion(
      vendorId: vendorId ?? this.vendorId,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RateChangesCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('quantity: $quantity, ')
          ..write('rate: $rate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VendorPausesTable extends VendorPauses
    with TableInfo<$VendorPausesTable, VendorPause> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendorPausesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    startDate,
    endDate,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendor_pauses';
  @override
  VerificationContext validateIntegrity(
    Insertable<VendorPause> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VendorPause map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VendorPause(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $VendorPausesTable createAlias(String alias) {
    return $VendorPausesTable(attachedDatabase, alias);
  }
}

class VendorPause extends DataClass implements Insertable<VendorPause> {
  final int id;
  final int vendorId;
  final String startDate;
  final String endDate;
  final String note;
  const VendorPause({
    required this.id,
    required this.vendorId,
    required this.startDate,
    required this.endDate,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vendor_id'] = Variable<int>(vendorId);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['note'] = Variable<String>(note);
    return map;
  }

  VendorPausesCompanion toCompanion(bool nullToAbsent) {
    return VendorPausesCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      note: Value(note),
    );
  }

  factory VendorPause.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VendorPause(
      id: serializer.fromJson<int>(json['id']),
      vendorId: serializer.fromJson<int>(json['vendorId']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vendorId': serializer.toJson<int>(vendorId),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'note': serializer.toJson<String>(note),
    };
  }

  VendorPause copyWith({
    int? id,
    int? vendorId,
    String? startDate,
    String? endDate,
    String? note,
  }) => VendorPause(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    note: note ?? this.note,
  );
  VendorPause copyWithCompanion(VendorPausesCompanion data) {
    return VendorPause(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VendorPause(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vendorId, startDate, endDate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VendorPause &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.note == this.note);
}

class VendorPausesCompanion extends UpdateCompanion<VendorPause> {
  final Value<int> id;
  final Value<int> vendorId;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<String> note;
  const VendorPausesCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.note = const Value.absent(),
  });
  VendorPausesCompanion.insert({
    this.id = const Value.absent(),
    required int vendorId,
    required String startDate,
    required String endDate,
    this.note = const Value.absent(),
  }) : vendorId = Value(vendorId),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<VendorPause> custom({
    Expression<int>? id,
    Expression<int>? vendorId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (note != null) 'note': note,
    });
  }

  VendorPausesCompanion copyWith({
    Value<int>? id,
    Value<int>? vendorId,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<String>? note,
  }) {
    return VendorPausesCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendorPausesCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id) ON DELETE CASCADE',
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    date,
    name,
    quantity,
    unitPricePaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final int vendorId;
  final String date;
  final String name;
  final double quantity;
  final int unitPricePaise;
  const Purchase({
    required this.id,
    required this.vendorId,
    required this.date,
    required this.name,
    required this.quantity,
    required this.unitPricePaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vendor_id'] = Variable<int>(vendorId);
    map['date'] = Variable<String>(date);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      date: Value(date),
      name: Value(name),
      quantity: Value(quantity),
      unitPricePaise: Value(unitPricePaise),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      vendorId: serializer.fromJson<int>(json['vendorId']),
      date: serializer.fromJson<String>(json['date']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vendorId': serializer.toJson<int>(vendorId),
      'date': serializer.toJson<String>(date),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
    };
  }

  Purchase copyWith({
    int? id,
    int? vendorId,
    String? date,
    String? name,
    double? quantity,
    int? unitPricePaise,
  }) => Purchase(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    date: date ?? this.date,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      date: data.date.present ? data.date.value : this.date,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vendorId, date, name, quantity, unitPricePaise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.date == this.date &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unitPricePaise == this.unitPricePaise);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<int> vendorId;
  final Value<String> date;
  final Value<String> name;
  final Value<double> quantity;
  final Value<int> unitPricePaise;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.date = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int vendorId,
    required String date,
    required String name,
    required double quantity,
    required int unitPricePaise,
  }) : vendorId = Value(vendorId),
       date = Value(date),
       name = Value(name),
       quantity = Value(quantity),
       unitPricePaise = Value(unitPricePaise);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<int>? vendorId,
    Expression<String>? date,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<int>? unitPricePaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (date != null) 'date': date,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? vendorId,
    Value<String>? date,
    Value<String>? name,
    Value<double>? quantity,
    Value<int>? unitPricePaise,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      date: date ?? this.date,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise')
          ..write(')'))
        .toString();
  }
}

class $LedgerPaymentsTable extends LedgerPayments
    with TableInfo<$LedgerPaymentsTable, LedgerPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerPaymentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<int> vendorId = GeneratedColumn<int>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vendors (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    month,
    date,
    amountPaise,
    kind,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendor_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $LedgerPaymentsTable createAlias(String alias) {
    return $LedgerPaymentsTable(attachedDatabase, alias);
  }
}

class LedgerPayment extends DataClass implements Insertable<LedgerPayment> {
  final int id;
  final int vendorId;
  final String month;
  final String date;
  final int amountPaise;
  final String kind;
  final String note;
  const LedgerPayment({
    required this.id,
    required this.vendorId,
    required this.month,
    required this.date,
    required this.amountPaise,
    required this.kind,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vendor_id'] = Variable<int>(vendorId);
    map['month'] = Variable<String>(month);
    map['date'] = Variable<String>(date);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['kind'] = Variable<String>(kind);
    map['note'] = Variable<String>(note);
    return map;
  }

  LedgerPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LedgerPaymentsCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      month: Value(month),
      date: Value(date),
      amountPaise: Value(amountPaise),
      kind: Value(kind),
      note: Value(note),
    );
  }

  factory LedgerPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerPayment(
      id: serializer.fromJson<int>(json['id']),
      vendorId: serializer.fromJson<int>(json['vendorId']),
      month: serializer.fromJson<String>(json['month']),
      date: serializer.fromJson<String>(json['date']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      kind: serializer.fromJson<String>(json['kind']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vendorId': serializer.toJson<int>(vendorId),
      'month': serializer.toJson<String>(month),
      'date': serializer.toJson<String>(date),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'kind': serializer.toJson<String>(kind),
      'note': serializer.toJson<String>(note),
    };
  }

  LedgerPayment copyWith({
    int? id,
    int? vendorId,
    String? month,
    String? date,
    int? amountPaise,
    String? kind,
    String? note,
  }) => LedgerPayment(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    month: month ?? this.month,
    date: date ?? this.date,
    amountPaise: amountPaise ?? this.amountPaise,
    kind: kind ?? this.kind,
    note: note ?? this.note,
  );
  LedgerPayment copyWithCompanion(LedgerPaymentsCompanion data) {
    return LedgerPayment(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      month: data.month.present ? data.month.value : this.month,
      date: data.date.present ? data.date.value : this.date,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      kind: data.kind.present ? data.kind.value : this.kind,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerPayment(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('date: $date, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vendorId, month, date, amountPaise, kind, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerPayment &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.month == this.month &&
          other.date == this.date &&
          other.amountPaise == this.amountPaise &&
          other.kind == this.kind &&
          other.note == this.note);
}

class LedgerPaymentsCompanion extends UpdateCompanion<LedgerPayment> {
  final Value<int> id;
  final Value<int> vendorId;
  final Value<String> month;
  final Value<String> date;
  final Value<int> amountPaise;
  final Value<String> kind;
  final Value<String> note;
  const LedgerPaymentsCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.month = const Value.absent(),
    this.date = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.kind = const Value.absent(),
    this.note = const Value.absent(),
  });
  LedgerPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int vendorId,
    required String month,
    required String date,
    required int amountPaise,
    required String kind,
    this.note = const Value.absent(),
  }) : vendorId = Value(vendorId),
       month = Value(month),
       date = Value(date),
       amountPaise = Value(amountPaise),
       kind = Value(kind);
  static Insertable<LedgerPayment> custom({
    Expression<int>? id,
    Expression<int>? vendorId,
    Expression<String>? month,
    Expression<String>? date,
    Expression<int>? amountPaise,
    Expression<String>? kind,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (month != null) 'month': month,
      if (date != null) 'date': date,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (kind != null) 'kind': kind,
      if (note != null) 'note': note,
    });
  }

  LedgerPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? vendorId,
    Value<String>? month,
    Value<String>? date,
    Value<int>? amountPaise,
    Value<String>? kind,
    Value<String>? note,
  }) {
    return LedgerPaymentsCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      month: month ?? this.month,
      date: date ?? this.date,
      amountPaise: amountPaise ?? this.amountPaise,
      kind: kind ?? this.kind,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<int>(vendorId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('month: $month, ')
          ..write('date: $date, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VendorsTable vendors = $VendorsTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  late final $MonthRatesTable monthRates = $MonthRatesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DailyDetailsTable dailyDetails = $DailyDetailsTable(this);
  late final $RateChangesTable rateChanges = $RateChangesTable(this);
  late final $VendorPausesTable vendorPauses = $VendorPausesTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $LedgerPaymentsTable ledgerPayments = $LedgerPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vendors,
    entries,
    monthRates,
    payments,
    settings,
    dailyDetails,
    rateChanges,
    vendorPauses,
    purchases,
    ledgerPayments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vendors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('daily_details', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vendors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rate_changes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vendors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vendor_pauses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vendors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('purchases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vendors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ledger_payments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VendorsTableCreateCompanionBuilder =
    VendorsCompanion Function({
      Value<int> id,
      required String type,
      Value<String> name,
      required String unit,
      required double defaultQty,
      required double rate,
      Value<int> scheduleDays,
      Value<bool> archived,
      required String createdAt,
    });
typedef $$VendorsTableUpdateCompanionBuilder =
    VendorsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> name,
      Value<String> unit,
      Value<double> defaultQty,
      Value<double> rate,
      Value<int> scheduleDays,
      Value<bool> archived,
      Value<String> createdAt,
    });

final class $$VendorsTableReferences
    extends BaseReferences<_$AppDatabase, $VendorsTable, Vendor> {
  $$VendorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntriesTable, List<Entry>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: 'vendors__id__entries__vendor_id',
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MonthRatesTable, List<MonthRate>>
  _monthRatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.monthRates,
    aliasName: 'vendors__id__month_rates__vendor_id',
  );

  $$MonthRatesTableProcessedTableManager get monthRatesRefs {
    final manager = $$MonthRatesTableTableManager(
      $_db,
      $_db.monthRates,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_monthRatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'vendors__id__payments__vendor_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyDetailsTable, List<DailyDetail>>
  _dailyDetailsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyDetails,
    aliasName: 'vendors__id__daily_details__vendor_id',
  );

  $$DailyDetailsTableProcessedTableManager get dailyDetailsRefs {
    final manager = $$DailyDetailsTableTableManager(
      $_db,
      $_db.dailyDetails,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RateChangesTable, List<RateChange>>
  _rateChangesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rateChanges,
    aliasName: 'vendors__id__rate_changes__vendor_id',
  );

  $$RateChangesTableProcessedTableManager get rateChangesRefs {
    final manager = $$RateChangesTableTableManager(
      $_db,
      $_db.rateChanges,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rateChangesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VendorPausesTable, List<VendorPause>>
  _vendorPausesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vendorPauses,
    aliasName: 'vendors__id__vendor_pauses__vendor_id',
  );

  $$VendorPausesTableProcessedTableManager get vendorPausesRefs {
    final manager = $$VendorPausesTableTableManager(
      $_db,
      $_db.vendorPauses,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vendorPausesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
  _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchases,
    aliasName: 'vendors__id__purchases__vendor_id',
  );

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LedgerPaymentsTable, List<LedgerPayment>>
  _ledgerPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerPayments,
    aliasName: 'vendors__id__ledger_payments__vendor_id',
  );

  $$LedgerPaymentsTableProcessedTableManager get ledgerPaymentsRefs {
    final manager = $$LedgerPaymentsTableTableManager(
      $_db,
      $_db.ledgerPayments,
    ).filter((f) => f.vendorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VendorsTableFilterComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultQty => $composableBuilder(
    column: $table.defaultQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleDays => $composableBuilder(
    column: $table.scheduleDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> monthRatesRefs(
    Expression<bool> Function($$MonthRatesTableFilterComposer f) f,
  ) {
    final $$MonthRatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monthRates,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthRatesTableFilterComposer(
            $db: $db,
            $table: $db.monthRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyDetailsRefs(
    Expression<bool> Function($$DailyDetailsTableFilterComposer f) f,
  ) {
    final $$DailyDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyDetails,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyDetailsTableFilterComposer(
            $db: $db,
            $table: $db.dailyDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rateChangesRefs(
    Expression<bool> Function($$RateChangesTableFilterComposer f) f,
  ) {
    final $$RateChangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rateChanges,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RateChangesTableFilterComposer(
            $db: $db,
            $table: $db.rateChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vendorPausesRefs(
    Expression<bool> Function($$VendorPausesTableFilterComposer f) f,
  ) {
    final $$VendorPausesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vendorPauses,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorPausesTableFilterComposer(
            $db: $db,
            $table: $db.vendorPauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchasesRefs(
    Expression<bool> Function($$PurchasesTableFilterComposer f) f,
  ) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ledgerPaymentsRefs(
    Expression<bool> Function($$LedgerPaymentsTableFilterComposer f) f,
  ) {
    final $$LedgerPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerPayments,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VendorsTableOrderingComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultQty => $composableBuilder(
    column: $table.defaultQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleDays => $composableBuilder(
    column: $table.scheduleDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VendorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get defaultQty => $composableBuilder(
    column: $table.defaultQty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<int> get scheduleDays => $composableBuilder(
    column: $table.scheduleDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> monthRatesRefs<T extends Object>(
    Expression<T> Function($$MonthRatesTableAnnotationComposer a) f,
  ) {
    final $$MonthRatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monthRates,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthRatesTableAnnotationComposer(
            $db: $db,
            $table: $db.monthRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyDetailsRefs<T extends Object>(
    Expression<T> Function($$DailyDetailsTableAnnotationComposer a) f,
  ) {
    final $$DailyDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyDetails,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rateChangesRefs<T extends Object>(
    Expression<T> Function($$RateChangesTableAnnotationComposer a) f,
  ) {
    final $$RateChangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rateChanges,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RateChangesTableAnnotationComposer(
            $db: $db,
            $table: $db.rateChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vendorPausesRefs<T extends Object>(
    Expression<T> Function($$VendorPausesTableAnnotationComposer a) f,
  ) {
    final $$VendorPausesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vendorPauses,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorPausesTableAnnotationComposer(
            $db: $db,
            $table: $db.vendorPauses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
    Expression<T> Function($$PurchasesTableAnnotationComposer a) f,
  ) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ledgerPaymentsRefs<T extends Object>(
    Expression<T> Function($$LedgerPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LedgerPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerPayments,
      getReferencedColumn: (t) => t.vendorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VendorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VendorsTable,
          Vendor,
          $$VendorsTableFilterComposer,
          $$VendorsTableOrderingComposer,
          $$VendorsTableAnnotationComposer,
          $$VendorsTableCreateCompanionBuilder,
          $$VendorsTableUpdateCompanionBuilder,
          (Vendor, $$VendorsTableReferences),
          Vendor,
          PrefetchHooks Function({
            bool entriesRefs,
            bool monthRatesRefs,
            bool paymentsRefs,
            bool dailyDetailsRefs,
            bool rateChangesRefs,
            bool vendorPausesRefs,
            bool purchasesRefs,
            bool ledgerPaymentsRefs,
          })
        > {
  $$VendorsTableTableManager(_$AppDatabase db, $VendorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> defaultQty = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<int> scheduleDays = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => VendorsCompanion(
                id: id,
                type: type,
                name: name,
                unit: unit,
                defaultQty: defaultQty,
                rate: rate,
                scheduleDays: scheduleDays,
                archived: archived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<String> name = const Value.absent(),
                required String unit,
                required double defaultQty,
                required double rate,
                Value<int> scheduleDays = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required String createdAt,
              }) => VendorsCompanion.insert(
                id: id,
                type: type,
                name: name,
                unit: unit,
                defaultQty: defaultQty,
                rate: rate,
                scheduleDays: scheduleDays,
                archived: archived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VendorsTable, Vendor>(table),
                  $$VendorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                entriesRefs = false,
                monthRatesRefs = false,
                paymentsRefs = false,
                dailyDetailsRefs = false,
                rateChangesRefs = false,
                vendorPausesRefs = false,
                purchasesRefs = false,
                ledgerPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entriesRefs) db.entries,
                    if (monthRatesRefs) db.monthRates,
                    if (paymentsRefs) db.payments,
                    if (dailyDetailsRefs) db.dailyDetails,
                    if (rateChangesRefs) db.rateChanges,
                    if (vendorPausesRefs) db.vendorPauses,
                    if (purchasesRefs) db.purchases,
                    if (ledgerPaymentsRefs) db.ledgerPayments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (entriesRefs)
                        await $_getPrefetchedData<Vendor, $VendorsTable, Entry>(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._entriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).entriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (monthRatesRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          MonthRate
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._monthRatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).monthRatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyDetailsRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          DailyDetail
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._dailyDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyDetailsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rateChangesRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          RateChange
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._rateChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).rateChangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vendorPausesRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          VendorPause
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._vendorPausesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).vendorPausesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchasesRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          Purchase
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._purchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ledgerPaymentsRefs)
                        await $_getPrefetchedData<
                          Vendor,
                          $VendorsTable,
                          LedgerPayment
                        >(
                          currentTable: table,
                          referencedTable: $$VendorsTableReferences
                              ._ledgerPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VendorsTableReferences(
                                db,
                                table,
                                p0,
                              ).ledgerPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vendorId == item.id,
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

typedef $$VendorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VendorsTable,
      Vendor,
      $$VendorsTableFilterComposer,
      $$VendorsTableOrderingComposer,
      $$VendorsTableAnnotationComposer,
      $$VendorsTableCreateCompanionBuilder,
      $$VendorsTableUpdateCompanionBuilder,
      (Vendor, $$VendorsTableReferences),
      Vendor,
      PrefetchHooks Function({
        bool entriesRefs,
        bool monthRatesRefs,
        bool paymentsRefs,
        bool dailyDetailsRefs,
        bool rateChangesRefs,
        bool vendorPausesRefs,
        bool purchasesRefs,
        bool ledgerPaymentsRefs,
      })
    >;
typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      required int vendorId,
      required String date,
      required String status,
      Value<int> rowid,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> vendorId,
      Value<String> date,
      Value<String> status,
      Value<int> rowid,
    });

final class $$EntriesTableReferences
    extends BaseReferences<_$AppDatabase, $EntriesTable, Entry> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('entries__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          Entry,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (Entry, $$EntriesTableReferences),
          Entry,
          PrefetchHooks Function({bool vendorId})
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vendorId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                vendorId: vendorId,
                date: date,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vendorId,
                required String date,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                vendorId: vendorId,
                date: date,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntriesTable, Entry>(table),
                  $$EntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$EntriesTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$EntriesTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      Entry,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (Entry, $$EntriesTableReferences),
      Entry,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$MonthRatesTableCreateCompanionBuilder =
    MonthRatesCompanion Function({
      required int vendorId,
      required String month,
      required double rate,
      required double qty,
      Value<int> rowid,
    });
typedef $$MonthRatesTableUpdateCompanionBuilder =
    MonthRatesCompanion Function({
      Value<int> vendorId,
      Value<String> month,
      Value<double> rate,
      Value<double> qty,
      Value<int> rowid,
    });

final class $$MonthRatesTableReferences
    extends BaseReferences<_$AppDatabase, $MonthRatesTable, MonthRate> {
  $$MonthRatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('month_rates__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MonthRatesTableFilterComposer
    extends Composer<_$AppDatabase, $MonthRatesTable> {
  $$MonthRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthRatesTable> {
  $$MonthRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthRatesTable> {
  $$MonthRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthRatesTable,
          MonthRate,
          $$MonthRatesTableFilterComposer,
          $$MonthRatesTableOrderingComposer,
          $$MonthRatesTableAnnotationComposer,
          $$MonthRatesTableCreateCompanionBuilder,
          $$MonthRatesTableUpdateCompanionBuilder,
          (MonthRate, $$MonthRatesTableReferences),
          MonthRate,
          PrefetchHooks Function({bool vendorId})
        > {
  $$MonthRatesTableTableManager(_$AppDatabase db, $MonthRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vendorId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthRatesCompanion(
                vendorId: vendorId,
                month: month,
                rate: rate,
                qty: qty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vendorId,
                required String month,
                required double rate,
                required double qty,
                Value<int> rowid = const Value.absent(),
              }) => MonthRatesCompanion.insert(
                vendorId: vendorId,
                month: month,
                rate: rate,
                qty: qty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonthRatesTable, MonthRate>(table),
                  $$MonthRatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$MonthRatesTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$MonthRatesTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$MonthRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthRatesTable,
      MonthRate,
      $$MonthRatesTableFilterComposer,
      $$MonthRatesTableOrderingComposer,
      $$MonthRatesTableAnnotationComposer,
      $$MonthRatesTableCreateCompanionBuilder,
      $$MonthRatesTableUpdateCompanionBuilder,
      (MonthRate, $$MonthRatesTableReferences),
      MonthRate,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required int vendorId,
      required String month,
      required String paidAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> vendorId,
      Value<String> month,
      Value<String> paidAt,
      Value<int> rowid,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('payments__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool vendorId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vendorId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<String> paidAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                vendorId: vendorId,
                month: month,
                paidAt: paidAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vendorId,
                required String month,
                required String paidAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                vendorId: vendorId,
                month: month,
                paidAt: paidAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, Payment>(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$PaymentsTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
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

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$DailyDetailsTableCreateCompanionBuilder =
    DailyDetailsCompanion Function({
      required int vendorId,
      required String date,
      Value<double?> quantity,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$DailyDetailsTableUpdateCompanionBuilder =
    DailyDetailsCompanion Function({
      Value<int> vendorId,
      Value<String> date,
      Value<double?> quantity,
      Value<String> note,
      Value<int> rowid,
    });

final class $$DailyDetailsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyDetailsTable, DailyDetail> {
  $$DailyDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('daily_details__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyDetailsTable> {
  $$DailyDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyDetailsTable> {
  $$DailyDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyDetailsTable> {
  $$DailyDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyDetailsTable,
          DailyDetail,
          $$DailyDetailsTableFilterComposer,
          $$DailyDetailsTableOrderingComposer,
          $$DailyDetailsTableAnnotationComposer,
          $$DailyDetailsTableCreateCompanionBuilder,
          $$DailyDetailsTableUpdateCompanionBuilder,
          (DailyDetail, $$DailyDetailsTableReferences),
          DailyDetail,
          PrefetchHooks Function({bool vendorId})
        > {
  $$DailyDetailsTableTableManager(_$AppDatabase db, $DailyDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vendorId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyDetailsCompanion(
                vendorId: vendorId,
                date: date,
                quantity: quantity,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vendorId,
                required String date,
                Value<double?> quantity = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyDetailsCompanion.insert(
                vendorId: vendorId,
                date: date,
                quantity: quantity,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyDetailsTable, DailyDetail>(table),
                  $$DailyDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$DailyDetailsTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$DailyDetailsTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$DailyDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyDetailsTable,
      DailyDetail,
      $$DailyDetailsTableFilterComposer,
      $$DailyDetailsTableOrderingComposer,
      $$DailyDetailsTableAnnotationComposer,
      $$DailyDetailsTableCreateCompanionBuilder,
      $$DailyDetailsTableUpdateCompanionBuilder,
      (DailyDetail, $$DailyDetailsTableReferences),
      DailyDetail,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$RateChangesTableCreateCompanionBuilder =
    RateChangesCompanion Function({
      required int vendorId,
      required String effectiveDate,
      required double quantity,
      required double rate,
      Value<int> rowid,
    });
typedef $$RateChangesTableUpdateCompanionBuilder =
    RateChangesCompanion Function({
      Value<int> vendorId,
      Value<String> effectiveDate,
      Value<double> quantity,
      Value<double> rate,
      Value<int> rowid,
    });

final class $$RateChangesTableReferences
    extends BaseReferences<_$AppDatabase, $RateChangesTable, RateChange> {
  $$RateChangesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('rate_changes__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RateChangesTableFilterComposer
    extends Composer<_$AppDatabase, $RateChangesTable> {
  $$RateChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RateChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $RateChangesTable> {
  $$RateChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RateChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RateChangesTable> {
  $$RateChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RateChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RateChangesTable,
          RateChange,
          $$RateChangesTableFilterComposer,
          $$RateChangesTableOrderingComposer,
          $$RateChangesTableAnnotationComposer,
          $$RateChangesTableCreateCompanionBuilder,
          $$RateChangesTableUpdateCompanionBuilder,
          (RateChange, $$RateChangesTableReferences),
          RateChange,
          PrefetchHooks Function({bool vendorId})
        > {
  $$RateChangesTableTableManager(_$AppDatabase db, $RateChangesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RateChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RateChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RateChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vendorId = const Value.absent(),
                Value<String> effectiveDate = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RateChangesCompanion(
                vendorId: vendorId,
                effectiveDate: effectiveDate,
                quantity: quantity,
                rate: rate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vendorId,
                required String effectiveDate,
                required double quantity,
                required double rate,
                Value<int> rowid = const Value.absent(),
              }) => RateChangesCompanion.insert(
                vendorId: vendorId,
                effectiveDate: effectiveDate,
                quantity: quantity,
                rate: rate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RateChangesTable, RateChange>(table),
                  $$RateChangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$RateChangesTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$RateChangesTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$RateChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RateChangesTable,
      RateChange,
      $$RateChangesTableFilterComposer,
      $$RateChangesTableOrderingComposer,
      $$RateChangesTableAnnotationComposer,
      $$RateChangesTableCreateCompanionBuilder,
      $$RateChangesTableUpdateCompanionBuilder,
      (RateChange, $$RateChangesTableReferences),
      RateChange,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$VendorPausesTableCreateCompanionBuilder =
    VendorPausesCompanion Function({
      Value<int> id,
      required int vendorId,
      required String startDate,
      required String endDate,
      Value<String> note,
    });
typedef $$VendorPausesTableUpdateCompanionBuilder =
    VendorPausesCompanion Function({
      Value<int> id,
      Value<int> vendorId,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> note,
    });

final class $$VendorPausesTableReferences
    extends BaseReferences<_$AppDatabase, $VendorPausesTable, VendorPause> {
  $$VendorPausesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('vendor_pauses__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VendorPausesTableFilterComposer
    extends Composer<_$AppDatabase, $VendorPausesTable> {
  $$VendorPausesTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VendorPausesTableOrderingComposer
    extends Composer<_$AppDatabase, $VendorPausesTable> {
  $$VendorPausesTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VendorPausesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VendorPausesTable> {
  $$VendorPausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VendorPausesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VendorPausesTable,
          VendorPause,
          $$VendorPausesTableFilterComposer,
          $$VendorPausesTableOrderingComposer,
          $$VendorPausesTableAnnotationComposer,
          $$VendorPausesTableCreateCompanionBuilder,
          $$VendorPausesTableUpdateCompanionBuilder,
          (VendorPause, $$VendorPausesTableReferences),
          VendorPause,
          PrefetchHooks Function({bool vendorId})
        > {
  $$VendorPausesTableTableManager(_$AppDatabase db, $VendorPausesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendorPausesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendorPausesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendorPausesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vendorId = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => VendorPausesCompanion(
                id: id,
                vendorId: vendorId,
                startDate: startDate,
                endDate: endDate,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vendorId,
                required String startDate,
                required String endDate,
                Value<String> note = const Value.absent(),
              }) => VendorPausesCompanion.insert(
                id: id,
                vendorId: vendorId,
                startDate: startDate,
                endDate: endDate,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VendorPausesTable, VendorPause>(table),
                  $$VendorPausesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$VendorPausesTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$VendorPausesTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$VendorPausesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VendorPausesTable,
      VendorPause,
      $$VendorPausesTableFilterComposer,
      $$VendorPausesTableOrderingComposer,
      $$VendorPausesTableAnnotationComposer,
      $$VendorPausesTableCreateCompanionBuilder,
      $$VendorPausesTableUpdateCompanionBuilder,
      (VendorPause, $$VendorPausesTableReferences),
      VendorPause,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      required int vendorId,
      required String date,
      required String name,
      required double quantity,
      required int unitPricePaise,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      Value<int> vendorId,
      Value<String> date,
      Value<String> name,
      Value<double> quantity,
      Value<int> unitPricePaise,
    });

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('purchases__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, $$PurchasesTableReferences),
          Purchase,
          PrefetchHooks Function({bool vendorId})
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vendorId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                vendorId: vendorId,
                date: date,
                name: name,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vendorId,
                required String date,
                required String name,
                required double quantity,
                required int unitPricePaise,
              }) => PurchasesCompanion.insert(
                id: id,
                vendorId: vendorId,
                date: date,
                name: name,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchasesTable, Purchase>(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$PurchasesTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn: $$PurchasesTableReferences
                                    ._vendorIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, $$PurchasesTableReferences),
      Purchase,
      PrefetchHooks Function({bool vendorId})
    >;
typedef $$LedgerPaymentsTableCreateCompanionBuilder =
    LedgerPaymentsCompanion Function({
      Value<int> id,
      required int vendorId,
      required String month,
      required String date,
      required int amountPaise,
      required String kind,
      Value<String> note,
    });
typedef $$LedgerPaymentsTableUpdateCompanionBuilder =
    LedgerPaymentsCompanion Function({
      Value<int> id,
      Value<int> vendorId,
      Value<String> month,
      Value<String> date,
      Value<int> amountPaise,
      Value<String> kind,
      Value<String> note,
    });

final class $$LedgerPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerPaymentsTable, LedgerPayment> {
  $$LedgerPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VendorsTable _vendorIdTable(_$AppDatabase db) =>
      db.vendors.createAlias('ledger_payments__vendor_id__vendors__id');

  $$VendorsTableProcessedTableManager get vendorId {
    final $_column = $_itemColumn<int>('vendor_id')!;

    final manager = $$VendorsTableTableManager(
      $_db,
      $_db.vendors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vendorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LedgerPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerPaymentsTable> {
  $$LedgerPaymentsTableFilterComposer({
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

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$VendorsTableFilterComposer get vendorId {
    final $$VendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableFilterComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerPaymentsTable> {
  $$LedgerPaymentsTableOrderingComposer({
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

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$VendorsTableOrderingComposer get vendorId {
    final $$VendorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableOrderingComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerPaymentsTable> {
  $$LedgerPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$VendorsTableAnnotationComposer get vendorId {
    final $$VendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vendorId,
      referencedTable: $db.vendors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.vendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerPaymentsTable,
          LedgerPayment,
          $$LedgerPaymentsTableFilterComposer,
          $$LedgerPaymentsTableOrderingComposer,
          $$LedgerPaymentsTableAnnotationComposer,
          $$LedgerPaymentsTableCreateCompanionBuilder,
          $$LedgerPaymentsTableUpdateCompanionBuilder,
          (LedgerPayment, $$LedgerPaymentsTableReferences),
          LedgerPayment,
          PrefetchHooks Function({bool vendorId})
        > {
  $$LedgerPaymentsTableTableManager(
    _$AppDatabase db,
    $LedgerPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vendorId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => LedgerPaymentsCompanion(
                id: id,
                vendorId: vendorId,
                month: month,
                date: date,
                amountPaise: amountPaise,
                kind: kind,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vendorId,
                required String month,
                required String date,
                required int amountPaise,
                required String kind,
                Value<String> note = const Value.absent(),
              }) => LedgerPaymentsCompanion.insert(
                id: id,
                vendorId: vendorId,
                month: month,
                date: date,
                amountPaise: amountPaise,
                kind: kind,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LedgerPaymentsTable, LedgerPayment>(table),
                  $$LedgerPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vendorId = false}) {
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
                    if (vendorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vendorId,
                                referencedTable: $$LedgerPaymentsTableReferences
                                    ._vendorIdTable(db),
                                referencedColumn:
                                    $$LedgerPaymentsTableReferences
                                        ._vendorIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$LedgerPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerPaymentsTable,
      LedgerPayment,
      $$LedgerPaymentsTableFilterComposer,
      $$LedgerPaymentsTableOrderingComposer,
      $$LedgerPaymentsTableAnnotationComposer,
      $$LedgerPaymentsTableCreateCompanionBuilder,
      $$LedgerPaymentsTableUpdateCompanionBuilder,
      (LedgerPayment, $$LedgerPaymentsTableReferences),
      LedgerPayment,
      PrefetchHooks Function({bool vendorId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VendorsTableTableManager get vendors =>
      $$VendorsTableTableManager(_db, _db.vendors);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
  $$MonthRatesTableTableManager get monthRates =>
      $$MonthRatesTableTableManager(_db, _db.monthRates);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$DailyDetailsTableTableManager get dailyDetails =>
      $$DailyDetailsTableTableManager(_db, _db.dailyDetails);
  $$RateChangesTableTableManager get rateChanges =>
      $$RateChangesTableTableManager(_db, _db.rateChanges);
  $$VendorPausesTableTableManager get vendorPauses =>
      $$VendorPausesTableTableManager(_db, _db.vendorPauses);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$LedgerPaymentsTableTableManager get ledgerPayments =>
      $$LedgerPaymentsTableTableManager(_db, _db.ledgerPayments);
}
