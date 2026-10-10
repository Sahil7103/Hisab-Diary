# Hisab Diary V3 implementation and release checks

V3 lives on branch `v3`. V1 (`main`) and V2 (`v2`) remain separate.

## Implemented

| Feature | Where to use it |
| --- | --- |
| Daily quantities and notes | Vendor menu > Ledger > Daily delivery |
| Date-based prices | Ledger > Rate change; bills use each date's applicable rate |
| Partial payments and advances | Ledger > Payment/advance; Bill shows paid, dues and credit |
| Vacation pauses | Ledger > Pause; skips automatic deliveries on the chosen dates |
| Itemized purchases | Ledger > Purchase; enable purchases-only from the selected month to prevent daily charges |
| Budgets and spending history | Settings > Budgets and spending; household/category limits, 6/12 month views |
| Vendor reminders | Ledger > Reminders; separate delivery and monthly payment times |
| Android home-screen widget | Android widget picker > Hisab Diary; Came, Absent, All came, Refresh and Open |
| Multiple household diaries | Settings > Household diaries; separate records and budgets on the same device |
| Fingerprint/device-PIN lock | Settings > App lock; system authentication, background privacy and widget redaction |

## Data protections

- Existing diary remains the default household. Other households use separate local databases.
- Schema upgrade retains old vendor, attendance, price and payment records.
- V3 backup contains delivery details, dated prices, pauses, purchases, payments and budgets. Older backups still restore. Export/restore applies only to the selected household.
- Use V3 to restore V3 backups: V1/V2 do not understand the new tables.
- Rate and purchase-mode changes are dated; prior months retain their previous calculations.
- Payment/advance credit carries forward. Existing settled months remain settled. Repeated settlement does not create duplicate payments.
- Widget actions reject expired snapshots, changed households, invalid vendors and locked access. Widget writes are idempotent.
- Device lock and household selection are device settings, excluded from diary backup.
- No dummy financial data or fake authentication was added.

## Verification completed

35 focused tests passed across the final verification runs. Targeted Dart analysis reported no issues. `flutter build apk --debug --no-pub` succeeded; the APK is at `build/app/outputs/flutter-apk/app-debug.apk` in the V3 checkout.

Focused checks cover dated rates, daily quantities, purchase-mode history, pauses, payment carry-forward, duplicate settlement, old/new backup restore, schema migration, household isolation, widget action validation, authentication failures, export reconciliation, budget parsing and reminder times. App execution and physical-device QA are left to the developer.

## Before production release

- Install a signed V3 build over V2 with real records. Verify every old bill and a restored backup before and after upgrading. Keep an external backup first.
- Test changing rates mid-month, fractional quantities, editing/deleting purchases and payments, advances across months and export totals in PDF/CSV.
- Confirm each household stays separate after switching, restarting, exporting and restoring. Confirm Firebase sign-in does not imply cloud sync; these diaries are local.
- Test widget taps with the app closed, date rollover, reboot, household switching, pauses, and lock enabled. Add a new widget after installation.
- Test fingerprint and device PIN, cancellation, failed authentication, app background/resume and screen lock on real Android devices. Secure windows hide screenshots/recents while app lock is enabled.
- Test reminder notification permission, reboot, timezone changes, battery restrictions and lock redaction. Delivery reminders are queued for the next 31 days and refreshed when the diary opens or changes; very long periods without opening need a longer-term rescheduling design.
- Payment reminder amounts are dated snapshots, refreshed after diary changes; opening the bill gives the current amount.
- Review all V3 translations: English and core Hindi labels are supplied; remaining labels/languages fall back to English. Complete language review before a multilingual production release.
- Widget and device lock are Android-only in this version. App lock protects access; it does not encrypt exported backups.
- Validate signed APK/AAB, Play signing fingerprints, Firebase authentication/Crashlytics and Play disclosures separately. No release signing secrets are committed.
- The existing Kotlin Gradle Plugin migration warning is future compatibility work; do not change the Flutter/Android toolchain solely for this V3 release.
