import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/app_database.dart';

class Household {
  const Household(this.id, this.name);
  final String id;
  final String name;
  String get databaseName => id == 'home' ? 'hisab_diary' : 'hisab_diary_household_$id';
}
class HouseholdState {
  const HouseholdState({this.households = const [Household('home', 'My home')],
    this.selectedId = 'home', this.loading = true, this.error = false});
  final List<Household> households;
  final String selectedId;
  final bool loading;
  final bool error;
  Household get selected => households.firstWhere((row) => row.id == selectedId);
}
final householdControllerProvider = NotifierProvider<HouseholdController, HouseholdState>(HouseholdController.new);
class HouseholdController extends Notifier<HouseholdState> {
  late AppDatabase _catalog;
  Future<void> _work = Future.value();
  @override
  HouseholdState build() {
    _catalog = AppDatabase(name: 'hisab_diary_device');
    ref.onDispose(() => unawaited(_catalog.close()));
    unawaited(load());
    return const HouseholdState();
  }
  Future<void> load() async {
    try {
      final rows = await _catalog.select(_catalog.settings).get();
      final settings = {for (final row in rows) row.key: row.value};
      final raw = settings['households'];
      final parsed = raw == null ? null : jsonDecode(raw);
      final households = <Household>[];
      final ids = <String>{};
      if (parsed != null) {
        if (parsed is! List || parsed.isEmpty) throw const FormatException('Invalid household catalog');
        for (final row in parsed) {
          if (row is! Map || row['id'] is! String || row['name'] is! String) {
            throw const FormatException('Invalid household');
          }
          final id = row['id'] as String;
          final name = row['name'] as String;
          if (!RegExp(r'^[a-z0-9]{1,40}$').hasMatch(id) || !ids.add(id) ||
              name.trim().isEmpty || name.length > 50) throw const FormatException('Invalid household');
          households.add(Household(id,name));
        }
      } else {
        households.add(const Household('home','My home'));
      }
      final selected = settings['selectedHousehold'] ?? 'home';
      if (!households.any((row) => row.id == selected)) throw const FormatException('Missing selected household');
      state = HouseholdState(households: List.unmodifiable(households), selectedId: selected, loading: false);
    } catch (_) {
      state = const HouseholdState(loading: false, error: true);
    }
  }
  Future<void> _serialize(Future<void> Function() action) {
    final next = _work.then((_) => action());
    _work = next.catchError((Object _) {});
    return next;
  }
  Future<void> select(String id) => _serialize(() async {
    if (state.loading || state.error || !state.households.any((row) => row.id == id)) {
      throw StateError('Household unavailable');
    }
    await _catalog.saveSetting('selectedHousehold', id);
    state = HouseholdState(households: state.households, selectedId: id, loading: false);
  });
  Future<void> rename(String id, String name) => _serialize(() async {
    final value = _name(name);
    if (state.error || !state.households.any((row) => row.id == id)) throw StateError('Household unavailable');
    final households = [for (final row in state.households) row.id == id ? Household(id,value) : row];
    await _save(households, state.selectedId);
    state = HouseholdState(households: List.unmodifiable(households), selectedId: state.selectedId, loading: false);
  });
  String _name(String name) {
    final value = name.trim();
    if (value.isEmpty || value.length > 50) throw ArgumentError('Invalid household name');
    return value;
  }
  Future<void> add(String name, {Map<String,String> preferences = const {}}) => _serialize(() async {
    if (state.loading || state.error) throw StateError('Household unavailable');
    final value = _name(name);
    final random = Random.secure();
    final id = '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}${random.nextInt(0x7fffffff).toRadixString(36)}';
    final household = Household(id,value);
    final db = AppDatabase(name: household.databaseName);
    try {
      await db.batch((batch) => batch.insertAll(db.settings, [for (final entry in preferences.entries)
        if (entry.key == 'language' || entry.key == 'textScale' || entry.key.startsWith('tutorial'))
          SettingsCompanion.insert(key: entry.key,value:entry.value)]));
    } finally { await db.close(); }
    final households = [...state.households, household];
    await _save(households,id);
    state = HouseholdState(households: List.unmodifiable(households), selectedId: id, loading: false);
  });
  Future<void> _save(List<Household> households,String selected) => _catalog.transaction(() async {
    await _catalog.saveSetting('households',jsonEncode([for(final row in households) {'id':row.id,'name':row.name}]));
    await _catalog.saveSetting('selectedHousehold',selected);
  });
}
