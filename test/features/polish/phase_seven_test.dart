import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/hisab_app.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/widgets/diary_button.dart';
import 'package:hisab_diary/features/month/calendar_day.dart';
import 'package:hisab_diary/features/vendors/vendor_type_screen.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  Future<AppDatabase> open(WidgetTester tester, {String language = 'en',
      int? schedule, bool large = false}) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    if (large) {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.saveSetting('language', language);
    await db.saveSetting('textScale', large ? '1.2' : '1.0');
    if (schedule != null) {
      await db.into(db.vendors).insert(VendorsCompanion.insert(
      type: 'milk', name: const Value('A long household delivery name'),
      unit: 'litre', defaultQty: 1, rate: 60,
        scheduleDays: Value(schedule), createdAt: '2020-01-01'));
    }
    await tester.pumpWidget(ProviderScope(overrides: [databaseProvider.overrideWithValue(db)],
      child: const HisabApp()));
    await tester.pumpAndSettle();
    return db;
  }
  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }
  testWidgets('empty Today has one first-account action', (tester) async {
    await open(tester);
    expect(find.byType(DiaryButton), findsOneWidget);
    expect(find.text('No deliveries scheduled today'), findsNothing);
    expect(tester.takeException(), isNull);
    await close(tester);
  });
  testWidgets('off-schedule accounts do not look like a new diary', (tester) async {
    final tomorrow = DateTime.now().weekday % 7;
    await open(tester, schedule: 1 << tomorrow);
    final context = tester.element(find.byType(DiaryButton).first);
    final strings = AppLocalizations.of(context)!;
    expect(find.text(strings.noDeliveries), findsOneWidget);
    expect(find.text(strings.addNew), findsOneWidget);
    expect(find.text(strings.addFirst), findsNothing);
    await close(tester);
  });
  for (final language in ['hi', 'en', 'gu', 'mr']) {
    testWidgets('$language supports labelled tabs and 2.4x text at 320dp', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await open(tester, language: language, schedule: 127, large: true);
        final strings = await AppLocalizations.delegate.load(Locale(language));
        final monthTab = find.bySemanticsLabel(strings.month);
        expect(tester.getSemantics(monthTab).rect.height, greaterThanOrEqualTo(64));
        await tester.tap(monthTab);
        await tester.pumpAndSettle();
        final firstDay = find.byWidgetPredicate((widget) => widget is CalendarDay && widget.number == NumberFormat.decimalPattern(language).format(1));
        await tester.scrollUntilVisible(firstDay, 240,
          scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(tester.getSize(firstDay).width, greaterThan(60));
        expect(tester.takeException(), isNull);
        await tester.tap(find.bySemanticsLabel(strings.bill));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.bySemanticsLabel(strings.settings));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.bySemanticsLabel(strings.today).last);
        await tester.pumpAndSettle();
        final add = find.byWidgetPredicate((widget) => widget is DiaryButton && widget.label == strings.addNew);
        await tester.scrollUntilVisible(add, 240, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await tester.tap(add);
        await tester.pumpAndSettle();
        expect(find.byType(VendorTypeScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
        await close(tester);
      } finally {
        semantics.dispose();
      }
    });
  }
}

