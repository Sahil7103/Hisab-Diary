import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/app_providers.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/households/household_controller.dart';

void main() {
  test('household switching preserves original records and separate databases after restart',() async {
    final directory=await Directory.systemTemp.createTemp('hisab-households-');
    AppDatabase open(String name) => AppDatabase.forTesting(NativeDatabase(File('${directory.path}/$name.sqlite')));
    ProviderContainer container() => ProviderContainer(overrides:[
      householdDatabaseFactoryProvider.overrideWithValue(open)]);
    var scope=container();
    try {
      final control=scope.read(householdControllerProvider.notifier);
      await control.load();
      var db=scope.read(databaseProvider);
      await db.into(db.vendors).insert(VendorsCompanion.insert(type:'milk',unit:'litre',
        defaultQty:1,rate:10,createdAt:'2020-01-01'));
      await control.add('Parents',preferences:{'language':'en','tutorialSeen_today':'true'});
      final id=scope.read(householdControllerProvider).selectedId;
      db=scope.read(databaseProvider);
      expect(await db.select(db.vendors).get(),isEmpty);
      await db.into(db.vendors).insert(VendorsCompanion.insert(type:'maid',unit:'visit',
        defaultQty:1,rate:20,createdAt:'2020-01-01'));
      await control.select('home');
      db=scope.read(databaseProvider);
      expect((await db.select(db.vendors).get()).single.type,'milk');
      scope.dispose();await Future<void>.delayed(const Duration(milliseconds:100));
      scope=container();await scope.read(householdControllerProvider.notifier).load();
      expect(scope.read(householdControllerProvider).selectedId,'home');
      await scope.read(householdControllerProvider.notifier).select(id);
      db=scope.read(databaseProvider);
      expect((await db.select(db.vendors).get()).single.type,'maid');
      expect((await db.select(db.settings).get()).any((row)=>row.key=='language' && row.value=='en'),isTrue);
      await expectLater(scope.read(householdControllerProvider.notifier).select('unknown'),throwsStateError);
    } finally {
      scope.dispose();await Future<void>.delayed(const Duration(milliseconds:100));
      await directory.delete(recursive:true);
    }
  });
}
