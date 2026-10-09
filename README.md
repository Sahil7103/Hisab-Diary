# Hisab Diary

## Current v1 status

- Android application ID: `com.trevio.hisabdiary`.
- Nine languages: Hindi, English, Gujarati, Marathi, Tamil, Urdu, Bengali,
  Telugu and Kannada. Urdu text uses RTL; bottom navigation keeps its usual order.
- Core diary features work offline without login. Release builds use Firebase
  Analytics, Crashlytics and Performance; see `FIREBASE_MONITORING.md`.
- Pro purchases are disabled for this release; vendor accounts are unlimited.
- Shared bills include the Play Store download link. After a successful share,
  the app requests a native review once per local diary installation, when the
  review API is available and the app is resumed. The flag stays outside backups.
  Google controls whether its dialog appears; validate using a Play test track.
- Privacy policy: https://sahil7103.github.io/Hisab-Diary/
- GitHub Pages publishes only `/docs` from `main`. Signing properties, keystores,
  local data, builds and internal marketing documents are excluded from Git.
- The phase notes below describe earlier implementation stages; current source
  and this status section take precedence over their older configuration details.

Offline Android household delivery tracker, built in reviewable phases.

## Phases 1–7

- Material 3 theme matching the HTML prototype colours, typography and shapes.
- Ruled notebook background and pressable button component.
- Bundled Baloo 2, Noto Sans Devanagari and Noto Sans Gujarati fonts, with SIL
  Open Font Licenses in `assets/fonts`.
- Hindi (default), English, Gujarati and Marathi generated localisation.
- Riverpod state and persistent Drift SQLite storage.
- First-launch language selection with live preview and local persistence.
- Today shows scheduled active vendors with reversible came/not-came marking,
  rotated stamps and bundled SVG illustrations.
- Add vendors using six illustrated type tiles, an optional name, quantity/rate
  steppers and daily or selected-weekday schedules. Saving creates the vendor
  and its initial month-rate snapshot atomically and returns to Today.
- Transactional All came preserves existing marks and skips archived,
  off-schedule and not-yet-created vendors.
- Today refreshes at midnight and on app resume. Storage failures show a
  localised message, and duplicate taps are blocked while saving.
- Vendor month calendar with Monday-first weekday alignment, month navigation,
  vendor selection, reversible came/not-came days, a yellow today outline,
  dashed disabled days and a running total.
- Monthly totals use effective historical rate/quantity snapshots. Unmarked
  scheduled past days optionally count as came, without creating entry rows.
- Bill screen opens the previous full month for the selected vendor, includes
  monthly totals, calculation rows, automatic-day disclosure and a localised
  share preview. Android's share sheet lets the user choose WhatsApp.
- Paid state is stored per vendor/month and does not change bill amounts.
- Settings apply language, text size and unmarked-day counting immediately.
- JSON backup shares all vendors, marks, rates, payments and supported settings.
  Restore validates version, field types, dates, unique keys and references,
  reviews the replacement with the user, then replaces diary data atomically.
  Backups are limited to 10 MB. Device-only settings are preserved on restore.
- Four working navigation tabs. No sample vendors or bills are inserted.

The schema includes vendors, entries, month rates, payments and key-value
settings. Entry dates and vendor creation dates use `yyyy-MM-dd`; month keys
use `yyyy-MM`. Day masks use bit 0 for Monday through bit 6 for Sunday.
Unmarked days have no entry row. Entry status values are `came` and `notCame`.
Archive vendors instead of deleting them. Foreign keys are enabled.
Settings default to Hindi and normal text size when absent. The presence of
`language` records completion of first-launch onboarding.

