import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/services/diary_usage_analytics.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/today/today_repository.dart';
import 'package:hisab_diary/features/month/month_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_type.dart';

void main() {
  late AppDatabase database;
  late DateTime now;
  late List<({String name, Map<String, Object> parameters})> events;
  late DiaryUsageAnalytics analytics;
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    now = DateTime(2026, 10, 9);
    events = [];
    analytics = DiaryUsageAnalytics(database, now: () => now,
      enabled: () => true, send: (name, parameters) async {
        events.add((name: name, parameters: parameters));
      });
  });
  tearDown(() => database.close());
  int count(String name) => events.where((event) => event.name == name).length;
  Future<int> vendor() => VendorRepository(database, analytics: analytics).create(
    type: VendorType.milk, name: 'Private vendor', quantity: 1, rate: 60,
    scheduleDays: 127);

  test('milestones persist across instances and concurrent vendor saves', () async {
    await analytics.initialize();
    await Future.wait([vendor(), vendor()]);
    expect(count('vendor_added'), 2);
    expect(count('first_vendor_added'), 1);
    final restarted = DiaryUsageAnalytics(database, now: () => now,
      enabled: () => true, send: (name, parameters) async {
        events.add((name: name, parameters: parameters));
      });
    await restarted.vendorAdded();
    expect(count('first_vendor_added'), 1);
    expect(events.every((event) => event.parameters.isEmpty), isTrue);
  });

  test('undo, repeated bulk and failed saves never inflate marks', () async {
    final id = await vendor();
    final today = TodayRepository(database, analytics: analytics);
    await today.toggle(id, now, Attendance.came);
    await today.toggle(id, now, Attendance.came);
    expect(count('delivery_marked'), 1);
    await today.markAllCame(now, source: DeliverySource.reminder);
    await today.markAllCame(now, source: DeliverySource.reminder);
    expect(count('delivery_marked'), 2);
    expect(count('all_came_completed'), 1);
    expect(count('first_delivery_marked'), 1);
    expect(events.last.parameters, {
      'source': 'reminder', 'action': 'came', 'mode': 'bulk'});
    await expectLater(today.toggle(-1, now, Attendance.came), throwsA(anything));
    expect(count('delivery_marked'), 2);
    await MonthRepository(database, analytics: analytics).toggleDay(id, now);
    expect(count('delivery_marked'), 3);
    expect(events.last.parameters['source'], 'month');
    expect(events.last.parameters['action'], 'not_came');
  });

  test('three usage days, not three backfilled dates, earn week milestone once', () async {
    await analytics.initialize();
    final id = await vendor();
    final month = MonthRepository(database, analytics: analytics);
    for (var day = 1; day <= 3; day++) {
      await month.toggleDay(id, DateTime(2026, 10, day));
    }
    expect(count('first_week_three_days'), 0);
    now = DateTime(2026, 10, 10);
    await analytics.deliveryMarked(source: DeliverySource.today, came: true);
    expect(count('first_week_three_days'), 0);
    now = DateTime(2026, 10, 15);
    await analytics.deliveryMarked(source: DeliverySource.today, came: false);
    await analytics.deliveryMarked(source: DeliverySource.today, came: true);
    expect(count('first_week_three_days'), 1);
  });

  test('the eighth calendar day is outside the first week', () async {
    await analytics.initialize();
    await analytics.deliveryMarked(source: DeliverySource.today, came: true);
    now = DateTime(2026, 10, 10);
    await analytics.deliveryMarked(source: DeliverySource.today, came: true);
    now = DateTime(2026, 10, 16);
    await analytics.deliveryMarked(source: DeliverySource.today, came: true);
    expect(count('first_week_three_days'), 0);
  });

  test('disabled telemetry stores no flags and a failing sink preserves saves', () async {
    final disabled = DiaryUsageAnalytics(database, enabled: () => false);
    await disabled.vendorAdded();
    expect(await database.select(database.settings).get(), isEmpty);
    final failing = DiaryUsageAnalytics(database, enabled: () => true,
      send: (_, _) async => throw StateError('offline'));
    final id = await VendorRepository(database, analytics: failing).create(
      type: VendorType.milk, name: '', quantity: 1, rate: 60, scheduleDays: 127);
    await TodayRepository(database, analytics: failing)
      .toggle(id, now, Attendance.came);
    expect((await database.select(database.entries).get()).single.status, 'came');
  });
}
