import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/hisab_app.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/widgets/diary_button.dart';
import 'package:hisab_diary/features/month/month_bill.dart';

void main() {
  Future<AppDatabase> openApp(WidgetTester tester, {bool vendor = false}) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.saveSetting('language', 'en');
    if (vendor) {
      await db.into(db.vendors).insert(VendorsCompanion.insert(
        type: 'milk', unit: 'litre', defaultQty: 1, rate: 60, createdAt: '2020-01-01'));
    }
    await tester.pumpWidget(ProviderScope(overrides: [databaseProvider.overrideWithValue(db)],
      child: const HisabApp()));
    await tester.pumpAndSettle();
    return db;
  }

  testWidgets('bill opens the previous full month and updates paid state', (tester) async {
    final db = await openApp(tester, vendor: true);
    await tester.tap(find.byIcon(Icons.receipt_long_outlined).last);
    await tester.pumpAndSettle();
    final paidButton = find.byWidgetPredicate((widget) =>
      widget is DiaryButton && widget.label == 'Mark as paid ✔');
    await tester.scrollUntilVisible(paidButton, 200);
    await tester.pumpAndSettle();
    await tester.tap(paidButton);
    await tester.pumpAndSettle();
    final now = DateTime.now();
    expect((await db.select(db.payments).getSingle()).month,
      diaryMonth(DateTime(now.year, now.month - 1)));
    expect(find.text('Paid ✔'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('settings apply text scale, automatic counting and language at 320dp', (tester) async {
    final db = await openApp(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined).last);
    await tester.pumpAndSettle();
    final large = find.byWidgetPredicate((widget) => widget is DiaryButton && widget.label == 'Large text');
    await tester.tap(large);
    await tester.pumpAndSettle();
    final autoLabel = find.text('Unmarked days count as came');
    await tester.scrollUntilVisible(autoLabel, 200);
    await tester.pumpAndSettle();
    await tester.tap(autoLabel);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Language'), -200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ગુજરાતી'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('સેવ કરો'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('સેવ કરો'));
    await tester.pumpAndSettle();
    final values = {for (final row in await db.select(db.settings).get()) row.key: row.value};
    expect(values['language'], 'gu');
    expect(values['textScale'], '1.2');
    expect(values['countUnmarkedAsCame'], 'false');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}

