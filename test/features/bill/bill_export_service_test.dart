import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/all_vendors_bill.dart';
import 'package:hisab_diary/features/bill/bill_export_service.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

MonthBill row(int id, String name, {double quantity = 0.5, double rate = 62.5,
    int came = 3}) => MonthBill(
  vendor: Vendor(id: id, type: 'milk', name: name, unit: 'litre',
    defaultQty: 99, rate: 99, scheduleDays: 127, archived: false, createdAt: '2020-01-01'),
  month: DateTime(2020, 1), days: const {}, cameDays: came, notCameDays: 2,
  automaticDays: 1, quantity: quantity, rate: rate);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final service = BillExportService();
  late AppLocalizations english;
  setUpAll(() async {
    await initializeDateFormatting();
    english = await AppLocalizations.delegate.load(const Locale('en'));
    for (final family in ['NotoSansDevanagari', 'NotoSansGujarati', 'NotoSansTamil',
        'NotoSansArabic', 'NotoSansBengali', 'NotoSansTelugu', 'NotoSansKannada']) {
      final loader = FontLoader(family)..addFont(File('assets/fonts/$family.ttf')
        .readAsBytes().then(ByteData.sublistView));
      await loader.load();
    }
  });

  test('CSV retains rounded money, historical quantity and safe quoted names', () async {
    final bill = AllVendorsBill(month: DateTime(2020, 1), bills: [
      row(1, 'Ramu, "Milk"\nDelivery'), row(2, ' =HYPERLINK("unsafe")',
        quantity: 0.5, rate: 0.03, came: 1),
    ]);
    final file = await service.createExport(bill, english, BillExportFormat.csv);
    expect(file.name, 'hisab-diary-2020-01-all-vendors.csv');
    expect(file.mimeType, 'text/csv');
    expect(file.bytes.take(3), [0xef, 0xbb, 0xbf]);
    final csv = utf8.decode(file.bytes);
    expect(csv, startsWith('billing_month,vendor_name,service,unit,came_days,'
      'not_came_days,automatic_days,daily_quantity,unit_rate_inr,total_inr\r\n'));
    expect(csv, contains('2020-01,"Ramu, ""Milk""\nDelivery","Milk","litre",3,2,1,0.5,62.5,93.75\r\n'));
    expect(csv, contains('2020-01,"\' =HYPERLINK(""unsafe"")","Milk","litre",1,2,1,0.5,0.03,0.02\r\n'));
    expect(csv, endsWith('2020-01,"Monthly total",,,,,,,,93.77\r\n'));
    expect(bill.totalPaise, 9377);
  });

  test('CSV protects formula prefixes while preserving numeric values and fallback labels', () async {
    for (final name in ['=1+1', '+1', '-1', '@SUM(1)', '\tunsafe', '\runsafe', '\nunsafe', '\uFEFF=1']) {
      final file = await service.createExport(AllVendorsBill(month: DateTime(2020, 1),
        bills: [row(9, name, quantity: 2, rate: 60)]), english, BillExportFormat.csv);
      expect(utf8.decode(file.bytes), contains(',"\'$name","Milk","litre",3,2,1,2,60,360.00'));
      expect(file.name, 'hisab-diary-2020-01-vendor-9.csv');
    }
    final file = await service.createExport(AllVendorsBill(month: DateTime(2020, 1),
      bills: [row(9, '  ')]), english, BillExportFormat.csv);
    expect(utf8.decode(file.bytes), contains('2020-01,"Milk","Milk","litre"'));
  });

  testWidgets('PDF paginates long names and renders every bundled language', (tester) async {
    const names = {
      'en': 'Ramu Milk Delivery', 'hi': 'रामू दूध वितरण', 'gu': 'રામુ દૂધ વિતરણ',
      'mr': 'रामू दूध वितरण', 'ta': 'ராமு பால் விநியோகம்', 'ur': 'رامو دودھ کی ترسیل',
      'bn': 'রামু দুধ সরবরাহ', 'te': 'రాము పాల సరఫరా', 'kn': 'ರಾಮು ಹಾಲು ವಿತರಣೆ',
    };
    await tester.runAsync(() async {
      for (final entry in names.entries) {
        final strings = await AppLocalizations.delegate.load(Locale(entry.key));
        final bill = AllVendorsBill(month: DateTime(2020, 1), bills: [
          for (var id = 1; id <= 12; id++) row(id, entry.value),
          row(13, List.filled(30, entry.value).join(' ')),
        ]);
        final file = await service.createExport(bill, strings, BillExportFormat.pdf);
        expect(file.name, 'hisab-diary-2020-01-all-vendors.pdf');
        expect(file.mimeType, 'application/pdf');
        expect(ascii.decode(file.bytes.take(5).toList()), '%PDF-');
        final raw = latin1.decode(file.bytes);
        expect(RegExp(r'/Type\s*/Page\b').allMatches(raw).length, greaterThanOrEqualTo(2));
        expect(RegExp(r'/Subtype\s*/Image\b').hasMatch(raw), isTrue);
        final output = Platform.environment['BILL_EXPORT_QA_DIR'];
        if (output != null) {
          await Directory(output).create(recursive: true);
          await File('$output/bill-${entry.key}.pdf').writeAsBytes(file.bytes);
        }
      }
    });
  });
}
