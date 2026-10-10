import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/core/utils/date_keys.dart';
import 'package:hisab_diary/features/ledger/diary_ledger_repository.dart';
import 'package:hisab_diary/features/ledger/ledger_screen.dart';
import 'package:hisab_diary/features/ledger/ledger_widgets.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  testWidgets('ledger sections and delivery validation fit 320dp with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final month = DateTime(now.year, now.month);
    const vendor = Vendor(id: 1, type: 'milk', name: 'Neighborhood dairy deliveries',
      unit: 'litre', defaultQty: 1, rate: 60, scheduleDays: 127,
      archived: false, createdAt: '2020-01-01');
    final details = LedgerDetails(vendor: vendor,
      dailyDetails: [DailyDetail(vendorId: 1, date: diaryDate(day), quantity: 1.5,
        note: 'Extra milk for guests')],
      rates: [RateChange(vendorId: 1, effectiveDate: diaryDate(month), quantity: 1, rate: 60)],
      pauses: [VendorPause(id: 1, vendorId: 1, startDate: diaryDate(day),
        endDate: diaryDate(day), note: 'Away from home')],
      purchases: [Purchase(id: 1, vendorId: 1, date: diaryDate(day),
        name: 'Fresh vegetables for the household', quantity: 2.5, unitPricePaise: 12500)],
      payments: [LedgerPayment(id: 1, vendorId: 1, month: diaryDate(month).substring(0, 7),
        date: diaryDate(day), amountPaise: 50000, kind: 'payment', note: 'Part payment')],
      itemizedOnly: false,
      balance: const VendorBalance(monthTotalPaise: 123456700,
        monthPaidPaise: 50000, openingBalancePaise: 987654300));
    await tester.pumpWidget(ProviderScope(overrides: [
      databaseProvider.overrideWithValue(db),
      ledgerDetailsProvider((vendorId: 1, month: month))
        .overrideWith((ref) => Stream.value(details)),
    ], child: MaterialApp(locale: const Locale('en'), theme: diaryTheme('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LedgerScreen(vendorId: 1, month: month, selectedDate: day))));
    await tester.pumpAndSettle();
    expect(find.text('Vendor ledger'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Edit delivery'), 200,
      scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Edit delivery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit delivery'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '-1');
    await tester.scrollUntilVisible(find.text('Save'), 160,
      scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid number greater than zero.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Cancel'), 160,
      scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    for (final label in ['Add rate', 'Add pause', 'Add purchase', 'Add payment']) {
      await tester.scrollUntilVisible(find.text(label), 180,
        scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.byType(LedgerRecordTile), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('advance balance fits a narrow screen at large text size', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(MaterialApp(locale: const Locale('en'), theme: diaryTheme('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ListView(padding: const EdgeInsets.all(18), children: const [
        LedgerBalanceCard(balance: VendorBalance(monthTotalPaise: 150000,
          monthPaidPaise: 200000, openingBalancePaise: -10000)),
      ]))));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Advance credit available'), 120);
    expect(find.text('Advance credit available'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
