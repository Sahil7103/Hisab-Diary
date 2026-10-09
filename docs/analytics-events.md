# Hisab Diary v1 analytics

Firebase monitoring is enabled in release builds. For manual debug verification,
use `--dart-define=FIREBASE_TELEMETRY=true`. Ordinary debug builds do not send
these events or consume milestones. No diary contents, vendor identifiers,
quantities, prices, billing dates or contact information are sent by these hooks.

| Event | Meaning | Frequency |
| --- | --- | --- |
| `vendor_added` | A vendor and its initial rate were successfully saved | Every new vendor |
| `first_vendor_added` | First successful vendor creation | Once per local installation |
| `delivery_marked` | A came/not-came entry was successfully saved | Once per changed vendor |
| `first_delivery_marked` | First successful manual delivery mark | Once per local installation |
| `all_came_completed` | Bulk marking saved at least one previously unmarked entry | Once per effective bulk action |
| `first_week_three_days` | Successful marks on three distinct usage days in the first week | Once per local installation |

Delivery events use only fixed parameters:
- `source`: `today`, `month`, `reminder`
- `action`: `came`, `not_came`
- `mode`: `single`, `bulk`

Undo, rejected/failed saves, automatic inferred attendance and unchanged bulk
operations do not count. Bulk marking emits one `delivery_marked` per newly
marked vendor, plus one `all_came_completed`. Foreground and background
reminder actions use the same successful-write hooks.

First week means the first seven local calendar days, including the first
monitored app-open day. The milestone uses actual usage dates, even when editing
old delivery dates. Dates and completion flags stay in device settings, are not
exported in backups and survive backup restoration and app restarts. Clearing
app data or reinstalling resets them. Existing installations start their
measurement window when this version is first opened; old actions are not
reconstructed. Disabled monitoring does not consume milestones.
Event delivery is best effort: local flags prevent duplicates, but SDK failures
can lose an event; analytics is not an audit log.

## Reading the results

In Firebase/Google Analytics, use Events to compare vendor activation, delivery
activation, repeat marking and bulk-action adoption. Register `source`, `action`
and `mode` as event-scoped custom dimensions for breakdowns. Mark
`first_vendor_added`, `first_delivery_marked`, and `first_week_three_days` as key
events if useful. Use first-open cohorts and distinct users, not raw event
counts, when measuring activation or first-week engagement. Day-one/day-seven
return retention belongs in retention/cohort reports, separate from the
three-marking-days milestone. SDK screen views already cover Today, Month,
Bill and Settings; existing bill-share outcome events cover share completion.

Use DebugView for manual validation before trusting production dashboards.
No production Firebase delivery or device behavior is verified by unit tests.
