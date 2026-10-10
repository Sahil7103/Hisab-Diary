import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../l10n/v3_strings.dart';
import 'app_lock_controller.dart';

class AppLockSettings extends StatelessWidget {
  const AppLockSettings({super.key});
  @override
  Widget build(BuildContext context) {
    if (!supportsDeviceFeatures) return const SizedBox.shrink();
    final lock = AppLockController.instance;
    return ListenableBuilder(listenable: lock, builder: (context, _) =>
      SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        tileColor: DiaryColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: DiaryColors.ink)),
        secondary: const Icon(Icons.fingerprint_rounded, color: DiaryColors.ink),
        title: Text(v3Text(context, 'appLockTitle')),
        subtitle: Text(v3Text(context, switch (lock.failure) {
          AppLockFailure.storage => 'appLockStorageError',
          AppLockFailure.unavailable => 'appLockUnavailable',
          AppLockFailure.authentication => 'appLockFailed',
          null => 'appLockDescription',
        })),
        value: lock.enabled,
        onChanged: !lock.loaded || lock.busy ? null : (enabled) => lock.setEnabled(
          enabled, v3Text(context, enabled ? 'appLockEnableReason' : 'appLockDisableReason')),
      ));
  }
}
