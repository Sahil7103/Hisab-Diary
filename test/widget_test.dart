import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/app/hisab_app.dart';
import 'package:hisab_diary/core/widgets/diary_button.dart';
import 'package:hisab_diary/features/today/today_repository.dart';
import 'package:hisab_diary/features/month/month_repository.dart';

void main() {
  testWidgets('Hindi shell opens and navigates without sample data', (tester) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        settingsProvider.overrideWith((ref) => Stream.value({'language': 'hi'})),
        todayVendorsProvider(day).overrideWith((ref) => Stream.value([])),
        activeVendorsProvider.overrideWith((ref) => Stream.value([])),
      ],
      child: const HisabApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('आज के लिए कोई हिसाब नहीं है'), findsNothing);
    expect(find.byType(DiaryButton), findsOneWidget);
    await tester.tap(find.byIcon(Icons.receipt_long_outlined).last);
    await tester.pumpAndSettle();
    expect(find.text('बिल बनाने के लिए पहला हिसाब जोड़िए।'),
      findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

