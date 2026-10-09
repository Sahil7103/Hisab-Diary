import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/features/bill/bill_export_service.dart';
import 'package:hisab_diary/core/widgets/diary_button.dart';
import 'package:hisab_diary/features/bill/bill_share_actions.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  testWidgets('sharing choices dispatch formats and disable while busy', (tester) async {
    final choices = <BillExportFormat>[];
    var textShares = 0;
    final textShareKey = GlobalKey();
    Future<void> show(bool busy) => tester.pumpWidget(MaterialApp(
      locale: const Locale('en'), theme: diaryTheme('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: BillShareActions(busy: busy, textShareKey: textShareKey,
        onShareText: () => textShares++, onShareExport: choices.add)))));
    await show(false);
    expect(tester.widget<DiaryButton>(find.byKey(textShareKey)).label, 'Share on WhatsApp');
    await tester.tap(find.text('Share PDF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share CSV'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share on WhatsApp'));
    await tester.pumpAndSettle();
    expect(choices, [BillExportFormat.pdf, BillExportFormat.csv]);
    expect(textShares, 1);
    await show(true);
    await tester.tap(find.text('Share PDF'));
    await tester.pump();
    expect(choices, hasLength(2));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('export actions fit a narrow layout with large localized text', (tester) async {
    tester.view.physicalSize = const Size(320, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final language in ['en', 'ur', 'ta']) {
      await tester.pumpWidget(MaterialApp(locale: Locale(language), theme: diaryTheme(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.8)), child: child!),
        home: Scaffold(body: SingleChildScrollView(padding: const EdgeInsets.all(18),
          child: BillShareActions(busy: false, onShareText: () {}, onShareExport: (_) {})))));
      await tester.pumpAndSettle();
      final strings = await AppLocalizations.delegate.load(Locale(language));
      expect(find.text(strings.sharePdf), findsOneWidget);
      expect(find.text(strings.shareCsv), findsOneWidget);
      expect(tester.takeException(), isNull, reason: language);
    }
  });
}
