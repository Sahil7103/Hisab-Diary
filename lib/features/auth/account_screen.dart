import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'auth_service.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});
  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch((value ?? '').trim())
      ? null : AppLocalizations.of(context)!.authEmailInvalid;

  Future<void> _perform(Future<void> Function(AuthService) action,
      {String? success}) async {
    if (_busy) return;
    setState(() => _busy = true);
    FocusScope.of(context).unfocus();
    try {
      await action(ref.read(authServiceProvider));
      if (!mounted) return;
      _password.clear();
      _confirm.clear();
      if (success != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
      }
    } catch (error) {
      if (!mounted) return;
      final strings = AppLocalizations.of(context)!;
      final message = switch (authErrorCategory(error)) {
        'email' => strings.authEmailInvalid,
        'weak' => strings.authPasswordWeak,
        'used' => strings.authEmailUsed,
        'credentials' => strings.authInvalidCredentials,
        'network' => strings.authNetworkError,
        'recent' => strings.authRecentLogin,
        'unavailable' => strings.authUnavailable,
        _ => strings.authTryAgain,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final strings = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteAccount), content: Text(strings.deleteAccountConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(strings.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(strings.deleteAccount)),
        ]));
    if (mounted && confirmed == true) await _perform((service) => service.deleteAccount());
  }

  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) =>
    InputDecoration(labelText: label, prefixIcon: Icon(icon, color: DiaryColors.pen),
      suffixIcon: suffix, filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DiaryColors.pen, width: 2)));

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final available = Firebase.apps.isNotEmpty;
    final session = available ? ref.watch(authUserProvider) : null;
    final user = session?.asData?.value;
    final loading = session?.isLoading ?? false;
    return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 24), children: [
        Row(children: [const BackButton(color: DiaryColors.ink),
          Expanded(child: DiaryScreenHeader(title: strings.accountTitle))]),
        const SizedBox(height: 24),
        Center(child: Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: DiaryColors.haldiSoft,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: DiaryColors.ink, width: 2)),
          child: const Icon(Icons.person_outline_rounded, color: DiaryColors.pen, size: 44))),
        const SizedBox(height: 18),
        Text(strings.accountIntro, textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        if (!available || session?.hasError == true)
          Text(strings.authUnavailable, style: Theme.of(context).textTheme.bodyLarge)
        else if (loading)
          const Center(child: CircularProgressIndicator())
        else if (user != null) ...[
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(strings.signedInAs, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(user.email ?? user.displayName ?? strings.accountTitle,
                style: Theme.of(context).textTheme.bodyLarge),
            ]))),
          const SizedBox(height: 18),
          DiaryButton(label: strings.signOut, onPressed: _busy ? null
            : () => _perform((service) => service.signOut())),
          const SizedBox(height: 12),
          TextButton(onPressed: _busy ? null : _delete, child: Text(strings.deleteAccount)),
        ] else ...[
          DiaryButton(label: strings.googleSignIn, color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: _busy ? null : () => _perform((service) => service.signInWithGoogle())),
          const SizedBox(height: 20),
          Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(controller: _email, enabled: !_busy,
              textDirection: TextDirection.ltr, keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next, autocorrect: false,
              autofillHints: const [AutofillHints.email], validator: _validateEmail,
              decoration: _decoration(strings.emailLabel, Icons.mail_outline_rounded)),
            const SizedBox(height: 14),
            TextFormField(controller: _password, enabled: !_busy,
              textDirection: TextDirection.ltr, obscureText: _obscure,
              autocorrect: false, enableSuggestions: false,
              autofillHints: [_register ? AutofillHints.newPassword : AutofillHints.password],
              validator: (value) => (value ?? '').isEmpty ? strings.authPasswordRequired
                : _register && value!.length < 6 ? strings.authPasswordWeak : null,
              decoration: _decoration(strings.passwordLabel, Icons.lock_outline_rounded,
                suffix: IconButton(tooltip: _obscure ? strings.showPassword : strings.hidePassword,
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
            if (_register) ...[
              const SizedBox(height: 14),
              TextFormField(controller: _confirm, enabled: !_busy,
                textDirection: TextDirection.ltr, obscureText: true,
                autocorrect: false, enableSuggestions: false,
                validator: (value) => value != _password.text ? strings.authPasswordMismatch : null,
                decoration: _decoration(strings.confirmPasswordLabel, Icons.lock_outline_rounded)),
            ],
            const SizedBox(height: 18),
            DiaryButton(label: _register ? strings.createAccount : strings.signIn,
              onPressed: _busy ? null : () {
                if (_form.currentState!.validate()) {
                  _perform((service) => _register
                    ? service.createAccount(_email.text, _password.text)
                    : service.signIn(_email.text, _password.text));
                }
              }),
          ])),
          if (!_register) TextButton(onPressed: _busy ? null : () {
            if (_validateEmail(_email.text) != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.authEmailInvalid)));
              return;
            }
            _perform((service) => service.resetPassword(_email.text), success: strings.resetSent);
          }, child: Text(strings.forgotPassword)),
          TextButton(onPressed: _busy ? null : () {
            setState(() => _register = !_register);
            _form.currentState?.reset();
            _password.clear();
            _confirm.clear();
          }, child: Text(_register ? strings.signIn : strings.createAccount)),
        ],
        if (_busy) const Padding(padding: EdgeInsets.all(12),
          child: Center(child: CircularProgressIndicator())),
        TextButton(onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.continueOffline)),
      ]))));
  }
}
