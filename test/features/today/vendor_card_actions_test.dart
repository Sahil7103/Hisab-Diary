import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/today/today_repository.dart';
import 'package:hisab_diary/features/today/vendor_card.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  testWidgets('card menu dispatches edit and delete without opening the calendar or marking attendance',
    (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var edits = 0;
    var deletes = 0;
    var opens = 0;
    var marks = 0;
    const vendor = Vendor(id: 1, type: 'milk', name: 'Corner dairy', unit: 'litre',
      defaultQty: 1, rate: 60, scheduleDays: 127, archived: false, createdAt: '2020-01-01');
    await tester.pumpWidget(MaterialApp(theme: diaryTheme('en'), locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ListView(padding: const EdgeInsets.all(18), children: [
        VendorCard(record: const TodayVendor(vendor, Attendance.came), busy: false,
          onOpen: () => opens++, onMark: (_) => marks++,
          onEdit: () => edits++, onDelete: () => deletes++),
      ]))));
    final strings = lookupAppLocalizations(const Locale('en'));
    final menu = find.byType(PopupMenuButton<int>);
    await tester.tap(menu);
    await tester.pumpAndSettle();
    expect(find.text(strings.editVendor), findsOneWidget);
    expect(find.text(strings.deleteVendor), findsOneWidget);
    await tester.tap(find.text(strings.editVendor));
    await tester.pumpAndSettle();
    expect(edits, 1);
    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.deleteVendor));
    await tester.pumpAndSettle();
    expect(deletes, 1);
    expect(opens, 0);
    expect(marks, 0);
    expect(tester.takeException(), isNull);
  });
}
