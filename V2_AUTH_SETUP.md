# v2 optional authentication

Branch: `v2`. Open Settings > Your account. Email/password sign-in, account
creation, password reset, Google sign-in, sign-out and account deletion are
connected to Firebase Authentication. The diary remains device-local and usable
without login; cloud backup and per-account diary ownership are not implemented
in this step. Authentication does not migrate, erase or upload diary records.

## Google configuration required before device testing

The currently checked-in `android/app/google-services.json` has an empty
`oauth_client` list. Enabling the provider alone is not enough for this file.

1. In Firebase Project settings, select Android app `com.trevio.hisabdiary`.
2. Register SHA-1 and SHA-256 fingerprints for the debug and upload signing
   certificates; register the Play app-signing certificate when testing via Play.
   Use `android/gradlew.bat signingReport` from the root to inspect configured
   variants; enter/keep signing passwords privately.
3. Download a fresh `google-services.json` and replace the file in `android/app/`.
   It should include the web OAuth client (`client_type: 3`). Do not manually
   invent OAuth IDs or edit the Firebase-generated credentials.
4. Fully rebuild/restart after changing native packages or Firebase config.
   Hot reload alone is insufficient. No app was launched by this change.

References: [Firebase Google sign-in](https://firebase.google.com/docs/auth/flutter/federated-auth),
[Android Google sign-in configuration](https://pub.dev/packages/google_sign_in_android).

## If both login methods show a setup error

- Confirm Authentication > Sign-in method has Email/Password and Google enabled
  in **hisab-diary-fc5ec**, the project used by this app's configuration.
- For email login, create an account first; a Google/Gmail password is not an
  email/password account password for this app.
- Run a full rebuild after installing Auth plugins or replacing Android Firebase
  configuration. Hot reload or hot restart cannot update the native SDK/config.
- In a debug build, retry login and find `Authentication failed: <code>` in the
  terminal. Only the SDK error code is printed, never email/password/token data.
  `operation-not-allowed` or `configuration-not-found` requires console setup;
  Google client/provider configuration errors require the OAuth/fingerprint steps above.
- The current Firebase CLI session received HTTP 403 (permission denied) when
  retrieving a replacement configuration.
  Download it from Project settings after completing the Google setup.

## Manual checks

- Continue offline/back returns to the diary without requiring authentication.
- Create an email account; check it in Firebase Authentication > Users.
- Sign out, sign back in; restart the app and confirm the session persists.
- Wrong credentials, invalid email, password mismatch and network failure show
  readable messages without exposing SDK exceptions or user credentials.
- Password-reset email arrives; reset it and sign in with the new password.
- Google chooser signs in; cancel returns quietly; sign-out allows another account.
- Delete a newly created test account and confirm its removal in Firebase.
  If Firebase requires a recent login, sign out/in first, then retry deletion.
- Check existing vendors, marks, totals and offline backup are unchanged.
- Before releasing v2: update privacy/Data safety for authentication, add the
  required public account-deletion request page, and implement secure account
  ownership and cloud-backup deletion when cloud backup is added.

Build v1 from `main`; build these features only from `v2`. Both branches use the
same Android app ID, so use a spare device or back up data before changing builds.
