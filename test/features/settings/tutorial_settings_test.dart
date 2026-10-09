import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/settings/settings_repository.dart';

void main() {
  test('tutorial progress persists independently in local settings', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);
    await repository.setLanguage('en');
    await repository.markTutorialSeen('home');
    var settings = await database.watchSettings().first;
    expect(settings['tutorialSeen_home'], 'true');
    expect(settings['tutorialSeen_month'], isNull);
    expect(settings['tutorialSeen_bill'], isNull);
    expect(settings['language'], 'en');
    await SettingsRepository(database).markTutorialSeen('home');
    await repository.markTutorialSeen('month');
    await repository.markTutorialSeen('bill');
    settings = await database.watchSettings().first;
    expect(settings['tutorialSeen_home'], 'true');
    expect(settings['tutorialSeen_month'], 'true');
    expect(settings['tutorialSeen_bill'], 'true');
  });
}
