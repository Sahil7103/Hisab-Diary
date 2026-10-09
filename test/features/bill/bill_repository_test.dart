import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/bill_message.dart';
import 'package:hisab_diary/features/bill/bill_repository.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/features/today/today_repository.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  setUpAll(() => initializeDateFormatting());
  test('bill message uses actual month quantity, days and total in all languages', () async {
    const vendor = Vendor(id: 1, type: 'milk', name: 'Ramu', unit: 'litre',
      defaultQty: 1, rate: 80, scheduleDays: 127, archived: false, createdAt: '2026-07-01');
    final bill = calculateMonthBill(vendor: vendor, month: DateTime(2026, 7),
      now: DateTime(2026, 8, 1), countUnmarkedAsCame: false,
      entries: {'2026-07-01': Attendance.came, '2026-07-02': Attendance.came},
      monthRate: const MonthRate(vendorId: 1, month: '2026-07', qty: 0.5, rate: 62.5));
    for (final locale in ['hi', 'en', 'gu', 'mr']) {
      final strings = await AppLocalizations.delegate.load(Locale(locale));
      final message = billShareMessage(bill, strings);
      expect(message, contains('${strings.shareVendorName}: Ramu'));
      expect(message, contains('${strings.shareBillingMonth}:'));
      expect(message, contains('${strings.shareService}:'));
      expect(message, contains('${strings.shareCalculation}:'));
      expect(message, contains('${strings.shareDailyQuantity}:'));
      expect(message, contains(locale == 'mr' ? '६२.५०' : '62.50'));
      expect(message, contains(locale == 'mr' ? '०.५' : '0.5'));
      expect(message, contains(locale == 'mr' ? '२०२६' : '2026'));
      expect(message, contains(strings.appName));
      expect(message, startsWith('*${strings.bill}*\n'));
      expect(message, contains('*${strings.shareTotalAmount}: ${billTotalLabel(bill, locale)}*'));
      expect(message, contains(strings.cameCount(locale == 'mr' ? '\u0968' : '2')));
      expect(message, contains('\n\n'));
      expect(message, contains('https://play.google.com/store/apps/details?id=com.trevio.hisabdiary'));
      expect(message, isNot(contains('Play Store: [')));
      expect(message, isNot(contains('{total}')));
    }
  });
  test('paid state is idempotent and isolated per vendor and month', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    Future<int> vendor() => db.into(db.vendors).insert(VendorsCompanion.insert(
      type: 'milk', unit: 'litre', defaultQty: 1, rate: 60, createdAt: '2020-01-01'));
    final first = await vendor();
    final second = await vendor();
    final repository = BillRepository(db);
    await repository.markPaid(first, DateTime(2020, 1));
    await repository.markPaid(first, DateTime(2020, 1));
    await repository.markPaid(second, DateTime(2020, 2));
    final payments = await db.select(db.payments).get();
    expect(payments, hasLength(2));
    expect(payments.any((row) => row.vendorId == first && row.month == '2020-01'), isTrue);
    expect(payments.any((row) => row.vendorId == second && row.month == '2020-01'), isFalse);
    final now = DateTime.now();
    await expectLater(repository.markPaid(first, DateTime(now.year, now.month + 1)),
      throwsArgumentError);
    expect(await db.select(db.payments).get(), hasLength(2));
  });
}

