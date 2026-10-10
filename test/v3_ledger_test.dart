import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/features/ledger/diary_ledger_repository.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/features/month/month_repository.dart';
import 'package:hisab_diary/features/settings/backup_service.dart';
import 'package:hisab_diary/features/today/today_repository.dart';

void main() {
  late AppDatabase db;
  late DiaryLedgerRepository ledger;
  late int id;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ledger = DiaryLedgerRepository(db);
    id = await db.into(db.vendors).insert(VendorsCompanion.insert(type:'milk',unit:'litre',
      defaultQty:1,rate:10,createdAt:'2020-01-01'));
    await db.into(db.monthRates).insert(MonthRatesCompanion.insert(vendorId:id,month:'2020-01',rate:10,qty:1));
    await db.saveSetting('countUnmarkedAsCame','false');
    await db.saveSetting('language','en');
  });
  tearDown(() => db.close());
  Future<int> came(String date) => db.into(db.entries).insert(EntriesCompanion.insert(
    vendorId:id,date:date,status:'came'));
  test('dated prices and daily quantities keep older prices and reconcile exported rows',() async {
    await came('2020-01-01');await came('2020-01-02');await came('2020-01-03');
    await ledger.saveRate(id,DateTime(2020,1,2),quantity:1,rate:20);
    await ledger.saveDaily(id,DateTime(2020,1,3),quantity:0.5,note:'Half delivery');
    final bill=await MonthRepository(db).loadMonth(id,DateTime(2020,1),DateTime(2020,2,1));
    expect(bill.totalPaise,4000);
    expect(bill.deliveries.map((row)=>row.rate),[10,20,20]);
    expect(bill.deliveries.last.note,'Half delivery');
    expect(bill.deliveries.fold<int>(0,(sum,row)=>sum+row.totalPaise),bill.totalPaise);
    await ledger.saveDaily(id,DateTime(2020,1,3));
    expect(await db.select(db.dailyDetails).get(),isEmpty);
  });
  test('pauses skip automatic delivery and widget writes, but actual delivery is billed',() async {
    await db.saveSetting('countUnmarkedAsCame','true');
    await ledger.addPause(id,DateTime(2020,1,2),DateTime(2020,1,4));
    await came('2020-01-03');
    final bill=await MonthRepository(db).loadMonth(id,DateTime(2020,1),DateTime(2020,1,6));
    expect(bill.totalPaise,3000);expect(bill.days[2],DayAttendance.paused);
    expect(bill.days[3],DayAttendance.came);
    expect(await TodayRepository(db).loadDay(DateTime(2020,1,2)),isEmpty);
    await TodayRepository(db).mark(id,DateTime(2020,1,2),Attendance.came);
    expect(await db.select(db.entries).get(),hasLength(1));
  });
  test('purchases-only avoids duplicate daily charges',() async {
    await came('2020-01-01');
    await ledger.addPurchase(id,DateTime(2020,1,2),name:'Apples',quantity:1.5,unitPrice:12.34);
    await ledger.setPurchasesOnly(id,true,effectiveDate:DateTime(2020,1,1));
    final bill=await MonthRepository(db).loadMonth(id,DateTime(2020,1),DateTime(2020,2,1));
    expect(bill.totalPaise,1851);expect(bill.cameDays,0);
    expect(await TodayRepository(db).loadDay(DateTime(2020,1,2)),isEmpty);
  });
  test('purchase mode changes retain previous months delivery charges',() async {
    await came('2020-01-01');await came('2020-02-01');
    await ledger.setPurchasesOnly(id,true,effectiveDate:DateTime(2020,2,1));
    expect((await MonthRepository(db).loadMonth(id,DateTime(2020,1),DateTime(2020,3,1))).totalPaise,1000);
    expect((await MonthRepository(db).loadMonth(id,DateTime(2020,2),DateTime(2020,3,1))).totalPaise,0);
  });
  test('partial payment and advance carry forward without duplicate settlement',() async {
    await came('2020-01-01');await came('2020-02-01');
    await ledger.addPayment(id,DateTime(2020,1),DateTime(2020,1,2),amountPaise:400);
    expect((await ledger.balanceForMonth(id,DateTime(2020,1))).duePaise,600);
    await ledger.addPayment(id,DateTime(2020,1),DateTime(2020,1,3),amountPaise:1600,advance:true);
    final balance=await ledger.balanceForMonth(id,DateTime(2020,2));
    expect(balance.openingBalancePaise,-1000);expect(balance.duePaise,0);
    await ledger.settleBalance(id,DateTime(2020,2));
    expect(await db.select(db.ledgerPayments).get(),hasLength(2));
    await came('2020-02-02');
    await ledger.settleBalance(id,DateTime(2020,2));await ledger.settleBalance(id,DateTime(2020,2));
    expect((await ledger.balanceForMonth(id,DateTime(2020,2))).duePaise,0);
    expect(await db.select(db.ledgerPayments).get(),hasLength(3));
  });
  test('legacy settled month stays settled',() async {
    await came('2020-01-01');await came('2020-02-01');
    await db.into(db.payments).insert(PaymentsCompanion.insert(vendorId:id,month:'2020-01',paidAt:'2020-02-01'));
    final balance=await ledger.balanceForMonth(id,DateTime(2020,2));
    expect(balance.openingBalancePaise,0);expect(balance.duePaise,1000);
  });
  test('V3 backup round trip and older V1 restore preserve valid records',() async {
    await ledger.saveDaily(id,DateTime(2020,1,1),quantity:2,note:'Extra');
    await ledger.saveRate(id,DateTime(2020,1,2),quantity:1,rate:12);
    await ledger.addPause(id,DateTime(2020,1,4),DateTime(2020,1,6));
    await ledger.addPurchase(id,DateTime(2020,1,3),name:'Rice',quantity:2,unitPrice:15);
    await ledger.addPayment(id,DateTime(2020,1),DateTime(2020,1,3),amountPaise:300);
    await db.saveSetting('v3Budget:2020-01:all','50000');
    final service=BackupService(db);final bytes=await service.exportBytes();
    await service.restore(DiaryBackup.decode(bytes));
    expect(jsonDecode(utf8.decode(await service.exportBytes())),jsonDecode(utf8.decode(bytes)));
    final legacy=jsonDecode(utf8.decode(bytes)) as Map<String,dynamic>;legacy['version']=1;
    for(final key in ['dailyDetails','rateChanges','vendorPauses','purchases','ledgerPayments']) { legacy.remove(key); }
    (legacy['settings'] as Map).remove('v3Budget:2020-01:all');
    await service.restore(DiaryBackup.decode(Uint8List.fromList(utf8.encode(jsonEncode(legacy)))));
    expect(await db.select(db.purchases).get(),isEmpty);expect(await db.select(db.vendors).get(),hasLength(1));
  });
  test('invalid money and unsafe imported records are rejected before writing',() async {
    await ledger.addPayment(id,DateTime(2020,1),DateTime(2020,1,2),amountPaise:100);
    final bytes=await BackupService(db).exportBytes();
    final root=jsonDecode(utf8.decode(bytes));root['ledgerPayments'][0]['amountPaise']=-1;
    expect(()=>DiaryBackup.decode(Uint8List.fromList(utf8.encode(jsonEncode(root)))),throwsFormatException);
    expect(await db.select(db.ledgerPayments).get(),hasLength(1));
    await expectLater(ledger.saveDaily(id,DateTime(2020,1,1),quantity:double.nan),throwsArgumentError);
    await expectLater(ledger.addPause(id,DateTime(2020,1,2),DateTime(2020,1,1)),throwsArgumentError);
  });
  test('schema 1 migration retains existing records and creates all new tables',() async {
    final directory=await Directory.systemTemp.createTemp('hisab-v3-migration-');
    final file=File('${directory.path}/diary.sqlite');
    var old=AppDatabase.forTesting(NativeDatabase(file));
    try {
      await old.into(old.vendors).insert(VendorsCompanion.insert(type:'milk',unit:'litre',defaultQty:1,rate:10,createdAt:'2020-01-01'));
      for(final name in ['daily_details','rate_changes','vendor_pauses','purchases','ledger_payments']) {
        await old.customStatement('DROP TABLE $name');
      }
      await old.customStatement('PRAGMA user_version = 1');await old.close();
      old=AppDatabase.forTesting(NativeDatabase(file));
      expect(await old.select(old.vendors).get(),hasLength(1));
      expect(await old.select(old.ledgerPayments).get(),isEmpty);
      expect(await old.select(old.purchases).get(),isEmpty);
      expect(await old.select(old.dailyDetails).get(),isEmpty);
      expect(await old.select(old.rateChanges).get(),isEmpty);
      expect(await old.select(old.vendorPauses).get(),isEmpty);
    } finally { await old.close();await directory.delete(recursive:true); }
  });
}
