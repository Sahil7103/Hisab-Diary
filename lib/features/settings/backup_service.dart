import '../../core/constants/app_languages.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' hide XFile;
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../../core/utils/billing_amounts.dart';
import '../vendors/vendor_type.dart';
import '../pro/vendor_limits.dart';

const maxBackupBytes = 10 * 1024 * 1024;
const backupSettingKeys = ['language', 'textScale', 'countUnmarkedAsCame',
  'reminderOn', 'reminderTime'];
final backupServiceProvider = Provider<BackupService>((ref) =>
  BackupService(ref.watch(databaseProvider)));

class BackupTooLargeException implements Exception {}

class DiaryBackup {
  DiaryBackup._(this.vendors, this.entries, this.monthRates, this.payments, this.settings);
  final List<Vendor> vendors;
  final List<Entry> entries;
  final List<MonthRate> monthRates;
  final List<Payment> payments;
  final Map<String, String> settings;

  factory DiaryBackup.decode(Uint8List bytes) {
    if (bytes.length > maxBackupBytes) throw BackupTooLargeException();
    final root = jsonDecode(utf8.decode(bytes));
    if (root is! Map<String, dynamic> || root['app'] != 'hisab_diary' ||
        root['version'] != 1) {
      throw const FormatException('Unsupported backup');
    }
    List<Map<String, dynamic>> rows(String key) {
      final values = root[key];
      if (values is! List || values.any((row) => row is! Map<String, dynamic>)) {
        throw const FormatException('Invalid backup rows');
      }
      return values.cast<Map<String, dynamic>>();
    }
    String text(Map<String, dynamic> row, String key) {
      final value = row[key];
      if (value is! String) throw const FormatException('Invalid text');
      return value;
    }
    int id(Map<String, dynamic> row, String key) {
      final value = row[key];
      if (value is! int || value <= 0 || value > 2147483647) {
        throw const FormatException('Invalid identifier');
      }
      return value;
    }
    double number(Map<String, dynamic> row, String key, {bool positive = false}) {
      final value = row[key];
      if (value is! num || !value.isFinite || (positive ? value <= 0 : value < 0)) {
        throw const FormatException('Invalid number');
      }
      return value.toDouble();
    }
    String date(Map<String, dynamic> row, String key) {
      final value = text(row, key);
      final parsed = DateTime.tryParse(value);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) || parsed == null ||
          parsed.year < 1 || diaryDate(parsed) != value) {
        throw const FormatException('Invalid date');
      }
      return value;
    }
    String month(Map<String, dynamic> row) {
      final value = text(row, 'month');
      date({'monthDate': '$value-01'}, 'monthDate');
      return value;
    }
    final vendors = <Vendor>[];
    final vendorIds = <int>{};
    for (final row in rows('vendors')) {
      final vendorId = id(row, 'id');
      final typeName = text(row, 'type');
      final matches = VendorType.values.where((type) => type.name == typeName);
      final schedule = row['scheduleDays'];
      if (!vendorIds.add(vendorId) || matches.isEmpty ||
          text(row, 'unit') != matches.first.unit || row['archived'] is! bool ||
          schedule is! int || schedule < 1 || schedule > 127) {
        throw const FormatException('Invalid vendor');
      }
      final quantity = number(row, 'defaultQty', positive: true);
      final rate = number(row, 'rate');
      if (!validBillAmounts(quantity, rate)) throw const FormatException('Invalid bill amounts');
      vendors.add(Vendor(id: vendorId, type: typeName, name: text(row, 'name'),
        unit: text(row, 'unit'), defaultQty: quantity,
        rate: rate, scheduleDays: schedule, archived: row['archived'] as bool,
        createdAt: date(row, 'createdAt')));
    }
    final keys = <String>{};
    int reference(Map<String, dynamic> row, String value) {
      final vendorId = id(row, 'vendorId');
      if (!vendorIds.contains(vendorId) || !keys.add('$vendorId:$value')) {
        throw const FormatException('Missing vendor or duplicate record');
      }
      return vendorId;
    }
    final entries = <Entry>[];
    for (final row in rows('entries')) {
      final day = date(row, 'date');
      final vendorId = reference(row, day);
      final status = text(row, 'status');
      if (!['came', 'notCame'].contains(status)) {
        throw const FormatException('Invalid attendance');
      }
      entries.add(Entry(vendorId: vendorId, date: day, status: status));
    }
    keys.clear();
    final rates = <MonthRate>[];
    for (final row in rows('monthRates')) {
      final value = month(row);
      final quantity = number(row, 'qty', positive: true);
      final rate = number(row, 'rate');
      if (!validBillAmounts(quantity, rate)) throw const FormatException('Invalid bill amounts');
      rates.add(MonthRate(vendorId: reference(row, value), month: value, rate: rate, qty: quantity));
    }
    keys.clear();
    final payments = <Payment>[];
    for (final row in rows('payments')) {
      final value = month(row);
      payments.add(Payment(vendorId: reference(row, value), month: value,
        paidAt: date(row, 'paidAt')));
    }
    final rawSettings = root['settings'];
    if (rawSettings is! Map<String, dynamic>) {
      throw const FormatException('Invalid settings');
    }
    final settings = <String, String>{};
    for (final entry in rawSettings.entries) {
      if (!backupSettingKeys.contains(entry.key) || entry.value is! String) {
        throw const FormatException('Invalid setting');
      }
      settings[entry.key] = entry.value as String;
    }
    if (settings.containsKey('language') &&
        !supportedLanguageCodes.contains(settings['language']) ||
        settings.containsKey('textScale') &&
        !['0.9', '1.0', '1.2'].contains(settings['textScale']) ||
        ['countUnmarkedAsCame', 'reminderOn'].any((key) => settings.containsKey(key) &&
          !['true', 'false'].contains(settings[key]))) {
      throw const FormatException('Unsupported setting');
    }
    final reminderTime = settings['reminderTime'];
    if (reminderTime != null && !RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(reminderTime)) {
      throw const FormatException('Invalid reminder time');
    }
    settings.putIfAbsent('language', () => 'hi');
    return DiaryBackup._(List.unmodifiable(vendors), List.unmodifiable(entries),
      List.unmodifiable(rates), List.unmodifiable(payments), Map.unmodifiable(settings));
  }
}

