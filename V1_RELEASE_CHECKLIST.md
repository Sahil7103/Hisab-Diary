# Hisab Diary - v1 release checklist

Updated: 9 October 2026. Tick items only after verifying the final release build.
This is a release checklist, not confirmation that the app is ready or approved.

## Scope and remaining development

v1 stays free, with Pro purchases disabled. Login, cloud sync, ads and paid
subscriptions are deferred; they are not required for this release scope.
No additional feature is proposed here. Fix failures found below before review.

- [ ] Resolve the outdated vendor test that expects six categories instead of eighteen; rerun that focused test. This is a known test-maintenance issue, not evidence of a vendor-save bug.
- [ ] Ensure the published privacy policy matches the final app/SDK behavior. Local policy changes must be pushed and checked on the live Pages site.
- [ ] Review any Play Console build/policy blockers before submitting; do not assume a successful local build satisfies store requirements.

## Final manual tests

- [ ] Fresh installation: choose language once; Home, Month and Bill tutorials appear once, can be skipped, and stay dismissed after reopening.
- [ ] Vendors: all household categories/icons, custom decimal quantity/rate, plus/minus, schedules, archive/reactivate; add more than three vendors to confirm v1 is free.
- [ ] Today/Month: came, not-came, undo, repeated All came, off-schedule days and future-day restrictions; records survive reopening and work offline.
- [ ] Bills: current month defaults correctly; totals match a hand calculation, including absent days, fractional quantities and rate changes across months; paid status persists.
- [ ] Share a bill through WhatsApp; verify text, totals and app link. Verify the public app link after the listing is live.
- [ ] Backup/restore: vendors, entries, historical rates, paid bills and settings return correctly. Cancel restore and try an invalid file: existing data must remain intact. Keep a safe backup before any uninstall/clear-data test.
- [ ] Reminders: enabling and changing time show matching confirmations; test notification and actual scheduled delivery with app in background, after reboot/timezone change; notification All came saves correctly. Denied notification/exact-alarm permission shows helpful feedback/fallback.
- [ ] All nine languages, especially Urdu text direction with unchanged bottom-tab order; small screen, large text and keyboard cause no clipped controls. Check launcher icon and snackbar styling.
- [ ] Privacy policy opens from Settings; no working feature is blocked by Pro or requires login.
- [ ] Release monitoring: confirm Analytics, Crashlytics and Performance receive data. DebugView was reported tested by the developer; verify release telemetry too. Event definitions: [analytics guide](docs/analytics-events.md).
- [ ] Install from Play internal testing and check bill sharing, reminders and in-app review integration. Google controls whether a review prompt actually appears.

## Signing and upload

- [ ] Confirm `android/key.properties` references the existing `.jks`, with correct alias/passwords. Gradle already reads this file; the properties file does not replace the keystore. Back up the key securely and keep signing secrets out of Git.
- [ ] Confirm package `com.trevio.hisabdiary`, version/name and a version code not previously uploaded. Current source version: `1.0.0+1`.
- [ ] Build and install the signed APK for final testing: `flutter build apk --release`, then `flutter install --release`. Signing/install success for this final build is still unverified.
- [ ] Build the Play bundle: `flutter build appbundle --release`. Upload `build/app/outputs/bundle/release/app-release.aab`; use the real upload key, not the optional debug-signed test-release fallback.
- [ ] Verify the uploaded bundle target SDK and compatibility checks. As of this checklist, new phone apps require API 36 or higher; this project inherits `flutter.targetSdkVersion` and the installed Flutter SDK defaults to 36. Still inspect the resolved bundle value. [Google target API requirements](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en).
- [ ] Push the final reviewed commits to GitHub and confirm the privacy page is live: https://sahil7103.github.io/Hisab-Diary/ . Commits have been made locally; upload/publishing is a separate step.

## Play Console before production review

- [ ] Developer account registration, payment and required identity/device verification completed; create the app and enable Play App Signing.
- [ ] Store listing: name, short/full descriptions, icon, screenshots, feature graphic and support email `sahilkoshti1354@gmail.com`; describe only available v1 features.
- [ ] App content: privacy URL, Data safety reflecting Firebase SDK collection, ads declaration matching this build, target audience, content rating and app access (v1 has no login). Complete any permission declarations Console requests. [Google review checklist](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en).
- [ ] Internal-test installation and pre-launch report reviewed; fix reproducible crashes, broken flows and submission blockers.
- [ ] For personal developer accounts created after 13 November 2023: at least 12 testers continuously opted into CLOSED testing for 14 consecutive days, then apply for production access. Internal testing does not satisfy this requirement. No explicit daily-open quota; meaningful usage and feedback still matter. [Google testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en).
- [ ] Record tester feedback and fixes, complete production-access questions where required, then submit the release for review.

Release decision: submit only after required boxes are checked and no known
crashes, data-loss issues, incorrect bill totals or Console blockers remain.
