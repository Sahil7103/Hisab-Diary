import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/features/auth/auth_service.dart';

void main() {
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
