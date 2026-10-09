# Firebase monitoring (Android)

Release builds enable Analytics, Crashlytics and Performance for the registered
`com.trevio.hisabdiary` Firebase app. Debug builds disable collection by default.
Use `--dart-define=FIREBASE_TELEMETRY=true` for a manual monitoring check, or
`--dart-define=FIREBASE_TELEMETRY=false` to disable collection in a release build.
Native collection defaults are disabled until Dart configures monitoring.

## Dashboards

- Analytics: active users, sessions, retention, Today/Month/Bill/Settings screen
  views, vendor saves, bill payment/share actions and Pro store states.
  `bill_share` means the share operation returned; the separate status event
  distinguishes success, dismissal and unavailable sharing. Store states are
  diagnostics, not verified revenue or unique purchase conversions.
- Crashlytics: native crashes, uncaught Flutter/async errors, plus caught vendor,
  bill, purchase and reminder scheduling failures with stack traces.
- Performance: supported native startup/network measurements and custom
  `vendor_save`, `bill_mark_paid`, `bill_share` timings. Share timing includes the
  share sheet interaction. Flutter widget rendering is not automatically traced.

Custom telemetry contains fixed action/screen names and error types, never vendor
names, IDs, quantities, rates, bill text, purchase tokens or raw exception messages.
SDK automatic collection has its own data practices; declare enabled SDK data
collection accurately in the privacy policy and Play Data safety form.

## Manual validation

Rebuild/install after adding native plugins; hot restart alone is insufficient.
Enable the flag above in a development build and visit the four tabs, save a vendor,
and share a bill. Check Analytics events and Performance traces after upload.
For Crashlytics, temporarily throw an uncaught test exception in development,
restart the app to upload, confirm its stack in the dashboard, then remove it.
No crash button is included in the app. Dashboard delivery has not been verified.

For releases using `--obfuscate` / `--split-debug-info`, upload the matching Dart
symbols with Firebase CLI `crashlytics:symbols:upload` for the registered Firebase
app; Android Gradle handles native mapping uploads. Keep symbols for each release.
Set dashboard alert recipients in Firebase console for new/regressed crashes and
performance issues. Console alert configuration requires the project owner's access.

## Installable release APK for local testing (PowerShell)

Without a production keystore, explicitly opt into debug signing:

```powershell
$env:ORG_GRADLE_PROJECT_testRelease = 'true'
flutter build apk --release
Remove-Item Env:ORG_GRADLE_PROJECT_testRelease
```

The APK is `build/app/outputs/flutter-apk/app-release.apk`. This opt-in uses the
local debug certificate only when `android/key.properties` is absent. Store
releases must use the owner's production upload keystore.
