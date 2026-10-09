import 'dart:convert';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/settings/backup_service.dart';
import 'package:hisab_diary/features/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  late BackupService service;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = BackupService(db);
  });
  tearDown(() => db.close());

  Future<void> seed() async {
    final id = await db.into(db.vendors).insert(VendorsCompanion.insert(type: 'milk',
      name: const Value('Ramu'), unit: 'litre', defaultQty: 0.5, rate: 60,
      createdAt: '2020-01-01'));
    await db.into(db.entries).insert(EntriesCompanion.insert(vendorId: id,
      date: '2020-01-02', status: 'came'));
    await db.into(db.monthRates).insert(MonthRatesCompanion.insert(vendorId: id,
      month: '2020-01', rate: 60, qty: 0.5));
    await db.into(db.payments).insert(PaymentsCompanion.insert(vendorId: id,
      month: '2020-01', paidAt: '2020-02-01'));
    await db.saveSetting('language', 'gu');
    await db.saveSetting('textScale', '1.2');
    await db.saveSetting('countUnmarkedAsCame', 'false');
  }
  Uint8List encode(Object data) => Uint8List.fromList(utf8.encode(jsonEncode(data)));

  test('backup restores every data table and settings without duplicating records', () async {
    await seed();
    final bytes = await service.exportBytes();
    final backup = DiaryBackup.decode(bytes);
    expect(backup.vendors.single.defaultQty, 0.5);
    await db.into(db.vendors).insert(VendorsCompanion.insert(type: 'maid',
      unit: 'visit', defaultQty: 1, rate: 0, createdAt: '2020-01-01'));
    await db.saveSetting('language', 'en');
    await db.saveSetting('deviceOnly', 'retain');
    await service.restore(backup);
    await service.restore(backup);
    expect(jsonDecode(utf8.decode(await service.exportBytes())),
      jsonDecode(utf8.decode(bytes)));
    expect((await db.select(db.settings).get()).any((row) =>
      row.key == 'deviceOnly' && row.value == 'retain'), isTrue);
  });

  test('malformed backup versions, references, dates, schedules and numbers are rejected', () async {
    await seed();
    final bytes = await service.exportBytes();
    final original = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final mutations = <void Function(Map<String, dynamic>)>[
      (root) => root['version'] = 2,
      (root) => root['app'] = 'another_app',
      (root) => root['entries'][0]['vendorId'] = 999,
      (root) => root['entries'][0]['status'] = 'invalid',
      (root) => root['entries'][0]['date'] = '2020-02-30',
      (root) => root['monthRates'][0]['month'] = '2020-13',
      (root) => root['vendors'][0]['scheduleDays'] = 0,
      (root) => root['vendors'][0]['defaultQty'] = -1,
      (root) => root['vendors'][0]['rate'] = 1e308,
      (root) => root['vendors'][0]['unit'] = 'visit',
      (root) => root['settings']['language'] = 'xx',
      (root) => root['settings']['reminderTime'] = '25:99',
      (root) => root['entries'].add(root['entries'][0]),
      (root) => root['vendors'].add(root['vendors'][0]),
    ];
    for (final mutate in mutations) {
      final changed = jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
      mutate(changed);
      expect(() => DiaryBackup.decode(encode(changed)), throwsFormatException);
    }
    expect(await service.exportBytes(), bytes);
    expect(() => DiaryBackup.decode(Uint8List(maxBackupBytes + 1)),
      throwsA(isA<BackupTooLargeException>()));
  });

  test('failed restore rolls back deletion of existing vendors, marks, payments and settings', () async {
    await seed();
    final before = await service.exportBytes();
    final backup = DiaryBackup.decode(before);
    await db.customStatement("CREATE TRIGGER fail_restore BEFORE INSERT ON vendors "
      "BEGIN SELECT RAISE(ABORT, 'restore failed'); END;");
    await expectLater(service.restore(backup), throwsA(anything));
    expect(await service.exportBytes(), before);
  });

  test('settings use typed valid choices and preserve other settings', () async {
    final repository = SettingsRepository(db);
    await repository.setLanguage('mr');
    await repository.setTextScale(0.9);
    await repository.setCountUnmarked(false);
    final values = {for (final row in await db.select(db.settings).get()) row.key: row.value};
    expect(values, {'language': 'mr', 'textScale': '0.9', 'countUnmarkedAsCame': 'false'});
    expect(() => repository.setTextScale(2), throwsArgumentError);
    expect(() => repository.setLanguage('xx'), throwsArgumentError);
  });
}

