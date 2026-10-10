import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:local_auth/local_auth.dart';

const appLockEnabledKey = 'app_lock_enabled';
const diaryWidgetAndroidName = 'com.example.hisab_diary.DiaryWidgetProvider';
bool get supportsDeviceFeatures => !kIsWeb &&
    defaultTargetPlatform == TargetPlatform.android;

enum AppLockFailure { storage, authentication, unavailable }

class AppLockController extends ChangeNotifier {
  AppLockController({LocalAuthentication? authentication,
    Future<bool?> Function()? readEnabled,
    Future<void> Function(bool)? writeEnabled})
      : _authentication = authentication ?? LocalAuthentication(),
        _readEnabled = readEnabled ?? (() => HomeWidget.getWidgetData<bool>(appLockEnabledKey)),
        _writeEnabled = writeEnabled ?? _saveEnabled;

  static final instance = AppLockController();
  final LocalAuthentication _authentication;
  final Future<bool?> Function() _readEnabled;
  final Future<void> Function(bool) _writeEnabled;
  int _lockGeneration = 0;
  bool loaded = false;
  bool enabled = true;
  bool unlocked = false;
  bool busy = false;
  AppLockFailure? failure;

  bool get blocked => !loaded || failure == AppLockFailure.storage ||
      (enabled && !unlocked);

  static Future<void> _saveEnabled(bool enabled) async {
    if (await HomeWidget.saveWidgetData<bool>(appLockEnabledKey, enabled) != true) {
      throw StateError('App lock could not be saved');
    }
    await const MethodChannel('hisab_diary/device').invokeMethod<void>('refreshPrivacy');
    await HomeWidget.updateWidget(qualifiedAndroidName: diaryWidgetAndroidName);
  }

  Future<void> initialize() async {
    if (busy) return;
    busy = true;
    notifyListeners();
    try {
      final saved = await _readEnabled();
      if (saved == null) await _writeEnabled(false);
      enabled = saved ?? false;
      loaded = true;
      failure = null;
    } catch (_) {
      loaded = false;
      unlocked = false;
      failure = AppLockFailure.storage;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void lock() {
    _lockGeneration++;
    if (!unlocked) return;
    unlocked = false;
    notifyListeners();
  }

  Future<bool> authenticate(String reason) async {
    if (busy || !loaded || failure == AppLockFailure.storage) return false;
    final generation = _lockGeneration;
    busy = true;
    failure = null;
    notifyListeners();
    try {
      if (!await _authentication.isDeviceSupported()) {
        failure = AppLockFailure.unavailable;
        return false;
      }
      final accepted = await _authentication.authenticate(
        localizedReason: reason, biometricOnly: false,
        persistAcrossBackgrounding: false,
      );
      final valid = accepted && generation == _lockGeneration;
      if (!valid) failure = AppLockFailure.authentication;
      return valid;
    } catch (_) {
      failure = AppLockFailure.authentication;
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> unlock(String reason) async {
    if (await authenticate(reason)) {
      unlocked = true;
      notifyListeners();
    }
  }

  Future<bool> setEnabled(bool value, String reason) async {
    if (value == enabled || !await authenticate(reason)) return false;
    busy = true;
    notifyListeners();
    try {
      await _writeEnabled(value);
      enabled = value;
      unlocked = true;
      failure = null;
      return true;
    } catch (_) {
      unlocked = false;
      loaded = false;
      failure = AppLockFailure.storage;
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
