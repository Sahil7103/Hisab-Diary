import '../../core/constants/app_languages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) =>
  SettingsRepository(ref.watch(databaseProvider)));

class SettingsRepository {
  SettingsRepository(this.database);
  final AppDatabase database;
  Future<void> markTutorialSeen(String screen) {
    if (!['home', 'month', 'bill'].contains(screen)) {
      throw ArgumentError('Unsupported tutorial');
    }
    return database.saveSetting('tutorialSeen_$screen', 'true');
  }
  Future<void> setLanguage(String language) {
    if (!supportedLanguageCodes.contains(language)) {
      throw ArgumentError('Unsupported language');
    }
    return database.saveSetting('language', language);
  }
  Future<void> setTextScale(double scale) {
    if (![0.9, 1.0, 1.2].contains(scale)) {
      throw ArgumentError('Unsupported text scale');
    }
    return database.saveSetting('textScale', scale.toString());
  }
  Future<void> setCountUnmarked(bool enabled) =>
    database.saveSetting('countUnmarkedAsCame', enabled.toString());
}
