import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/core/widgets/diary_tutorial.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  Future<void> openTutorial(WidgetTester tester) async {
    final target = GlobalKey();
    await tester.pumpWidget(MaterialApp(theme: diaryTheme('en'),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Builder(builder: (context) => Center(
        child: TextButton(key: target, child: const Text('Open'), onPressed: () {
          showGeneralDialog<void>(context: context, pageBuilder: (_, _, _) => DiaryTutorial(steps: [
            DiaryTutorialStep(target: target, title: 'First step', body: 'First instruction'),
            DiaryTutorialStep(target: target, title: 'Second step', body: 'Second instruction'),
          ]));
        }))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('walkthrough advances and finishes without removing home', (tester) async {
    await openTutorial(tester);
    expect(find.text('First step'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Second step'), findsOneWidget);
    await tester.tap(find.text('Start using my diary'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryTutorial), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('skip closes the walkthrough immediately', (tester) async {
    await openTutorial(tester);
    await tester.tap(find.text('Skip tutorial'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryTutorial), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });
}
