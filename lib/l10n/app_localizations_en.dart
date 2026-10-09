// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tutorialAddTitle => 'Add your first account';

  @override
  String get tutorialAddBody =>
      'Tap Add account to choose milk, newspaper or another service. Enter its daily quantity and price, then save.';

  @override
  String get tutorialMarkTitle => 'Mark today’s delivery';

  @override
  String get tutorialMarkBody =>
      'Tap Came or Not came on an account. Tap the same mark again to undo it. Tap the account name to open its calendar.';

  @override
  String get tutorialAllTitle => 'Everything came?';

  @override
  String get tutorialAllBody =>
      'Tap All came to mark every delivery scheduled for today in one go.';

  @override
  String get tutorialTabsTitle => 'Your diary at a glance';

  @override
  String get tutorialTabsBody =>
      'Today is for daily marks. Month shows the calendar. Bill calculates totals and shares them on WhatsApp. Settings has language and reminders.';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialDone => 'Start using my diary';

  @override
  String get tutorialSkip => 'Skip tutorial';

  @override
  String get tutorialVendorTitle => 'Choose an account';

  @override
  String get tutorialVendorBody =>
      'Tap Choose a vendor to switch between your household accounts.';

  @override
  String get tutorialMonthTitle => 'Choose a month';

  @override
  String get tutorialMonthBody =>
      'Use the left and right arrows to change the month.';

  @override
  String get tutorialCalendarTitle => 'Correct a daily mark';

  @override
  String get tutorialCalendarBody =>
      'Tap a past day or today to change its Came / Not came mark. Future days cannot be marked.';

  @override
  String get tutorialTotalTitle => 'Check the running total';

  @override
  String get tutorialTotalBody =>
      'The total below the calendar updates from delivery days, daily quantity and price.';

  @override
  String get tutorialBillTotalTitle => 'Review the bill';

  @override
  String get tutorialBillTotalBody =>
      'Check the delivery counts and total for this account and month. Bill opens on the previous month by default.';

  @override
  String get tutorialShareTitle => 'Share on WhatsApp';

  @override
  String get tutorialShareBody =>
      'Tap Share on WhatsApp to send the bill. Review it and choose the recipient before sending.';

  @override
  String get tutorialPaidTitle => 'Record your payment';

  @override
  String get tutorialPaidBody =>
      'After you pay the vendor, tap Mark paid. This records the payment status; it does not send money.';

  @override
  String get today => 'Today';

  @override
  String get month => 'Month';

  @override
  String get appName => 'Hisab Diary';

  @override
  String get bill => 'Bill';

  @override
  String get storageError => 'Your diary could not open. Please try again.';

  @override
  String get loading => 'Opening your diary';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Try again';

  @override
  String get privacy =>
      'Your diary works offline without login. Diary records stay on this phone unless you share or export them. Release builds use Google Firebase to collect app usage and technical diagnostics for analytics, crash reports and performance monitoring.';

  @override
  String get notCame => 'Not came';

  @override
  String get saveError => 'Could not save your change. Please try again.';

  @override
  String get piece => 'piece';

  @override
  String get noDeliveries => 'No deliveries scheduled for today';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get hindi => 'Hindi';

  @override
  String get addNew => '＋ Add a vendor';

  @override
  String get litre => 'litre';

  @override
  String get milk => 'Milk';

  @override
  String openMonth(String vendor) {
    return 'Open the month for $vendor';
  }

  @override
  String get marathi => 'Marathi';

  @override
  String get saving => 'Saving…';

  @override
  String get carCleaner => 'Car cleaner';

  @override
  String get gujarati => 'Gujarati';

  @override
  String get english => 'English';

  @override
  String get continueLabel => 'Continue';

  @override
  String get visit => 'visit';

  @override
  String get other => 'Other';

  @override
  String get came => 'Came';

  @override
  String get addFirst => '＋ Add your first vendor';

  @override
  String get languageLater => 'You can change this later in Settings';

  @override
  String get tiffin => 'Tiffin';

  @override
  String get maid => 'Maid';

  @override
  String get allCame => 'All came';

  @override
  String get newspaper => 'Newspaper';

  @override
  String get hindiNative => 'हिन्दी';

  @override
  String get marathiNative => 'मराठी';

  @override
  String get gujaratiNative => 'ગુજરાતી';

  @override
  String get englishNative => 'English';

  @override
  String get friday => 'Friday';

  @override
  String get invalidVendorAmount =>
      'Enter a valid number: quantity must be above 0 and price cannot be negative.';

  @override
  String get dailyQuantity => 'Daily quantity';

  @override
  String unitRate(String unit) {
    return 'Rate per $unit';
  }

  @override
  String get saturday => 'Saturday';

  @override
  String get chooseOne => 'Choose one';

  @override
  String get sunday => 'Sunday';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saveVendor => 'Save';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get back => 'Back';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get pickVendorType => 'What would you like to add?';

  @override
  String get decreaseRate => 'Decrease rate';

  @override
  String get thursday => 'Thursday';

  @override
  String get mondayShort => 'Mon';

  @override
  String get monday => 'Monday';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get optionalName => 'Name (optional)';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get chooseWeekday => 'Choose at least one weekday';

  @override
  String get someDays => 'Some days';

  @override
  String get everyDay => 'Every day';

  @override
  String get sundayShort => 'Sun';

  @override
  String get nameHint => 'Vendor name';

  @override
  String get increaseRate => 'Increase rate';

  @override
  String get deliverySchedule => 'When do they come?';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get unmarked => 'Unmarked';

  @override
  String get runningTotal => 'Running total';

  @override
  String get autoCame => 'Automatically counted as came';

  @override
  String get calendarHint => 'Tap a day to change came / not came';

  @override
  String get nextMonth => 'Next month';

  @override
  String notCameCount(String count) {
    return 'Not came: $count days';
  }

  @override
  String autoCounted(String count) {
    return 'Unmarked counted as came: $count days';
  }

  @override
  String get dayUnavailable => 'This day is unavailable';

  @override
  String cameCount(String count) {
    return 'Came: $count days';
  }

  @override
  String get chooseVendor => 'Choose a vendor';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get noVendorsCalendar => 'Add your first vendor to see the calendar.';

  @override
  String get backupTooLarge =>
      'The backup is larger than 10 MB. Choose a smaller file.';

  @override
  String get shareError => 'Could not share. Please try again.';

  @override
  String get textSize => 'Text size';

  @override
  String get restoreSuccess => 'Backup restored';

  @override
  String get largeText => 'Large text';

  @override
  String get languageLabel => 'Language';

  @override
  String get paid => 'Paid';

  @override
  String get textSizeSample => 'A';

  @override
  String get invalidBackup =>
      'This is not a valid Hisab Diary backup. Your diary was not changed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get normalText => 'Normal text';

  @override
  String get shareWhatsApp => 'Share on WhatsApp';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get markPaid => 'Mark as paid';

  @override
  String get noVendorsBill => 'Add your first vendor to create a bill.';

  @override
  String get countUnmarkedLabel => 'Unmarked days count as came';

  @override
  String dayCount(String count) {
    return '$count days';
  }

  @override
  String billMessage(
    String name,
    String month,
    String vendorType,
    String days,
    String quantity,
    String unit,
    String total,
    String appName,
  ) {
    return 'Hello $name 🙏\n$month $vendorType bill: $days days × $quantity $unit = $total.\nThank you! — $appName\nPlay Store: [link coming soon]';
  }

  @override
  String get totalDue => 'Total due';

  @override
  String get smallText => 'Small text';

  @override
  String restoreSummary(String vendorCount, String entryCount) {
    return 'Replace the diary on this phone with $vendorCount vendors and $entryCount daily marks? This replaces existing vendors, marks, rates, payments and settings.';
  }

  @override
  String get shareBackup => 'Share backup';

  @override
  String get eveningReminder => 'Evening reminder';

  @override
  String get restoreError =>
      'Could not restore the backup. Your diary was not changed.';

  @override
  String get genericVendorName => 'friend';

  @override
  String get reminderQuestion => 'Did everything come today?';

  @override
  String get reminderAllCame => 'Yes, all came';

  @override
  String get reminderView => 'View today';

  @override
  String reminderAt(String time) {
    return 'Reminder at $time';
  }

  @override
  String get reminderPermission =>
      'Allow notifications in phone settings, then turn the reminder on again.';

  @override
  String get reminderError =>
      'Could not save or deliver the reminder. Check permissions and mark today in the diary if needed.';

  @override
  String get reminderApproximate =>
      'Exact alarms are off. The reminder may arrive a little later.';

  @override
  String get reminderHelpTitle => 'Reminder help';

  @override
  String get reminderBatteryIntro =>
      'Some phones pause apps in the background. If reminders are missing, allow Hisab Diary to run in the background. Names vary by phone.';

  @override
  String get reminderXiaomi =>
      'Xiaomi: allow Autostart and choose No restrictions for the app battery setting.';

  @override
  String get reminderOppo =>
      'Oppo: allow auto launch and background activity in app or battery settings.';

  @override
  String get reminderVivo =>
      'Vivo: allow Autostart and background power use for Hisab Diary.';

  @override
  String get reminderRealme =>
      'Realme: allow auto launch and background activity in app battery management.';

  @override
  String get openBatterySettings => 'Open phone settings';

  @override
  String get testReminder => 'Test reminder';

  @override
  String get enableReminderFirst =>
      'Turn on the evening reminder and allow notifications first.';

  @override
  String get testReminderSent =>
      'Test notification sent. Check your notification panel.';

  @override
  String get proUpgradeTitle => 'More accounts. One simple diary.';

  @override
  String get proEverydayHeading => 'Everyday features in Free and Pro';

  @override
  String get proDailyHook => 'Mark milk and household deliveries with one tap.';

  @override
  String get proRecordsHook =>
      'Clear daily records mean fewer month-end arguments.';

  @override
  String get proShareHook => 'Share the monthly bill on WhatsApp.';

  @override
  String get proOfflineHook => 'Keep your accounts without internet or login.';

  @override
  String get proContinue => 'Back to my diary';

  @override
  String get proPremium => 'Premium';

  @override
  String get proFree => 'Free';

  @override
  String get proVendorCaption => 'Active vendors';

  @override
  String get proOneTime => 'One-time purchase. No subscription.';

  @override
  String get proLocalDiary => 'Your diary stays on this phone.';

  @override
  String get proCapacity => 'Manage up to 12 active vendor accounts.';

  @override
  String get proTitle => 'Hisab Diary Pro';

  @override
  String get proActive => 'Pro is active — up to 12 active vendors';

  @override
  String get proDescription => 'One purchase, more household accounts';

  @override
  String get proLimits =>
      'Free: 3 active vendors. Pro: 12 active vendors. Your diary stays on this phone.';

  @override
  String buyPro(String price) {
    return 'Get Pro · $price';
  }

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get purchasePending => 'Waiting for the store…';

  @override
  String get storeUnavailable =>
      'Pro is unavailable in the store right now. Please try again later.';

  @override
  String get purchaseError =>
      'Could not complete the purchase. Check the Play Store and try again.';

  @override
  String get purchaseCanceled =>
      'Purchase canceled. Your plan has not changed.';

  @override
  String get noProPurchase =>
      'No Pro purchase was found for this Play Store account.';

  @override
  String vendorLimitReached(String limit) {
    return 'Your plan allows $limit active vendors. Archive an account or get Pro in Settings.';
  }

  @override
  String get manageVendors => 'Manage accounts';

  @override
  String get archiveVendor => 'Archive account';

  @override
  String get activateVendor => 'Make active again';

  @override
  String get archiveExplanation =>
      'Archiving removes an account from Today. Daily marks, rates and paid bills are kept. You can make it active again.';

  @override
  String get vendorArchived => 'Archived';

  @override
  String get vendorActive => 'Active';

  @override
  String get splashTagline => 'Everyday accounts, made simple.';

  @override
  String get shareVendorName => 'Vendor name';

  @override
  String get shareService => 'Service';

  @override
  String get shareBillingMonth => 'Billing month';

  @override
  String get shareDailyQuantity => 'Quantity per day';

  @override
  String get shareCalculation => 'Calculation (days × daily quantity × rate)';

  @override
  String get shareTotalAmount => 'Total amount';

  @override
  String get shareSource => 'Shared from';

  @override
  String get vegetables => 'Vegetables';

  @override
  String get fruits => 'Fruits';

  @override
  String get groceries => 'Groceries';

  @override
  String get waterDelivery => 'Water delivery';

  @override
  String get eggs => 'Eggs';

  @override
  String get bread => 'Bread';

  @override
  String get laundry => 'Laundry';

  @override
  String get ironing => 'Ironing';

  @override
  String get cook => 'Cook';

  @override
  String get gardener => 'Gardener';

  @override
  String get houseCleaning => 'House cleaning';

  @override
  String get cookingGas => 'Cooking gas';

  @override
  String get kilogram => 'kg';

  @override
  String get proComingSoon => 'Pro coming soon';

  @override
  String get allFeaturesFree =>
      'All current features are free, with unlimited vendor accounts.';

  @override
  String get tamil => 'Tamil';

  @override
  String get urdu => 'Urdu';

  @override
  String get bengali => 'Bengali';

  @override
  String get telugu => 'Telugu';

  @override
  String get kannada => 'Kannada';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyOpenError =>
      'Could not open the privacy policy. Please check your browser and internet connection.';

  @override
  String get accountTitle => 'Your account';

  @override
  String get accountIntro =>
      'Sign-in is optional. Your diary stays on this device. Cloud backup will be added later.';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetSent =>
      'If an account exists for this email, a password reset link will be sent. Check your inbox.';

  @override
  String get authEmailInvalid => 'Enter a valid email address.';

  @override
  String get authPasswordRequired => 'Enter your password.';

  @override
  String get authPasswordWeak => 'Use at least 6 characters for your password.';

  @override
  String get authPasswordMismatch => 'Passwords do not match.';

  @override
  String get authInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get authEmailUsed =>
      'This email already has an account. Sign in instead.';

  @override
  String get authNetworkError =>
      'Check your internet connection and try again.';

  @override
  String get authUnavailable =>
      'Sign-in is unavailable. Please check the Firebase setup.';

  @override
  String get authTryAgain =>
      'Could not complete this action. Please try again later.';

  @override
  String get authRecentLogin =>
      'Sign out and sign in again before deleting your account.';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirm =>
      'Delete your sign-in account? Your diary records on this device will remain.';

  @override
  String get signedInAs => 'Signed in as';

  @override
  String get continueOffline => 'Continue offline';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get helpAssistant => 'Help assistant';

  @override
  String get helpIntro =>
      'Ask how to use your diary, or choose a task below. We will open the screen and guide you.';

  @override
  String get helpQuestion => 'What would you like to do?';

  @override
  String get helpShowMe => 'Show me';

  @override
  String get helpNoMatch => 'Choose a task below so we can guide you.';

  @override
  String get helpChoices => 'Which task would you like help with?';

  @override
  String get helpReminderBody =>
      'Turn on the reminder switch, allow notifications when asked, then choose your reminder time.';

  @override
  String get helpBackupBody =>
      'Tap here to export your diary backup. Save the file somewhere you can find it later.';

  @override
  String get helpRestoreBody =>
      'Tap here to choose a saved backup. Review the confirmation carefully: restoring replaces the diary on this device.';

  @override
  String get assistantHello => 'Hi! I’m your diary helper.';

  @override
  String get assistantWelcome =>
      'Tap my floating pencil anytime you need help. Choose a task or ask a question, and I’ll show you where to tap. Let’s start with a quick tour!';
}
