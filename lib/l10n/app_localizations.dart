import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('hi'),
    Locale('en'),
    Locale('gu'),
    Locale('mr'),
    Locale('ta'),
    Locale('ur'),
    Locale('bn'),
    Locale('te'),
    Locale('kn'),
  ];

  /// No description provided for @tutorialAddTitle.
  ///
  /// In hi, this message translates to:
  /// **'अपना खाता जोड़ें'**
  String get tutorialAddTitle;

  /// No description provided for @tutorialAddBody.
  ///
  /// In hi, this message translates to:
  /// **'खाता जोड़ें पर टैप करके दूध, अख़बार या दूसरी सेवा चुनें। रोज़ की मात्रा और कीमत डालकर सेव करें।'**
  String get tutorialAddBody;

  /// No description provided for @tutorialMarkTitle.
  ///
  /// In hi, this message translates to:
  /// **'आज की सेवा दर्ज करें'**
  String get tutorialMarkTitle;

  /// No description provided for @tutorialMarkBody.
  ///
  /// In hi, this message translates to:
  /// **'खाते पर आया या नहीं आया दबाएँ। वही निशान दोबारा दबाकर हटा सकते हैं। खाते के नाम पर टैप करके कैलेंडर खोलें।'**
  String get tutorialMarkBody;

  /// No description provided for @tutorialAllTitle.
  ///
  /// In hi, this message translates to:
  /// **'सब आया?'**
  String get tutorialAllTitle;

  /// No description provided for @tutorialAllBody.
  ///
  /// In hi, this message translates to:
  /// **'सब आया दबाकर आज की सभी तय सेवाओं को एक साथ दर्ज करें।'**
  String get tutorialAllBody;

  /// No description provided for @tutorialTabsTitle.
  ///
  /// In hi, this message translates to:
  /// **'आपकी डायरी एक नज़र में'**
  String get tutorialTabsTitle;

  /// No description provided for @tutorialTabsBody.
  ///
  /// In hi, this message translates to:
  /// **'आज में रोज़ का हिसाब दर्ज करें। महीना में कैलेंडर देखें। बिल में कुल हिसाब निकालकर WhatsApp पर भेजें। सेटिंग में भाषा और रिमाइंडर हैं।'**
  String get tutorialTabsBody;

  /// No description provided for @tutorialNext.
  ///
  /// In hi, this message translates to:
  /// **'आगे'**
  String get tutorialNext;

  /// No description provided for @tutorialDone.
  ///
  /// In hi, this message translates to:
  /// **'डायरी शुरू करें'**
  String get tutorialDone;

  /// No description provided for @tutorialSkip.
  ///
  /// In hi, this message translates to:
  /// **'ट्यूटोरियल छोड़ें'**
  String get tutorialSkip;

  /// No description provided for @tutorialVendorTitle.
  ///
  /// In hi, this message translates to:
  /// **'खाता चुनें'**
  String get tutorialVendorTitle;

  /// No description provided for @tutorialVendorBody.
  ///
  /// In hi, this message translates to:
  /// **'विक्रेता चुनें पर टैप करके अपने घर के खातों में बदलें।'**
  String get tutorialVendorBody;

  /// No description provided for @tutorialMonthTitle.
  ///
  /// In hi, this message translates to:
  /// **'महीना चुनें'**
  String get tutorialMonthTitle;

  /// No description provided for @tutorialMonthBody.
  ///
  /// In hi, this message translates to:
  /// **'बाएँ और दाएँ तीर से महीना बदलें।'**
  String get tutorialMonthBody;

  /// No description provided for @tutorialCalendarTitle.
  ///
  /// In hi, this message translates to:
  /// **'रोज़ का निशान बदलें'**
  String get tutorialCalendarTitle;

  /// No description provided for @tutorialCalendarBody.
  ///
  /// In hi, this message translates to:
  /// **'पिछले दिन या आज पर टैप करके आया / नहीं आया बदलें। आने वाले दिन दर्ज नहीं कर सकते।'**
  String get tutorialCalendarBody;

  /// No description provided for @tutorialTotalTitle.
  ///
  /// In hi, this message translates to:
  /// **'कुल हिसाब देखें'**
  String get tutorialTotalTitle;

  /// No description provided for @tutorialTotalBody.
  ///
  /// In hi, this message translates to:
  /// **'कैलेंडर के नीचे कुल रकम सेवा के दिनों, रोज़ की मात्रा और कीमत से बदलती है।'**
  String get tutorialTotalBody;

  /// No description provided for @tutorialBillTotalTitle.
  ///
  /// In hi, this message translates to:
  /// **'बिल जाँचें'**
  String get tutorialBillTotalTitle;

  /// No description provided for @tutorialBillTotalBody.
  ///
  /// In hi, this message translates to:
  /// **'इस खाते और महीने के सेवा दिनों और कुल रकम की जाँच करें। बिल पहले पिछले महीने का खुलता है।'**
  String get tutorialBillTotalBody;

  /// No description provided for @tutorialShareTitle.
  ///
  /// In hi, this message translates to:
  /// **'WhatsApp पर भेजें'**
  String get tutorialShareTitle;

  /// No description provided for @tutorialShareBody.
  ///
  /// In hi, this message translates to:
  /// **'बिल भेजने के लिए WhatsApp पर भेजें दबाएँ। भेजने से पहले बिल जाँचें और प्राप्तकर्ता चुनें।'**
  String get tutorialShareBody;

  /// No description provided for @tutorialPaidTitle.
  ///
  /// In hi, this message translates to:
  /// **'भुगतान दर्ज करें'**
  String get tutorialPaidTitle;

  /// No description provided for @tutorialPaidBody.
  ///
  /// In hi, this message translates to:
  /// **'विक्रेता को भुगतान करने के बाद भुगतान किया दबाएँ। यह केवल भुगतान की स्थिति दर्ज करता है, पैसे नहीं भेजता।'**
  String get tutorialPaidBody;

  /// No description provided for @today.
  ///
  /// In hi, this message translates to:
  /// **'आज'**
  String get today;

  /// No description provided for @month.
  ///
  /// In hi, this message translates to:
  /// **'महीना'**
  String get month;

  /// No description provided for @appName.
  ///
  /// In hi, this message translates to:
  /// **'हिसाब डायरी'**
  String get appName;

  /// No description provided for @bill.
  ///
  /// In hi, this message translates to:
  /// **'बिल'**
  String get bill;

  /// No description provided for @storageError.
  ///
  /// In hi, this message translates to:
  /// **'डायरी नहीं खुल सकी। कृपया फिर कोशिश करें।'**
  String get storageError;

  /// No description provided for @loading.
  ///
  /// In hi, this message translates to:
  /// **'डायरी खुल रही है'**
  String get loading;

  /// No description provided for @settings.
  ///
  /// In hi, this message translates to:
  /// **'सेटिंग'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In hi, this message translates to:
  /// **'फिर कोशिश करें'**
  String get retry;

  /// No description provided for @privacy.
  ///
  /// In hi, this message translates to:
  /// **'आपकी डायरी बिना लॉगिन के ऑफलाइन चलती है। रिकॉर्ड इसी फोन पर रहते हैं, जब तक आप उन्हें साझा या निर्यात न करें। रिलीज़ संस्करण उपयोग के आँकड़े, क्रैश रिपोर्ट और प्रदर्शन की निगरानी के लिए Google Firebase से ऐप उपयोग और तकनीकी जानकारी एकत्र करते हैं।'**
  String get privacy;

  /// No description provided for @notCame.
  ///
  /// In hi, this message translates to:
  /// **'नहीं'**
  String get notCame;

  /// No description provided for @saveError.
  ///
  /// In hi, this message translates to:
  /// **'बदलाव सेव नहीं हुआ। फिर कोशिश करें।'**
  String get saveError;

  /// No description provided for @piece.
  ///
  /// In hi, this message translates to:
  /// **'नग'**
  String get piece;

  /// No description provided for @noDeliveries.
  ///
  /// In hi, this message translates to:
  /// **'आज के लिए कोई हिसाब नहीं है'**
  String get noDeliveries;

  /// No description provided for @chooseLanguage.
  ///
  /// In hi, this message translates to:
  /// **'अपनी भाषा चुनिए'**
  String get chooseLanguage;

  /// No description provided for @hindi.
  ///
  /// In hi, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @addNew.
  ///
  /// In hi, this message translates to:
  /// **'＋ नया हिसाब जोड़ें'**
  String get addNew;

  /// No description provided for @litre.
  ///
  /// In hi, this message translates to:
  /// **'लीटर'**
  String get litre;

  /// No description provided for @milk.
  ///
  /// In hi, this message translates to:
  /// **'दूध'**
  String get milk;

  /// No description provided for @openMonth.
  ///
  /// In hi, this message translates to:
  /// **'{vendor} का महीना खोलें'**
  String openMonth(String vendor);

  /// No description provided for @marathi.
  ///
  /// In hi, this message translates to:
  /// **'मराठी'**
  String get marathi;

  /// No description provided for @saving.
  ///
  /// In hi, this message translates to:
  /// **'सेव हो रहा है…'**
  String get saving;

  /// No description provided for @carCleaner.
  ///
  /// In hi, this message translates to:
  /// **'गाड़ी की सफ़ाई'**
  String get carCleaner;

  /// No description provided for @gujarati.
  ///
  /// In hi, this message translates to:
  /// **'गुजराती'**
  String get gujarati;

  /// No description provided for @english.
  ///
  /// In hi, this message translates to:
  /// **'अंग्रेज़ी'**
  String get english;

  /// No description provided for @continueLabel.
  ///
  /// In hi, this message translates to:
  /// **'आगे बढ़िए'**
  String get continueLabel;

  /// No description provided for @visit.
  ///
  /// In hi, this message translates to:
  /// **'बार'**
  String get visit;

  /// No description provided for @other.
  ///
  /// In hi, this message translates to:
  /// **'अन्य'**
  String get other;

  /// No description provided for @came.
  ///
  /// In hi, this message translates to:
  /// **'आया'**
  String get came;

  /// No description provided for @addFirst.
  ///
  /// In hi, this message translates to:
  /// **'＋ पहला हिसाब जोड़ें'**
  String get addFirst;

  /// No description provided for @languageLater.
  ///
  /// In hi, this message translates to:
  /// **'बाद में सेटिंग में बदल सकते हैं'**
  String get languageLater;

  /// No description provided for @tiffin.
  ///
  /// In hi, this message translates to:
  /// **'टिफ़िन'**
  String get tiffin;

  /// No description provided for @maid.
  ///
  /// In hi, this message translates to:
  /// **'कामवाली'**
  String get maid;

  /// No description provided for @allCame.
  ///
  /// In hi, this message translates to:
  /// **'सब आया'**
  String get allCame;

  /// No description provided for @newspaper.
  ///
  /// In hi, this message translates to:
  /// **'अख़बार'**
  String get newspaper;

  /// No description provided for @hindiNative.
  ///
  /// In hi, this message translates to:
  /// **'हिन्दी'**
  String get hindiNative;

  /// No description provided for @marathiNative.
  ///
  /// In hi, this message translates to:
  /// **'मराठी'**
  String get marathiNative;

  /// No description provided for @gujaratiNative.
  ///
  /// In hi, this message translates to:
  /// **'ગુજરાતી'**
  String get gujaratiNative;

  /// No description provided for @englishNative.
  ///
  /// In hi, this message translates to:
  /// **'English'**
  String get englishNative;

  /// No description provided for @friday.
  ///
  /// In hi, this message translates to:
  /// **'शुक्रवार'**
  String get friday;

  /// No description provided for @invalidVendorAmount.
  ///
  /// In hi, this message translates to:
  /// **'सही संख्या डालें: मात्रा 0 से ज़्यादा और कीमत 0 या उससे ज़्यादा होनी चाहिए।'**
  String get invalidVendorAmount;

  /// No description provided for @dailyQuantity.
  ///
  /// In hi, this message translates to:
  /// **'रोज़ कितना?'**
  String get dailyQuantity;

  /// No description provided for @unitRate.
  ///
  /// In hi, this message translates to:
  /// **'एक {unit} का रेट'**
  String unitRate(String unit);

  /// No description provided for @saturday.
  ///
  /// In hi, this message translates to:
  /// **'शनिवार'**
  String get saturday;

  /// No description provided for @chooseOne.
  ///
  /// In hi, this message translates to:
  /// **'एक चुनिए'**
  String get chooseOne;

  /// No description provided for @sunday.
  ///
  /// In hi, this message translates to:
  /// **'रविवार'**
  String get sunday;

  /// No description provided for @fridayShort.
  ///
  /// In hi, this message translates to:
  /// **'शु'**
  String get fridayShort;

  /// No description provided for @saveVendor.
  ///
  /// In hi, this message translates to:
  /// **'सेव करें'**
  String get saveVendor;

  /// No description provided for @decreaseQuantity.
  ///
  /// In hi, this message translates to:
  /// **'मात्रा घटाएँ'**
  String get decreaseQuantity;

  /// No description provided for @tuesdayShort.
  ///
  /// In hi, this message translates to:
  /// **'मं'**
  String get tuesdayShort;

  /// No description provided for @back.
  ///
  /// In hi, this message translates to:
  /// **'वापस'**
  String get back;

  /// No description provided for @tuesday.
  ///
  /// In hi, this message translates to:
  /// **'मंगलवार'**
  String get tuesday;

  /// No description provided for @pickVendorType.
  ///
  /// In hi, this message translates to:
  /// **'क्या जोड़ना है?'**
  String get pickVendorType;

  /// No description provided for @decreaseRate.
  ///
  /// In hi, this message translates to:
  /// **'रेट घटाएँ'**
  String get decreaseRate;

  /// No description provided for @thursday.
  ///
  /// In hi, this message translates to:
  /// **'गुरुवार'**
  String get thursday;

  /// No description provided for @mondayShort.
  ///
  /// In hi, this message translates to:
  /// **'सो'**
  String get mondayShort;

  /// No description provided for @monday.
  ///
  /// In hi, this message translates to:
  /// **'सोमवार'**
  String get monday;

  /// No description provided for @thursdayShort.
  ///
  /// In hi, this message translates to:
  /// **'गु'**
  String get thursdayShort;

  /// No description provided for @wednesday.
  ///
  /// In hi, this message translates to:
  /// **'बुधवार'**
  String get wednesday;

  /// No description provided for @optionalName.
  ///
  /// In hi, this message translates to:
  /// **'नाम (चाहें तो)'**
  String get optionalName;

  /// No description provided for @increaseQuantity.
  ///
  /// In hi, this message translates to:
  /// **'मात्रा बढ़ाएँ'**
  String get increaseQuantity;

  /// No description provided for @wednesdayShort.
  ///
  /// In hi, this message translates to:
  /// **'बु'**
  String get wednesdayShort;

  /// No description provided for @chooseWeekday.
  ///
  /// In hi, this message translates to:
  /// **'कम से कम एक दिन चुनिए'**
  String get chooseWeekday;

  /// No description provided for @someDays.
  ///
  /// In hi, this message translates to:
  /// **'कुछ दिन'**
  String get someDays;

  /// No description provided for @everyDay.
  ///
  /// In hi, this message translates to:
  /// **'रोज़'**
  String get everyDay;

  /// No description provided for @sundayShort.
  ///
  /// In hi, this message translates to:
  /// **'र'**
  String get sundayShort;

  /// No description provided for @nameHint.
  ///
  /// In hi, this message translates to:
  /// **'हिसाब वाले का नाम'**
  String get nameHint;

  /// No description provided for @increaseRate.
  ///
  /// In hi, this message translates to:
  /// **'रेट बढ़ाएँ'**
  String get increaseRate;

  /// No description provided for @deliverySchedule.
  ///
  /// In hi, this message translates to:
  /// **'कब आता है?'**
  String get deliverySchedule;

  /// No description provided for @saturdayShort.
  ///
  /// In hi, this message translates to:
  /// **'श'**
  String get saturdayShort;

  /// No description provided for @unmarked.
  ///
  /// In hi, this message translates to:
  /// **'अभी नहीं बताया'**
  String get unmarked;

  /// No description provided for @runningTotal.
  ///
  /// In hi, this message translates to:
  /// **'अब तक का कुल'**
  String get runningTotal;

  /// No description provided for @autoCame.
  ///
  /// In hi, this message translates to:
  /// **'बिना बताए आया गिना'**
  String get autoCame;

  /// No description provided for @calendarHint.
  ///
  /// In hi, this message translates to:
  /// **'किसी दिन को छूकर हरा / लाल बदलिए'**
  String get calendarHint;

  /// No description provided for @nextMonth.
  ///
  /// In hi, this message translates to:
  /// **'अगला महीना'**
  String get nextMonth;

  /// No description provided for @notCameCount.
  ///
  /// In hi, this message translates to:
  /// **'नहीं {count} दिन'**
  String notCameCount(String count);

  /// No description provided for @autoCounted.
  ///
  /// In hi, this message translates to:
  /// **'बिना बताए आया गिना: {count} दिन'**
  String autoCounted(String count);

  /// No description provided for @dayUnavailable.
  ///
  /// In hi, this message translates to:
  /// **'यह दिन उपलब्ध नहीं है'**
  String get dayUnavailable;

  /// No description provided for @cameCount.
  ///
  /// In hi, this message translates to:
  /// **'आया {count} दिन'**
  String cameCount(String count);

  /// No description provided for @chooseVendor.
  ///
  /// In hi, this message translates to:
  /// **'हिसाब चुनिए'**
  String get chooseVendor;

  /// No description provided for @previousMonth.
  ///
  /// In hi, this message translates to:
  /// **'पिछला महीना'**
  String get previousMonth;

  /// No description provided for @noVendorsCalendar.
  ///
  /// In hi, this message translates to:
  /// **'कैलेंडर देखने के लिए पहला हिसाब जोड़िए।'**
  String get noVendorsCalendar;

  /// No description provided for @backupTooLarge.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप 10 MB से बड़ा है। छोटी फ़ाइल चुनिए।'**
  String get backupTooLarge;

  /// No description provided for @shareError.
  ///
  /// In hi, this message translates to:
  /// **'साझा नहीं हो सका। कृपया फिर कोशिश करें।'**
  String get shareError;

  /// No description provided for @textSize.
  ///
  /// In hi, this message translates to:
  /// **'अक्षर का आकार'**
  String get textSize;

  /// No description provided for @restoreSuccess.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप वापस आ गया'**
  String get restoreSuccess;

  /// No description provided for @largeText.
  ///
  /// In hi, this message translates to:
  /// **'बड़े अक्षर'**
  String get largeText;

  /// No description provided for @languageLabel.
  ///
  /// In hi, this message translates to:
  /// **'भाषा'**
  String get languageLabel;

  /// No description provided for @paid.
  ///
  /// In hi, this message translates to:
  /// **'चुका दिया'**
  String get paid;

  /// No description provided for @textSizeSample.
  ///
  /// In hi, this message translates to:
  /// **'अ'**
  String get textSizeSample;

  /// No description provided for @invalidBackup.
  ///
  /// In hi, this message translates to:
  /// **'यह हिसाब डायरी का मान्य बैकअप नहीं है। आपकी डायरी नहीं बदली।'**
  String get invalidBackup;

  /// No description provided for @cancel.
  ///
  /// In hi, this message translates to:
  /// **'रद्द करें'**
  String get cancel;

  /// No description provided for @normalText.
  ///
  /// In hi, this message translates to:
  /// **'सामान्य अक्षर'**
  String get normalText;

  /// No description provided for @shareWhatsApp.
  ///
  /// In hi, this message translates to:
  /// **'WhatsApp पर भेजिए'**
  String get shareWhatsApp;

  /// No description provided for @restoreBackup.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप वापस लाएँ'**
  String get restoreBackup;

  /// No description provided for @markPaid.
  ///
  /// In hi, this message translates to:
  /// **'चुका दिया'**
  String get markPaid;

  /// No description provided for @noVendorsBill.
  ///
  /// In hi, this message translates to:
  /// **'बिल बनाने के लिए पहला हिसाब जोड़िए।'**
  String get noVendorsBill;

  /// No description provided for @countUnmarkedLabel.
  ///
  /// In hi, this message translates to:
  /// **'बिना बताए = आया गिनो'**
  String get countUnmarkedLabel;

  /// No description provided for @dayCount.
  ///
  /// In hi, this message translates to:
  /// **'{count} दिन'**
  String dayCount(String count);

  /// No description provided for @billMessage.
  ///
  /// In hi, this message translates to:
  /// **'नमस्ते {name} 🙏\n{month} का {vendorType} हिसाब: {days} दिन × {quantity} {unit} = {total}.\nधन्यवाद! — {appName}\nPlay Store: [लिंक जल्द आएगा]'**
  String billMessage(
    String name,
    String month,
    String vendorType,
    String days,
    String quantity,
    String unit,
    String total,
    String appName,
  );

  /// No description provided for @totalDue.
  ///
  /// In hi, this message translates to:
  /// **'कुल देना है'**
  String get totalDue;

  /// No description provided for @smallText.
  ///
  /// In hi, this message translates to:
  /// **'छोटे अक्षर'**
  String get smallText;

  /// No description provided for @restoreSummary.
  ///
  /// In hi, this message translates to:
  /// **'इस फ़ोन की डायरी में {vendorCount} हिसाब और {entryCount} दैनिक निशान वापस आएँगे। मौजूदा हिसाब, निशान, रेट, भुगतान और सेटिंग बदल जाएँगे। जारी रखें?'**
  String restoreSummary(String vendorCount, String entryCount);

  /// No description provided for @shareBackup.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप भेजिए'**
  String get shareBackup;

  /// No description provided for @eveningReminder.
  ///
  /// In hi, this message translates to:
  /// **'शाम का रिमाइंडर'**
  String get eveningReminder;

  /// No description provided for @restoreError.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप वापस नहीं आ सका। आपकी डायरी नहीं बदली।'**
  String get restoreError;

  /// No description provided for @genericVendorName.
  ///
  /// In hi, this message translates to:
  /// **'जी'**
  String get genericVendorName;

  /// No description provided for @reminderQuestion.
  ///
  /// In hi, this message translates to:
  /// **'आज सब आया?'**
  String get reminderQuestion;

  /// No description provided for @reminderAllCame.
  ///
  /// In hi, this message translates to:
  /// **'हाँ, सब आया'**
  String get reminderAllCame;

  /// No description provided for @reminderView.
  ///
  /// In hi, this message translates to:
  /// **'देखिए'**
  String get reminderView;

  /// No description provided for @reminderAt.
  ///
  /// In hi, this message translates to:
  /// **'याद दिलाएँ: {time}'**
  String reminderAt(String time);

  /// No description provided for @reminderPermission.
  ///
  /// In hi, this message translates to:
  /// **'फोन की सेटिंग में नोटिफ़िकेशन की अनुमति दें, फिर याद दिलाना चालू करें।'**
  String get reminderPermission;

  /// No description provided for @reminderError.
  ///
  /// In hi, this message translates to:
  /// **'याद दिलाना या हिसाब सेव करना नहीं हो पाया। अनुमति जाँचें और ज़रूरत हो तो आज का हिसाब डायरी में दर्ज करें।'**
  String get reminderError;

  /// No description provided for @reminderApproximate.
  ///
  /// In hi, this message translates to:
  /// **'सटीक अलार्म बंद है। याद दिलाने में थोड़ी देर हो सकती है।'**
  String get reminderApproximate;

  /// No description provided for @reminderHelpTitle.
  ///
  /// In hi, this message translates to:
  /// **'याद दिलाने में मदद'**
  String get reminderHelpTitle;

  /// No description provided for @reminderBatteryIntro.
  ///
  /// In hi, this message translates to:
  /// **'कुछ फोन बैकग्राउंड में ऐप बंद कर देते हैं। याद न दिलाने पर हिसाब डायरी को बैकग्राउंड में चलने दें। सेटिंग के नाम फोन के अनुसार बदल सकते हैं।'**
  String get reminderBatteryIntro;

  /// No description provided for @reminderXiaomi.
  ///
  /// In hi, this message translates to:
  /// **'Xiaomi: ऑटोस्टार्ट की अनुमति दें और ऐप की बैटरी सेटिंग में कोई पाबंदी नहीं चुनें।'**
  String get reminderXiaomi;

  /// No description provided for @reminderOppo.
  ///
  /// In hi, this message translates to:
  /// **'Oppo: ऐप या बैटरी सेटिंग में अपने आप शुरू होने और बैकग्राउंड में चलने की अनुमति दें।'**
  String get reminderOppo;

  /// No description provided for @reminderVivo.
  ///
  /// In hi, this message translates to:
  /// **'Vivo: हिसाब डायरी के लिए ऑटोस्टार्ट और बैकग्राउंड में बैटरी इस्तेमाल की अनुमति दें।'**
  String get reminderVivo;

  /// No description provided for @reminderRealme.
  ///
  /// In hi, this message translates to:
  /// **'Realme: ऐप की बैटरी सेटिंग में अपने आप शुरू होने और बैकग्राउंड में चलने की अनुमति दें।'**
  String get reminderRealme;

  /// No description provided for @openBatterySettings.
  ///
  /// In hi, this message translates to:
  /// **'फोन की सेटिंग खोलें'**
  String get openBatterySettings;

  /// No description provided for @testReminder.
  ///
  /// In hi, this message translates to:
  /// **'याद दिलाकर जाँचें'**
  String get testReminder;

  /// No description provided for @enableReminderFirst.
  ///
  /// In hi, this message translates to:
  /// **'पहले शाम को याद दिलाना चालू करें और नोटिफ़िकेशन की अनुमति दें।'**
  String get enableReminderFirst;

  /// No description provided for @testReminderSent.
  ///
  /// In hi, this message translates to:
  /// **'जाँच का नोटिफ़िकेशन भेजा गया। फोन के नोटिफ़िकेशन देखें।'**
  String get testReminderSent;

  /// No description provided for @proUpgradeTitle.
  ///
  /// In hi, this message translates to:
  /// **'ज़्यादा खाते। एक आसान डायरी।'**
  String get proUpgradeTitle;

  /// No description provided for @proEverydayHeading.
  ///
  /// In hi, this message translates to:
  /// **'मुफ़्त और प्रो, दोनों में रोज़मर्रा की सुविधाएँ'**
  String get proEverydayHeading;

  /// No description provided for @proDailyHook.
  ///
  /// In hi, this message translates to:
  /// **'दूध और घर की सेवाओं का हिसाब, बस एक टैप।'**
  String get proDailyHook;

  /// No description provided for @proRecordsHook.
  ///
  /// In hi, this message translates to:
  /// **'हर दिन का साफ़ हिसाब, महीने के अंत में कम बहस।'**
  String get proRecordsHook;

  /// No description provided for @proShareHook.
  ///
  /// In hi, this message translates to:
  /// **'महीने का बिल WhatsApp पर भेजें।'**
  String get proShareHook;

  /// No description provided for @proOfflineHook.
  ///
  /// In hi, this message translates to:
  /// **'बिना इंटरनेट या लॉगिन के हिसाब रखें।'**
  String get proOfflineHook;

  /// No description provided for @proContinue.
  ///
  /// In hi, this message translates to:
  /// **'अपनी डायरी पर लौटें'**
  String get proContinue;

  /// No description provided for @proPremium.
  ///
  /// In hi, this message translates to:
  /// **'प्रीमियम'**
  String get proPremium;

  /// No description provided for @proFree.
  ///
  /// In hi, this message translates to:
  /// **'मुफ़्त'**
  String get proFree;

  /// No description provided for @proVendorCaption.
  ///
  /// In hi, this message translates to:
  /// **'सक्रिय खाते'**
  String get proVendorCaption;

  /// No description provided for @proOneTime.
  ///
  /// In hi, this message translates to:
  /// **'एक बार खरीदें। कोई सदस्यता नहीं।'**
  String get proOneTime;

  /// No description provided for @proLocalDiary.
  ///
  /// In hi, this message translates to:
  /// **'आपकी डायरी इसी फ़ोन पर रहती है।'**
  String get proLocalDiary;

  /// No description provided for @proCapacity.
  ///
  /// In hi, this message translates to:
  /// **'12 सक्रिय विक्रेता खातों तक का हिसाब रखें।'**
  String get proCapacity;

  /// No description provided for @proTitle.
  ///
  /// In hi, this message translates to:
  /// **'हिसाब डायरी प्रो'**
  String get proTitle;

  /// No description provided for @proActive.
  ///
  /// In hi, this message translates to:
  /// **'प्रो चालू है — 12 सक्रिय हिसाब तक'**
  String get proActive;

  /// No description provided for @proDescription.
  ///
  /// In hi, this message translates to:
  /// **'एक बार खरीदें, अधिक हिसाब जोड़ें'**
  String get proDescription;

  /// No description provided for @proLimits.
  ///
  /// In hi, this message translates to:
  /// **'मुफ़्त: 3 सक्रिय हिसाब। प्रो: 12 सक्रिय हिसाब। आपकी डायरी इसी फोन पर रहती है।'**
  String get proLimits;

  /// No description provided for @buyPro.
  ///
  /// In hi, this message translates to:
  /// **'प्रो लें · {price}'**
  String buyPro(String price);

  /// No description provided for @restorePurchases.
  ///
  /// In hi, this message translates to:
  /// **'खरीद वापस पाएँ'**
  String get restorePurchases;

  /// No description provided for @purchasePending.
  ///
  /// In hi, this message translates to:
  /// **'स्टोर का इंतज़ार है…'**
  String get purchasePending;

  /// No description provided for @storeUnavailable.
  ///
  /// In hi, this message translates to:
  /// **'प्रो अभी स्टोर में उपलब्ध नहीं है। बाद में फिर कोशिश करें।'**
  String get storeUnavailable;

  /// No description provided for @purchaseError.
  ///
  /// In hi, this message translates to:
  /// **'खरीद पूरी नहीं हो पाई। Play Store जाँचें और फिर कोशिश करें।'**
  String get purchaseError;

  /// No description provided for @purchaseCanceled.
  ///
  /// In hi, this message translates to:
  /// **'खरीद रद्द हुई। आपका प्लान नहीं बदला है।'**
  String get purchaseCanceled;

  /// No description provided for @noProPurchase.
  ///
  /// In hi, this message translates to:
  /// **'इस Play Store खाते में प्रो की खरीद नहीं मिली।'**
  String get noProPurchase;

  /// No description provided for @vendorLimitReached.
  ///
  /// In hi, this message translates to:
  /// **'आपके प्लान में {limit} सक्रिय हिसाब हो सकते हैं। कोई हिसाब संग्रह में रखें या सेटिंग में प्रो लें।'**
  String vendorLimitReached(String limit);

  /// No description provided for @manageVendors.
  ///
  /// In hi, this message translates to:
  /// **'हिसाब सँभालें'**
  String get manageVendors;

  /// No description provided for @archiveVendor.
  ///
  /// In hi, this message translates to:
  /// **'संग्रह में रखें'**
  String get archiveVendor;

  /// No description provided for @activateVendor.
  ///
  /// In hi, this message translates to:
  /// **'फिर सक्रिय करें'**
  String get activateVendor;

  /// No description provided for @archiveExplanation.
  ///
  /// In hi, this message translates to:
  /// **'संग्रह में रखने पर हिसाब आज की सूची से हटता है। पुराने दिन, दरें और चुकाए बिल सुरक्षित रहते हैं। इसे फिर सक्रिय कर सकते हैं।'**
  String get archiveExplanation;

  /// No description provided for @vendorArchived.
  ///
  /// In hi, this message translates to:
  /// **'संग्रह में'**
  String get vendorArchived;

  /// No description provided for @vendorActive.
  ///
  /// In hi, this message translates to:
  /// **'सक्रिय'**
  String get vendorActive;

  /// No description provided for @splashTagline.
  ///
  /// In hi, this message translates to:
  /// **'हर दिन का हिसाब, आसानी से।'**
  String get splashTagline;

  /// No description provided for @shareVendorName.
  ///
  /// In hi, this message translates to:
  /// **'विक्रेता का नाम'**
  String get shareVendorName;

  /// No description provided for @shareService.
  ///
  /// In hi, this message translates to:
  /// **'सेवा'**
  String get shareService;

  /// No description provided for @shareBillingMonth.
  ///
  /// In hi, this message translates to:
  /// **'बिल का महीना'**
  String get shareBillingMonth;

  /// No description provided for @shareDailyQuantity.
  ///
  /// In hi, this message translates to:
  /// **'प्रतिदिन मात्रा'**
  String get shareDailyQuantity;

  /// No description provided for @shareCalculation.
  ///
  /// In hi, this message translates to:
  /// **'गणना (दिन × प्रतिदिन मात्रा × दर)'**
  String get shareCalculation;

  /// No description provided for @shareTotalAmount.
  ///
  /// In hi, this message translates to:
  /// **'कुल राशि'**
  String get shareTotalAmount;

  /// No description provided for @shareSource.
  ///
  /// In hi, this message translates to:
  /// **'साझा किया गया'**
  String get shareSource;

  /// No description provided for @vegetables.
  ///
  /// In hi, this message translates to:
  /// **'सब्ज़ियाँ'**
  String get vegetables;

  /// No description provided for @fruits.
  ///
  /// In hi, this message translates to:
  /// **'फल'**
  String get fruits;

  /// No description provided for @groceries.
  ///
  /// In hi, this message translates to:
  /// **'किराना'**
  String get groceries;

  /// No description provided for @waterDelivery.
  ///
  /// In hi, this message translates to:
  /// **'पानी की डिलीवरी'**
  String get waterDelivery;

  /// No description provided for @eggs.
  ///
  /// In hi, this message translates to:
  /// **'अंडे'**
  String get eggs;

  /// No description provided for @bread.
  ///
  /// In hi, this message translates to:
  /// **'ब्रेड'**
  String get bread;

  /// No description provided for @laundry.
  ///
  /// In hi, this message translates to:
  /// **'कपड़ों की धुलाई'**
  String get laundry;

  /// No description provided for @ironing.
  ///
  /// In hi, this message translates to:
  /// **'इस्त्री'**
  String get ironing;

  /// No description provided for @cook.
  ///
  /// In hi, this message translates to:
  /// **'रसोइया'**
  String get cook;

  /// No description provided for @gardener.
  ///
  /// In hi, this message translates to:
  /// **'माली'**
  String get gardener;

  /// No description provided for @houseCleaning.
  ///
  /// In hi, this message translates to:
  /// **'घर की सफ़ाई'**
  String get houseCleaning;

  /// No description provided for @cookingGas.
  ///
  /// In hi, this message translates to:
  /// **'रसोई गैस'**
  String get cookingGas;

  /// No description provided for @kilogram.
  ///
  /// In hi, this message translates to:
  /// **'किलो'**
  String get kilogram;

  /// No description provided for @proComingSoon.
  ///
  /// In hi, this message translates to:
  /// **'प्रो जल्द आ रहा है'**
  String get proComingSoon;

  /// No description provided for @allFeaturesFree.
  ///
  /// In hi, this message translates to:
  /// **'अभी सभी सुविधाएँ मुफ़्त हैं। आप असीमित हिसाब जोड़ सकते हैं।'**
  String get allFeaturesFree;

  /// No description provided for @tamil.
  ///
  /// In hi, this message translates to:
  /// **'तमिल'**
  String get tamil;

  /// No description provided for @urdu.
  ///
  /// In hi, this message translates to:
  /// **'उर्दू'**
  String get urdu;

  /// No description provided for @bengali.
  ///
  /// In hi, this message translates to:
  /// **'बंगाली'**
  String get bengali;

  /// No description provided for @telugu.
  ///
  /// In hi, this message translates to:
  /// **'तेलुगु'**
  String get telugu;

  /// No description provided for @kannada.
  ///
  /// In hi, this message translates to:
  /// **'कन्नड़'**
  String get kannada;

  /// No description provided for @privacyPolicy.
  ///
  /// In hi, this message translates to:
  /// **'गोपनीयता नीति'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyOpenError.
  ///
  /// In hi, this message translates to:
  /// **'गोपनीयता नीति नहीं खुल सकी। अपना ब्राउज़र और इंटरनेट कनेक्शन जाँचें।'**
  String get privacyPolicyOpenError;

  /// No description provided for @accountTitle.
  ///
  /// In hi, this message translates to:
  /// **'आपका खाता'**
  String get accountTitle;

  /// No description provided for @accountIntro.
  ///
  /// In hi, this message translates to:
  /// **'साइन इन वैकल्पिक है। आपकी डायरी इसी डिवाइस पर रहती है। क्लाउड बैकअप बाद में जोड़ा जाएगा।'**
  String get accountIntro;

  /// No description provided for @signIn.
  ///
  /// In hi, this message translates to:
  /// **'साइन इन करें'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In hi, this message translates to:
  /// **'खाता बनाएँ'**
  String get createAccount;

  /// No description provided for @googleSignIn.
  ///
  /// In hi, this message translates to:
  /// **'Google से जारी रखें'**
  String get googleSignIn;

  /// No description provided for @emailLabel.
  ///
  /// In hi, this message translates to:
  /// **'ईमेल'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड की पुष्टि करें'**
  String get confirmPasswordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड भूल गए?'**
  String get forgotPassword;

  /// No description provided for @resetSent.
  ///
  /// In hi, this message translates to:
  /// **'इस ईमेल का खाता होने पर पासवर्ड रीसेट लिंक भेजा जाएगा। अपना इनबॉक्स देखें।'**
  String get resetSent;

  /// No description provided for @authEmailInvalid.
  ///
  /// In hi, this message translates to:
  /// **'सही ईमेल पता दर्ज करें।'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In hi, this message translates to:
  /// **'अपना पासवर्ड दर्ज करें।'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordWeak.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड में कम से कम 6 अक्षर रखें।'**
  String get authPasswordWeak;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड मेल नहीं खाते।'**
  String get authPasswordMismatch;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In hi, this message translates to:
  /// **'ईमेल या पासवर्ड गलत है।'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailUsed.
  ///
  /// In hi, this message translates to:
  /// **'इस ईमेल का खाता पहले से है। साइन इन करें।'**
  String get authEmailUsed;

  /// No description provided for @authNetworkError.
  ///
  /// In hi, this message translates to:
  /// **'इंटरनेट कनेक्शन जाँचें और फिर कोशिश करें।'**
  String get authNetworkError;

  /// No description provided for @authUnavailable.
  ///
  /// In hi, this message translates to:
  /// **'साइन इन उपलब्ध नहीं है। Firebase सेटअप जाँचें।'**
  String get authUnavailable;

  /// No description provided for @authTryAgain.
  ///
  /// In hi, this message translates to:
  /// **'यह काम पूरा नहीं हुआ। बाद में फिर कोशिश करें।'**
  String get authTryAgain;

  /// No description provided for @authRecentLogin.
  ///
  /// In hi, this message translates to:
  /// **'खाता मिटाने से पहले साइन आउट करके फिर साइन इन करें।'**
  String get authRecentLogin;

  /// No description provided for @signOut.
  ///
  /// In hi, this message translates to:
  /// **'साइन आउट करें'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In hi, this message translates to:
  /// **'खाता मिटाएँ'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In hi, this message translates to:
  /// **'अपना साइन इन खाता मिटाएँ? इस डिवाइस के डायरी रिकॉर्ड बने रहेंगे।'**
  String get deleteAccountConfirm;

  /// No description provided for @signedInAs.
  ///
  /// In hi, this message translates to:
  /// **'इस खाते से साइन इन हैं'**
  String get signedInAs;

  /// No description provided for @continueOffline.
  ///
  /// In hi, this message translates to:
  /// **'ऑफ़लाइन जारी रखें'**
  String get continueOffline;

  /// No description provided for @showPassword.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड दिखाएँ'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In hi, this message translates to:
  /// **'पासवर्ड छिपाएँ'**
  String get hidePassword;

  /// No description provided for @helpAssistant.
  ///
  /// In hi, this message translates to:
  /// **'मदद सहायक'**
  String get helpAssistant;

  /// No description provided for @helpIntro.
  ///
  /// In hi, this message translates to:
  /// **'डायरी इस्तेमाल करने का सवाल पूछें या नीचे काम चुनें। हम सही स्क्रीन पर मार्गदर्शन दिखाएँगे।'**
  String get helpIntro;

  /// No description provided for @helpQuestion.
  ///
  /// In hi, this message translates to:
  /// **'आप क्या करना चाहते हैं?'**
  String get helpQuestion;

  /// No description provided for @helpShowMe.
  ///
  /// In hi, this message translates to:
  /// **'मुझे दिखाएँ'**
  String get helpShowMe;

  /// No description provided for @helpNoMatch.
  ///
  /// In hi, this message translates to:
  /// **'मार्गदर्शन के लिए नीचे कोई काम चुनें।'**
  String get helpNoMatch;

  /// No description provided for @helpChoices.
  ///
  /// In hi, this message translates to:
  /// **'किस काम में मदद चाहिए?'**
  String get helpChoices;

  /// No description provided for @helpReminderBody.
  ///
  /// In hi, this message translates to:
  /// **'रिमाइंडर चालू करें, सूचना की अनुमति दें और समय चुनें।'**
  String get helpReminderBody;

  /// No description provided for @helpBackupBody.
  ///
  /// In hi, this message translates to:
  /// **'डायरी की बैकअप फ़ाइल बनाने के लिए यहाँ टैप करें। फ़ाइल सुरक्षित जगह रखें।'**
  String get helpBackupBody;

  /// No description provided for @helpRestoreBody.
  ///
  /// In hi, this message translates to:
  /// **'बैकअप फ़ाइल चुनने के लिए यहाँ टैप करें। पुष्टि ध्यान से पढ़ें: इससे इस डिवाइस की डायरी बदल जाएगी।'**
  String get helpRestoreBody;

  /// No description provided for @assistantHello.
  ///
  /// In hi, this message translates to:
  /// **'नमस्ते! मैं आपका डायरी सहायक हूँ।'**
  String get assistantHello;

  /// No description provided for @assistantWelcome.
  ///
  /// In hi, this message translates to:
  /// **'जब भी मदद चाहिए, तैरती पेंसिल पर टैप करें। काम चुनें या सवाल पूछें, मैं सही जगह दिखाऊँगा। चलिए छोटा परिचय शुरू करें!'**
  String get assistantWelcome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mr',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
