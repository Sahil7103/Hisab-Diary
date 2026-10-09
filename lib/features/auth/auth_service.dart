import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/app_telemetry.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authUserProvider = StreamProvider<User?>((ref) =>
  ref.watch(authServiceProvider).users);

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn.instance;
  static Future<void>? _googleInitialization;

  Stream<User?> get users => _auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> createAccount(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> resetPassword(String email) =>
    _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signInWithGoogle() async {
    await (_googleInitialization ??= _google.initialize());
    try {
      final account = await _google.authenticate();
      final token = account.authentication.idToken;
      if (token == null) throw FirebaseAuthException(code: 'invalid-credential');
      await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: token));
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled) rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleInitialization != null) {
      try {
        await _googleInitialization;
        await _google.signOut();
      } catch (error, stack) {
        AppTelemetry.report(error, stack, operation: 'google_sign_out');
      }
    }
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    await signOut();
  }
}

// Only fixed error categories reach the UI, never SDK messages or credentials.
String authErrorCategory(Object error) {
  if (error is GoogleSignInException) {
    return switch (error.code) {
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError => 'unavailable',
      _ => 'retry',
    };
  }
  if (error is! FirebaseAuthException) return 'retry';
  return switch (error.code) {
    'invalid-email' => 'email',
    'weak-password' => 'weak',
    'email-already-in-use' => 'used',
    'invalid-credential' || 'wrong-password' || 'user-not-found' => 'credentials',
    'network-request-failed' => 'network',
    'requires-recent-login' => 'recent',
    'operation-not-allowed' || 'configuration-not-found' => 'unavailable',
    _ => 'retry',
  };
}
