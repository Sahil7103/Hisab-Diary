import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/hisab_app.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';
import 'package:hisab_diary/features/month/month_repository.dart';
import 'package:hisab_diary/features/shell/diary_shell.dart';
import 'package:hisab_diary/features/splash/splash_screen.dart';
import 'package:hisab_diary/features/today/today_repository.dart';

void main() {
  testWidgets('reduced motion completes splash without animated loading', (tester) async {
    var completed = false;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(data: const MediaQueryData(disableAnimations: true),
        child: SplashScreen(onComplete: () => completed = true))));
    await tester.pump();
    expect(completed, true);
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, 1);
    expect(tester.takeException(), isNull);
  });
  testWidgets('splash hands off when settings arrive and storage failure remains retryable', (tester) async {
    final settings = StreamController<Map<String, String>>();
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    await tester.pumpWidget(ProviderScope(overrides: [
      settingsProvider.overrideWith((ref) => settings.stream),
      activeVendorsProvider.overrideWith((ref) => Stream.value([])),
      todayVendorsProvider(day).overrideWith((ref) => Stream.value([])),
    ], child: const HisabApp()));
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    settings.add({'language': 'en'});
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(DiaryShell), findsOneWidget);
    settings.addError(StateError('Storage unavailable'));
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(tester.widget<DiaryShell>(find.byType(DiaryShell)).storageError, true);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    unawaited(settings.close());
  });
}