## Development

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter test test/features/today/today_repository_test.dart
```

Generated database and localisation Dart files are included. Regenerate after
changing tables or ARB files. Application code makes no backend calls;
the app has no backend, authentication, analytics or runtime font downloads.
Core diary features remain offline. Play Store billing uses the installed Play
Store service. Its Billing Client 8.0.0 dependency also bundles Google DataTransport,
which adds Internet and network-state permissions to the merged release manifest.
Core diary data stays local; no application analytics SDK is configured.
The PRD was not supplied; the pasted build request defines scope and the HTML
prototype defines appearance.

Phase 7 implementation and release preparation are now in place. The app has not been launched or device-tested.
New installations show an empty Today screen with a working Add vendor button.
Today displays vendors scheduled for the current weekday; other schedules appear
on their selected days. Vendor taps open that vendor's month calendar. The Month
 tab uses the selected vendor, or the first active vendor when none is selected.
Unmarked counting defaults to ON, matching the prototype, and can now be changed
in Settings. Rate changes are stored starting in the current month; earlier
month snapshots remain intact. Reminders, a time picker, Pro purchases and
active-vendor limits are implemented. Device QA and production signing remain manual.

Sharing and file picking use native plugins and still need manual Android checks.
The Play Store link is an explicit localised placeholder until publication.

Focused vendor storage checks:
```sh
flutter test test/features/vendors/vendor_repository_test.dart
```


Phase 4 calendar and billing checks:
```sh
flutter test test/features/month
```

Phase 5 focused checks:
```sh
flutter test test/features/bill test/features/settings test/widget_test.dart
```


## Phase 6

- Daily local reminders default to 20:00. The two translated actions mark only
  unmarked scheduled active vendors, or open Today. Background marking uses the
  same transactional repository operation as the Today button.
- Notification and exact-alarm permissions are requested only on explicit
  enabling. Denied exact alarms fall back to less precise scheduling. Restoring
  enabled preferences does not request permission; Settings explains problems.
- Native receivers reschedule after reboot and time/timezone changes. The helper
  covers Xiaomi, Oppo, Vivo and Realme, opens app settings and sends a test
  notification when reminders are enabled. Android permissions, manufacturer
  battery restrictions, reboot and background delivery need manual device checks.
- One non-consumable Play product: `hisab_diary_pro`. The UI uses the real price,
  handles pending/canceled/failed transactions, completes purchases, restores
  ownership and caches Pro locally for offline use. Successful store ownership
  queries reconcile refunds/removals; offline errors preserve the cache.
- Free permits 3 active vendors, Pro 12. Create, reactivate and backup restore
  enforce the limit inside database transactions. Existing accounts over a limit
  are preserved, but cannot add or reactivate another account until below it.
- Settings > Manage accounts archives/reactivates without deleting marks, month
  rates or payments. Pro entitlement is never exported or imported in backups.

### Play Console setup before purchase testing

Register the final application ID and signing configuration for publication
(currently `com.example.hisab_diary` and debug signing). Create and activate the
one-time product `hisab_diary_pro`, set its price and countries, upload the app to
an internal testing track, and add license testers. Install from that track with
the tester's Play account. Check purchase, pending payment, cancellation,
acknowledgment, reinstall/restore and refunds. Ordinary local debug installs can
show store-unavailable until the matching app/product/tester configuration exists.
Do not edit the local entitlement setting to simulate a production purchase.

Reference setup: [notifications](https://pub.dev/packages/flutter_local_notifications)
and [Flutter Play Billing](https://pub.dev/packages/in_app_purchase).

Focused Phase 6 checks:
```sh
flutter test test/features/pro test/features/reminders
```


## Phase 7: polish and release preparation

- Today distinguishes a new diary from an existing account with no delivery
  scheduled today. A new diary presents one large first-account action.
- Calendar columns grow with text size and scroll horizontally when necessary;
  weekday headers remain aligned. Add-type tiles become one column with very
  large text. Tab and reminder actions have explicit localized semantics.
- Notebook launcher artwork replaces the Flutter icon at all legacy densities,
  with adaptive and monochrome Android variants. The reminder drawable is kept
  during release resource shrinking.
- Release signing reads the owner's ignored `android/key.properties`. Copy
  `android/key.properties.example` and fill it with an existing upload key's
  details. Never commit the real file or keystore. Without this file release
  artifacts are unsigned; there is no automatic debug-signing fallback.
- The current application ID is still `com.example.hisab_diary`. Confirm the
  final ID before creating the Play Console application/product or distributing
  the app. A production-signed app bundle is required for Play submission.

Build without launching:
```sh
flutter build apk --release --split-per-abi
# After configuring the owner's upload key:
flutter build appbundle --release
```

Phase 7 focused checks:
```sh
flutter test test/features/polish/phase_seven_test.dart test/widget_test.dart test/features/month/month_calendar_test.dart
```

### Manual checks still required

The app has not been launched by the agent. Automated widget checks exercise
320dp layouts at 2x system text plus the 1.2x app setting in all four languages;
they do not establish real TalkBack behavior or device performance.

On a physical low-end Android phone (2 GB RAM):
- With TalkBack, traverse each control and verify one useful localized label,
  selected/toggled state, date/attendance status and predictable focus order.
- Use the largest supported font setting and check Today, Month, Bill, Settings,
  Add details, reminder time picker, archive confirmations and Pro/store dialogs.
- Check cold launch under 2 seconds and responsive marking/scrolling with the
  maximum 12 active vendors and long names. Measure in profile/release mode;
  debug-mode timings are not release performance evidence.
- In airplane mode, mark attendance, browse months, save rates, reopen the diary,
  mark paid and export/restore. No core operation should require a connection.
- Enable/deny reminder permissions, test both notification actions, reboot,
  change timezone and check background delivery with the brand's battery limits.
- Complete the Play license-tester scenarios listed in Phase 6 before release.

Signing reference: https://docs.flutter.dev/deployment/android
Adaptive icon reference: https://developer.android.com/develop/ui/views/launch/icon_design_adaptive



## Splash and app branding

The notebook mark uses the existing paper, ink, haldi, pen-blue and came-green
palette. The Flutter startup screen adds ruled paper, the localized app name
and tagline, and a loading indicator. A one-time 3-second notebook reveal keeps
the intro visible even when settings load immediately; slower storage keeps the
loading screen visible. Reduced motion skips the intro, and storage errors
still open the retry screen immediately. Buttons, tabs and attendance stamps
use short motion effects that also respect the reduced-motion setting.
Android launch themes cover older versions and Android 12+ in light/dark system
modes. The iOS launch storyboard uses the same paper color and centered mark.

- Master icon: `assets/branding/app_icon.png` (opaque 1024px PNG).
- Flutter mark: `assets/branding/diary_mark.svg`.
- Android: legacy icon densities plus adaptive and monochrome launcher icons.
- iOS: every existing AppIcon catalog slot, including the 1024px App Store icon.
- Recreate raster assets on Windows with
  `powershell -NoProfile -ExecutionPolicy Bypass -File tools/generate-branding.ps1`.
  This changes execution policy only for that process, not the machine.

Native Android resources and icon dimensions can be checked locally. Compiling
or validating the iOS storyboard on a device requires macOS/Xcode; iOS app
functionality beyond branding remains outside the Android-first scope.