class BackupService {
  BackupService(this.database);
  final AppDatabase database;

  Future<Uint8List> exportBytes() => database.transaction(() async {
    final vendors = await database.select(database.vendors).get();
    final entries = await database.select(database.entries).get();
    final rates = await database.select(database.monthRates).get();
    final payments = await database.select(database.payments).get();
    final settings = await database.select(database.settings).get();
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode({
      'app': 'hisab_diary', 'version': 1,
      'vendors': [for (final vendor in vendors) vendor.toJson()],
      'entries': [for (final entry in entries) entry.toJson()],
      'monthRates': [for (final rate in rates) rate.toJson()],
      'payments': [for (final payment in payments) payment.toJson()],
      'settings': {for (final setting in settings)
        if (backupSettingKeys.contains(setting.key)) setting.key: setting.value},
    })));
    if (bytes.length > maxBackupBytes) throw BackupTooLargeException();
    return bytes;
  });

  Future<void> shareBackup() async {
    final bytes = await exportBytes();
    await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(bytes, mimeType: 'application/json')],
      fileNameOverrides: ['hisab-diary-backup.json']));

  }

  Future<DiaryBackup?> pickBackup() async {
    final file = await openFile(acceptedTypeGroups: [
      const XTypeGroup(extensions: ['json'], mimeTypes: ['application/json']),
    ]);
    if (file == null) return null;
    if (await file.length() > maxBackupBytes) throw BackupTooLargeException();
    return DiaryBackup.decode(await file.readAsBytes());
  }

  Future<void> restore(DiaryBackup backup) => database.transaction(() async {
    await checkVendorCapacity(database,
      restoringCount: backup.vendors.where((vendor) => !vendor.archived).length);
    await database.delete(database.entries).go();
    await database.delete(database.monthRates).go();
    await database.delete(database.payments).go();
    await database.delete(database.vendors).go();
    await (database.delete(database.settings)
      ..where((row) => row.key.isIn(backupSettingKeys))).go();
    await database.batch((batch) {
      batch.insertAll(database.vendors, [for (final row in backup.vendors) row.toCompanion(true)]);
      batch.insertAll(database.entries, [for (final row in backup.entries) row.toCompanion(true)]);
      batch.insertAll(database.monthRates, [for (final row in backup.monthRates) row.toCompanion(true)]);
      batch.insertAll(database.payments, [for (final row in backup.payments) row.toCompanion(true)]);
      batch.insertAll(database.settings, [for (final entry in backup.settings.entries)
        SettingsCompanion.insert(key: entry.key, value: entry.value)]);
    });
  });
}



