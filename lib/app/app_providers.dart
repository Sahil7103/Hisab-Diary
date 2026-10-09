import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
final settingsProvider = StreamProvider<Map<String, String>>((ref) {
  return ref.watch(databaseProvider).watchSettings();
});
