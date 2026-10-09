import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/services/app_telemetry.dart';

void main() {
  test('disabled monitoring preserves action result and runs once', () async {
    var calls = 0;
    final result = await AppTelemetry.measure('vendor_save', () async {
      calls++;
      return 42;
    });
    expect(result, 42);
    expect(calls, 1);
  });

  test('monitoring preserves the original operation failure', () async {
    final failure = StateError('local failure');
    await expectLater(AppTelemetry.measure<void>('bill_share', () async {
      throw failure;
    }), throwsA(same(failure)));
  });
}
