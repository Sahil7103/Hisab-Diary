import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/diary_navigation.dart';
import 'package:hisab_diary/features/help/help_assistant_overlay.dart';
import 'package:hisab_diary/features/help/help_topic.dart';
import 'package:hisab_diary/features/help/pencil_mascot.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';
import 'package:hisab_diary/features/settings/settings_repository.dart';

void main() {
  testWidgets('pencil opens help from a pushed screen and returns a guide to the root', (tester) async {
    final observer = HelpRouteObserver();
    HelpTopic? requested;
    void listen() { requested = assistantRequests.value ?? requested; }
    assistantRequests.addListener(listen);
    await tester.pumpWidget(MaterialApp(
      navigatorKey: diaryNavigatorKey, navigatorObservers: [observer],
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (_, child) => HelpAssistantOverlay(enabled: true,
        observer: observer, child: child!),
      home: const Scaffold(body: Text('Root diary')),
    ));
    await tester.pump();
    expect(find.byType(PencilMascot), findsOneWidget);
    diaryNavigatorKey.currentState!.push<void>(MaterialPageRoute(
      builder: (_) => const Scaffold(body: Text('Vendor form'))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('floatingHelpAssistant')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.byType(PencilMascot), findsNothing);
    final s = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.text(s.tutorialAddTitle));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(requested, HelpTopic.addVendor);
    expect(find.text('Root diary'), findsOneWidget);
    expect(find.text('Vendor form'), findsNothing);
    expect(find.byType(PencilMascot), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    assistantRequests.removeListener(listen);
    observer.dispose();
  });
  testWidgets('greeting completes and persists before the first tour, once only', (tester) async {
    final repository = _GreetingRepository();
    bool tourReady = false;
    late BuildContext pageContext;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        pageContext = context;
        return Scaffold(body: TextButton(onPressed: () async {
          await greetAssistantOnce(context, repository, alreadyIntroduced: false);
          tourReady = true;
        }, child: const Text('Start tour')));
      }),
    ));
    await tester.tap(find.text('Start tour'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tourReady, isFalse);
    expect(repository.saves, 0);
    expect(find.text(lookupAppLocalizations(const Locale('en')).assistantHello), findsOneWidget);
    expect(tester.widget<PencilMascot>(find.byType(PencilMascot)).waving, isTrue);
    await tester.tap(find.text(lookupAppLocalizations(const Locale('en')).continueLabel));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tourReady, isTrue);
    expect(repository.saves, 1);
    await greetAssistantOnce(pageContext, repository, alreadyIntroduced: false);
    await tester.pump();
    expect(repository.saves, 1);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

}

class _GreetingRepository extends Fake implements SettingsRepository {
  int saves = 0;
  @override
  Future<void> markAssistantIntroduced() async { saves++; }
}
