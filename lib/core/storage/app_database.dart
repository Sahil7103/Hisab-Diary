import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart';

class Vendors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get unit => text()();
  RealColumn get defaultQty => real()();
  RealColumn get rate => real()();
  IntColumn get scheduleDays => integer().withDefault(const Constant(127))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  @override
  List<String> get customConstraints => [
    'CHECK (default_qty > 0)', 'CHECK (rate >= 0)',
    'CHECK (schedule_days BETWEEN 1 AND 127)',
  ];
}
class Entries extends Table {
  IntColumn get vendorId => integer().references(Vendors, #id)();
  TextColumn get date => text()();
  TextColumn get status => text()();
  @override
  List<String> get customConstraints => [
    "CHECK (status IN ('came', 'notCame'))",
  ];
  @override
  Set<Column> get primaryKey => {vendorId, date};
}
class MonthRates extends Table {
  IntColumn get vendorId => integer().references(Vendors, #id)();
  TextColumn get month => text()();
  RealColumn get rate => real()();
  RealColumn get qty => real()();
  @override
  List<String> get customConstraints => ['CHECK (rate >= 0)', 'CHECK (qty > 0)'];
  @override
  Set<Column> get primaryKey => {vendorId, month};
}
class Payments extends Table {
  IntColumn get vendorId => integer().references(Vendors, #id)();
  TextColumn get month => text()();
  TextColumn get paidAt => text()();
  @override
  Set<Column> get primaryKey => {vendorId, month};
}
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}
@DriftDatabase(tables: [Vendors, Entries, MonthRates, Payments, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'hisab_diary'));
  AppDatabase.forTesting(super.executor);
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'),
  );
  Stream<Map<String, String>> watchSettings() => select(settings).watch().map(
    (rows) => {for (final row in rows) row.key: row.value},
  );
  Future<void> saveSetting(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }
}
