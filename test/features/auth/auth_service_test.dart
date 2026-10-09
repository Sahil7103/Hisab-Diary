import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:hisab_diary/features/auth/auth_service.dart';

void main() {
  test('diagnostics include the error code but no provider message', () {
    final messages = <String>[];
    final original = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    try {
      logAuthFailure(FirebaseAuthException(code: 'configuration-not-found',
        message: 'private@email.example secret-password'));
      expect(messages, ['Authentication failed: configuration-not-found']);
    } finally {
      debugPrint = original;
    }
  });
  test('credential failures do not disclose whether an account exists', () {
    for (final code in ['wrong-password', 'user-not-found', 'invalid-credential']) {
      expect(authErrorCategory(FirebaseAuthException(code: code,
        message: 'Sensitive provider detail')), 'credentials');
    }
    expect(authErrorCategory(FirebaseAuthException(code: 'network-request-failed')), 'network');
    expect(authErrorCategory(FirebaseAuthException(code: 'requires-recent-login')), 'recent');
    expect(authErrorCategory(StateError('Sensitive provider detail')), 'retry');
  });
}
