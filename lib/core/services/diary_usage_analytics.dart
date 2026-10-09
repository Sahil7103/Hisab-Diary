import 'package:drift/drift.dart';
import '../storage/app_database.dart';
import '../utils/date_keys.dart';
import 'app_telemetry.dart';

enum DeliverySource { today, month, reminder }

/// Only fixed action labels leave the device; milestone dates stay local.
class DiaryUsageAnalytics {
  DiaryUsageAnalytics(this.database, {DateTime Function()? now,
    bool Function()? enabled,
    Future<void> Function(String, Map<String, Object>)? send})
      : _now = now ?? DateTime.now,
        _enabled = enabled ?? (() => AppTelemetry.enabled),
        _send = send ?? ((name, parameters) =>
          AppTelemetry.trackEvent(name, parameters: parameters));

  final AppDatabase database;
  final DateTime Function() _now;
  final bool Function() _enabled;
  final Future<void> Function(String, Map<String, Object>) _send;
  static const _prefix = 'usageAnalytics_';

  Future<void> initialize() => _record();
  Future<void> vendorAdded() => _record(vendor: true);
  Future<void> deliveryMarked({required DeliverySource source,
      required bool came, int count = 1, bool bulk = false}) =>
    _record(source: source, came: came, count: count, bulk: bulk);

  Future<void> _record({bool vendor = false, DeliverySource? source,
      bool came = false, int count = 1, bool bulk = false}) async {
    if (!_enabled() || count < 1) return;
    try {
      final today = diaryDate(_now());
      final events = await database.transaction(() async {
        final rows = await (database.select(database.settings)
          ..where((row) => row.key.like('$_prefix%'))).get();
        final settings = {for (final row in rows) row.key: row.value};
        final events = <String>[];
        Future<void> first(String event) async {
          final key = '$_prefix$event';
          if (settings[key] == 'true') return;
          await database.saveSetting(key, 'true');
          events.add(event);
        }
        final openedKey = '${_prefix}firstOpened';
        final opened = settings[openedKey] ?? today;
        if (!settings.containsKey(openedKey)) {
          await database.saveSetting(openedKey, opened);
        }
        if (vendor) {
          events.add('vendor_added');
          await first('first_vendor_added');
        }
        if (source != null) {
          await first('first_delivery_marked');
          final start = DateTime.parse('${opened}T00:00:00Z');
          final current = DateTime.parse('${today}T00:00:00Z');
          final elapsed = current.difference(start).inDays;
          if (elapsed >= 0 && elapsed < 7) {
            final daysKey = '${_prefix}markingDays';
            final days = (settings[daysKey] ?? '').split(',')
              .where((day) => day.isNotEmpty).toSet()..add(today);
            await database.saveSetting(daysKey, days.join(','));
            if (days.length >= 3) await first('first_week_three_days');
          }
        }
        return events;
      });
      for (final event in events) {
        await _send(event, const {});
      }
      if (source != null) {
        final parameters = <String, Object>{
          'source': source.name,
          'action': came ? 'came' : 'not_came',
          'mode': bulk ? 'bulk' : 'single',
        };
        for (var i = 0; i < count; i++) {
          await _send('delivery_marked', parameters);
        }
        if (bulk) await _send('all_came_completed', parameters);
      }
    } catch (error, stack) {
      AppTelemetry.report(error, stack, operation: 'usage_analytics');
    }
  }
}
