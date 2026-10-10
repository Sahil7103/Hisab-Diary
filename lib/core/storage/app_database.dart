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
class DailyDetails extends Table {
  IntColumn get vendorId => integer().references(Vendors, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {vendorId, date};
  @override
  List<String> get customConstraints => ['CHECK (quantity IS NULL OR quantity > 0)'];
}
class RateChanges extends Table {
  IntColumn get vendorId => integer().references(Vendors, #id, onDelete: KeyAction.cascade)();
  TextColumn get effectiveDate => text()();
  RealColumn get quantity => real()();
  RealColumn get rate => real()();
  @override
  Set<Column> get primaryKey => {vendorId, effectiveDate};
  @override
  List<String> get customConstraints => ['CHECK (quantity > 0)', 'CHECK (rate >= 0)'];
}
class VendorPauses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vendorId => integer().references(Vendors, #id, onDelete: KeyAction.cascade)();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  @override
  List<String> get customConstraints => ['CHECK (start_date <= end_date)'];
}
class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vendorId => integer().references(Vendors, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  IntColumn get unitPricePaise => integer()();
  @override
  List<String> get customConstraints => ['CHECK (quantity > 0)', 'CHECK (unit_price_paise >= 0)'];
}
class LedgerPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vendorId => integer().references(Vendors, #id, onDelete: KeyAction.cascade)();
  TextColumn get month => text()();
  TextColumn get date => text()();
  IntColumn get amountPaise => integer()();
  TextColumn get kind => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  @override
  List<String> get customConstraints => ['CHECK (amount_paise > 0)', "CHECK (kind IN ('payment', 'advance'))"];
}

@DriftDatabase(tables: [Vendors, Entries, MonthRates, Payments, Settings,
  DailyDetails, RateChanges, VendorPauses, Purchases, LedgerPayments])
class AppDatabase extends _$AppDatabase {
  AppDatabase({String name = 'hisab_diary'}) : super(driftDatabase(name: name, native: const DriftNativeOptions(shareAcrossIsolates: true)));
  AppDatabase.forTesting(super.executor);
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(dailyDetails);
        await migrator.createTable(rateChanges);
        await migrator.createTable(vendorPauses);
        await migrator.createTable(purchases);
        await migrator.createTable(ledgerPayments);
      }
    },
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
