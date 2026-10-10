import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/app_database.dart';
import '../features/households/household_controller.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final household = ref.watch(householdControllerProvider.select((state) => state.selectedId));
  final database = ref.watch(householdDatabaseFactoryProvider)(household == 'home' ? 'hisab_diary' : 'hisab_diary_household_$household');
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
final settingsProvider = StreamProvider<Map<String, String>>((ref) {
  return ref.watch(databaseProvider).watchSettings();
});
