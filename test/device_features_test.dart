import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hisab_diary/features/device/app_lock_controller.dart';
import 'package:hisab_diary/features/device/diary_widget_service.dart';

class FakeAuthentication extends LocalAuthentication {
  bool accepted = true;
  Completer<bool>? pending;
  @override
  Future<bool> isDeviceSupported() async => true;
  @override
  Future<bool> authenticate({required String localizedReason,
    Iterable<dynamic> authMessages = const [], bool biometricOnly = false,
    bool sensitiveTransaction = true, bool persistAcrossBackgrounding = false}) async {
    expect(biometricOnly,isFalse);
    return pending == null ? accepted : pending!.future;
  }
}
void main() {
  test('widget rejects locked, stale, wrong-household and forged-vendor writes',() {
    final now=DateTime(2026,10,10);
    final snapshot=<String,dynamic>{'dbName':'hisab_diary','householdId':'home',
      'householdName':'Home','date':'2026-10-10','token':'current','vendors':[{'id':1}]};
    Uri action({String date='2026-10-10',String id='1',String token='current'}) => Uri(
      scheme:'hisabdiary',host:'widget',queryParameters:{'dbName':'hisab_diary',
      'householdId':'home','householdName':'Home','date':date,'action':'came','vendorId':id,'token':token});
    bool valid(Uri uri,{bool locked=false,String db='hisab_diary'}) =>
      validDiaryWidgetAction(uri,snapshot,locked:locked,dbName:db,
        householdId:'home',householdName:'Home',now:now);
    expect(valid(action()),isTrue);expect(valid(action(),locked:true),isFalse);
    expect(valid(action(date:'2026-10-09')),isFalse);expect(valid(action(id:'99')),isFalse);
    expect(valid(action(token:'old')),isFalse);expect(valid(action(),db:'../other'),isFalse);
  });
  test('authentication cancel and storage errors never unlock',() async {
    final auth=FakeAuthentication()..accepted=false;
    final lock=AppLockController(authentication:auth,readEnabled:() async=>true,writeEnabled:(_) async{});
    await lock.initialize();await lock.unlock('Unlock');expect(lock.blocked,isTrue);
    auth.accepted=true;await lock.unlock('Unlock');expect(lock.blocked,isFalse);
    lock.lock();expect(lock.blocked,isTrue);
    lock.dispose();
    final failed=AppLockController(authentication:auth,readEnabled:() async=>throw StateError('Storage'),
      writeEnabled:(_) async{});
    await failed.initialize();await failed.unlock('Unlock');
    expect(failed.blocked,isTrue);expect(failed.failure,AppLockFailure.storage);failed.dispose();
  });
  test('auth completed after background locking cannot unlock the app',() async {
    final auth=FakeAuthentication()..pending=Completer<bool>();
    final lock=AppLockController(authentication:auth,readEnabled:() async=>true,writeEnabled:(_) async{});
    await lock.initialize();final pending=lock.unlock('Unlock');await Future<void>.delayed(Duration.zero);
    lock.lock();auth.pending!.complete(true);await pending;expect(lock.blocked,isTrue);lock.dispose();
  });
  test('disabling lock requires auth and a successful preference write',() async {
    final auth=FakeAuthentication();
    final lock=AppLockController(authentication:auth,readEnabled:() async=>true,
      writeEnabled:(_) async=>throw StateError('Storage'));
    await lock.initialize();expect(await lock.setEnabled(false,'Disable'),isFalse);
    expect(lock.enabled,isTrue);expect(lock.blocked,isTrue);lock.dispose();
  });
}
