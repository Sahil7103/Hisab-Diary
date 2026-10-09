import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/widgets/diary_button.dart';
import 'package:hisab_diary/features/vendors/vendor_selector.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  testWidgets('only current vendor selected and choice updates visible selector', (tester) async {
    final vendors = [for (var id = 1; id <= 2; id++) Vendor(
      id: id, type: 'milk', name: 'Vendor $id', unit: 'litre', defaultQty: 1,
      rate: 10, scheduleDays: 127, archived: false, createdAt: '2026-10-08')];
    var selected = vendors.first;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: StatefulBuilder(builder: (context, setState) =>
        VendorSelector(vendor: selected, vendors: vendors,
          onSelectVendor: (id) => setState(() => selected = vendors.firstWhere((v) => v.id == id)))))));
    await tester.tap(find.byType(DiaryButton));
    await tester.pumpAndSettle();
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles.map((tile) => tile.selected), [true, false]);
    await tester.tap(find.widgetWithText(ListTile, 'Vendor 2'));
    await tester.pumpAndSettle();
    expect(selected.id, 2);
    expect(find.text('Vendor 2'), findsOneWidget);
    expect(find.text('Vendor 1'), findsNothing);
    await tester.tap(find.byType(DiaryButton));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListTile>(find.byType(ListTile)).map((tile) => tile.selected), [false, true]);
    await tester.tap(find.widgetWithText(ListTile, 'Vendor 2'));
    await tester.pumpAndSettle();
    expect(selected.id, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('all vendors can be selected and switched back to the same vendor', (tester) async {
    const vendor = Vendor(id: 1, type: 'milk', name: 'Ramu', unit: 'litre', defaultQty: 1,
      rate: 60, scheduleDays: 127, archived: false, createdAt: '2026-10-08');
    var allSelected = false;
    var individualSelections = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: StatefulBuilder(builder: (context, setState) =>
        VendorSelector(vendor: vendor, vendors: const [vendor], allSelected: allSelected,
          onSelectAll: () => setState(() => allSelected = true),
          onSelectVendor: (id) {
            expect(id, vendor.id);
            individualSelections++;
            setState(() => allSelected = false);
          })))));
    await tester.tap(find.byType(DiaryButton));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListTile>(find.byType(ListTile)).map((tile) => tile.selected), [false, true]);
    await tester.tap(find.widgetWithText(ListTile, 'All vendors'));
    await tester.pumpAndSettle();
    expect(allSelected, isTrue);
    expect(find.text('All vendors'), findsOneWidget);
    expect(find.text('Ramu'), findsNothing);
    await tester.tap(find.byType(DiaryButton));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListTile>(find.byType(ListTile)).map((tile) => tile.selected), [true, false]);
    await tester.tap(find.widgetWithText(ListTile, 'Ramu'));
    await tester.pumpAndSettle();
    expect(allSelected, isFalse);
    expect(individualSelections, 1);
    expect(find.text('Ramu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

}
