import 'package:flutter/services.dart';

const _privacyChannel = MethodChannel('hisab_diary/privacy');

Future<void> openPrivacyPolicy() =>
    _privacyChannel.invokeMethod<void>('openPrivacyPolicy');
