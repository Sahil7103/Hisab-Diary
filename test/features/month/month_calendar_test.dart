import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/utils/date_keys.dart';
import 'package:hisab_diary/features/month/calendar_day.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/features/month/month_screen.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  testWidgets('calendar marks today and disables future months at 320dp with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    final id = await db.into(db.vendors).insert(VendorsCompanion.insert(
      type: 'milk', unit: 'litre', defaultQty: 1, rate: 60, createdAt: diaryDate(month)));
    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp(locale: const Locale('en'), theme: diaryTheme('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MonthScreen(selectedVendorId: id,
          onSelectVendor: (_) {}, onBack: () {}))),
    ));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byWidgetPredicate(
      (widget) => widget is CalendarDay && widget.number == '1'), 160,
      scrollable: find.byType(Scrollable).first);
    expect(find.byType(CalendarDay), findsNWidgets(daysInMonth(month)));
    final today = find.byWidgetPredicate((widget) => widget is CalendarDay && widget.isToday);
    await Scrollable.ensureVisible(tester.element(today), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(today);
    await tester.pumpAndSettle();
    final entry = await db.select(db.entries).getSingle();
    expect(entry.date, diaryDate(now));
    expect(entry.status, 'came');
    await tester.scrollUntilVisible(find.byTooltip('Next month'), -200,
      scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
    for (final day in tester.widgetList<CalendarDay>(find.byType(CalendarDay))) {
      expect(day.onPressed, isNull);
      expect(day.attendance, DayAttendance.disabled);
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}



