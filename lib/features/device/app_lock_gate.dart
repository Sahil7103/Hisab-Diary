import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../l10n/v3_strings.dart';
import 'app_lock_controller.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child, this.controller});
  final Widget child;
  final AppLockController? controller;
  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  late final AppLockController _lock;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    _lock = widget.controller ?? AppLockController.instance;
    WidgetsBinding.instance.addObserver(this);
    _lock.addListener(_changed);
    if (supportsDeviceFeatures || widget.controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
    }
  }

  Future<void> _prepare() async {
    if (!_lock.loaded) await _lock.initialize();
    if (mounted && _foreground && _lock.enabled && !_lock.unlocked &&
        _lock.failure != AppLockFailure.storage) {
      await _lock.unlock(v3Text(context, 'appLockReason'));
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    // The biometric dialog briefly makes the activity inactive.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden ||
        (!_lock.busy && state == AppLifecycleState.inactive)) _lock.lock();
    if (mounted) setState(() => _foreground = foreground);
    if (foreground && !_lock.busy) unawaited(_prepare());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lock.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!supportsDeviceFeatures && widget.controller == null) return widget.child;
    final blocked = _lock.blocked || (_lock.enabled && !_foreground);
    return PopScope(canPop: !blocked, child: Stack(children: [
      Offstage(offstage: blocked, child: TickerMode(enabled: !blocked,
        child: ExcludeFocus(excluding: blocked, child: widget.child))),
      if (blocked) Positioned.fill(child: Material(color: DiaryColors.paper,
        child: SafeArea(child: Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_rounded, size: 48, color: DiaryColors.ink),
            const SizedBox(height: 18),
            Text(v3Text(context, 'widgetLocked'),
              style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(v3Text(context, switch (_lock.failure) {
              AppLockFailure.storage => 'appLockStorageError',
              AppLockFailure.unavailable => 'appLockUnavailable',
              AppLockFailure.authentication => 'appLockFailed',
              null => 'appLockDescription',
            }), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_lock.busy) const CircularProgressIndicator()
            else FilledButton.icon(icon: const Icon(Icons.lock_open_rounded),
              label: Text(v3Text(context, _lock.failure == AppLockFailure.storage
                ? 'appLockRetry' : 'appLockUnlock')),
              onPressed: () => _lock.failure == AppLockFailure.storage
                  ? _prepare() : _lock.unlock(v3Text(context, 'appLockReason'))),
          ]),
        ))))),
    ]));
  }
}
