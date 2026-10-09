// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get tutorialAddTitle => 'अपना खाता जोड़ें';

  @override
  String get tutorialAddBody =>
      'खाता जोड़ें पर टैप करके दूध, अख़बार या दूसरी सेवा चुनें। रोज़ की मात्रा और कीमत डालकर सेव करें।';

  @override
  String get tutorialMarkTitle => 'आज की सेवा दर्ज करें';

  @override
  String get tutorialMarkBody =>
      'खाते पर आया या नहीं आया दबाएँ। वही निशान दोबारा दबाकर हटा सकते हैं। खाते के नाम पर टैप करके कैलेंडर खोलें।';

  @override
  String get tutorialAllTitle => 'सब आया?';

  @override
  String get tutorialAllBody =>
      'सब आया दबाकर आज की सभी तय सेवाओं को एक साथ दर्ज करें।';

  @override
  String get tutorialTabsTitle => 'आपकी डायरी एक नज़र में';

  @override
  String get tutorialTabsBody =>
      'आज में रोज़ का हिसाब दर्ज करें। महीना में कैलेंडर देखें। बिल में कुल हिसाब निकालकर WhatsApp पर भेजें। सेटिंग में भाषा और रिमाइंडर हैं।';

  @override
  String get tutorialNext => 'आगे';

  @override
  String get tutorialDone => 'डायरी शुरू करें';

  @override
  String get tutorialSkip => 'ट्यूटोरियल छोड़ें';

  @override
  String get tutorialVendorTitle => 'खाता चुनें';

  @override
  String get tutorialVendorBody =>
      'विक्रेता चुनें पर टैप करके अपने घर के खातों में बदलें।';

  @override
  String get tutorialMonthTitle => 'महीना चुनें';

  @override
  String get tutorialMonthBody => 'बाएँ और दाएँ तीर से महीना बदलें।';

  @override
  String get tutorialCalendarTitle => 'रोज़ का निशान बदलें';

  @override
  String get tutorialCalendarBody =>
      'पिछले दिन या आज पर टैप करके आया / नहीं आया बदलें। आने वाले दिन दर्ज नहीं कर सकते।';

  @override
  String get tutorialTotalTitle => 'कुल हिसाब देखें';

  @override
  String get tutorialTotalBody =>
      'कैलेंडर के नीचे कुल रकम सेवा के दिनों, रोज़ की मात्रा और कीमत से बदलती है।';

  @override
  String get tutorialBillTotalTitle => 'बिल जाँचें';

  @override
  String get tutorialBillTotalBody =>
      'इस खाते और महीने के सेवा दिनों और कुल रकम की जाँच करें। बिल पहले पिछले महीने का खुलता है।';

  @override
  String get tutorialShareTitle => 'WhatsApp पर भेजें';

  @override
  String get tutorialShareBody =>
      'बिल भेजने के लिए WhatsApp पर भेजें दबाएँ। भेजने से पहले बिल जाँचें और प्राप्तकर्ता चुनें।';

  @override
  String get tutorialPaidTitle => 'भुगतान दर्ज करें';

  @override
  String get tutorialPaidBody =>
      'विक्रेता को भुगतान करने के बाद भुगतान किया दबाएँ। यह केवल भुगतान की स्थिति दर्ज करता है, पैसे नहीं भेजता।';

  @override
  String get today => 'आज';

  @override
  String get month => 'महीना';

  @override
  String get appName => 'हिसाब डायरी';

  @override
  String get bill => 'बिल';

  @override
  String get storageError => 'डायरी नहीं खुल सकी। कृपया फिर कोशिश करें।';

  @override
  String get loading => 'डायरी खुल रही है';

  @override
  String get settings => 'सेटिंग';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get privacy =>
      'आपकी डायरी बिना लॉगिन के ऑफलाइन चलती है। रिकॉर्ड इसी फोन पर रहते हैं, जब तक आप उन्हें साझा या निर्यात न करें। रिलीज़ संस्करण उपयोग के आँकड़े, क्रैश रिपोर्ट और प्रदर्शन की निगरानी के लिए Google Firebase से ऐप उपयोग और तकनीकी जानकारी एकत्र करते हैं।';

  @override
  String get notCame => 'नहीं';

  @override
  String get saveError => 'बदलाव सेव नहीं हुआ। फिर कोशिश करें।';

  @override
  String get piece => 'नग';

  @override
  String get noDeliveries => 'आज के लिए कोई हिसाब नहीं है';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनिए';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get addNew => '＋ नया हिसाब जोड़ें';

  @override
  String get litre => 'लीटर';

  @override
  String get milk => 'दूध';

  @override
  String openMonth(String vendor) {
    return '$vendor का महीना खोलें';
  }

  @override
  String get marathi => 'मराठी';

  @override
  String get saving => 'सेव हो रहा है…';

  @override
  String get carCleaner => 'गाड़ी की सफ़ाई';

  @override
  String get gujarati => 'गुजराती';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get continueLabel => 'आगे बढ़िए';

  @override
  String get visit => 'बार';

  @override
  String get other => 'अन्य';

  @override
  String get came => 'आया';

  @override
  String get addFirst => '＋ पहला हिसाब जोड़ें';

  @override
  String get languageLater => 'बाद में सेटिंग में बदल सकते हैं';

  @override
  String get tiffin => 'टिफ़िन';

  @override
  String get maid => 'कामवाली';

  @override
  String get allCame => 'सब आया';

  @override
  String get newspaper => 'अख़बार';

  @override
  String get hindiNative => 'हिन्दी';

  @override
  String get marathiNative => 'मराठी';

  @override
  String get gujaratiNative => 'ગુજરાતી';

  @override
  String get englishNative => 'English';

  @override
  String get friday => 'शुक्रवार';

  @override
  String get invalidVendorAmount =>
      'सही संख्या डालें: मात्रा 0 से ज़्यादा और कीमत 0 या उससे ज़्यादा होनी चाहिए।';

  @override
  String get dailyQuantity => 'रोज़ कितना?';

  @override
  String unitRate(String unit) {
    return 'एक $unit का रेट';
  }

  @override
  String get saturday => 'शनिवार';

  @override
  String get chooseOne => 'एक चुनिए';

  @override
  String get sunday => 'रविवार';

  @override
  String get fridayShort => 'शु';

  @override
  String get saveVendor => 'सेव करें';

  @override
  String get decreaseQuantity => 'मात्रा घटाएँ';

  @override
  String get tuesdayShort => 'मं';

  @override
  String get back => 'वापस';

  @override
  String get tuesday => 'मंगलवार';

  @override
  String get pickVendorType => 'क्या जोड़ना है?';

  @override
  String get decreaseRate => 'रेट घटाएँ';

  @override
  String get thursday => 'गुरुवार';

  @override
  String get mondayShort => 'सो';

  @override
  String get monday => 'सोमवार';

  @override
  String get thursdayShort => 'गु';

  @override
  String get wednesday => 'बुधवार';

  @override
  String get optionalName => 'नाम (चाहें तो)';

  @override
  String get increaseQuantity => 'मात्रा बढ़ाएँ';

  @override
  String get wednesdayShort => 'बु';

  @override
  String get chooseWeekday => 'कम से कम एक दिन चुनिए';

  @override
  String get someDays => 'कुछ दिन';

  @override
  String get everyDay => 'रोज़';

  @override
  String get sundayShort => 'र';

  @override
  String get nameHint => 'हिसाब वाले का नाम';

  @override
  String get increaseRate => 'रेट बढ़ाएँ';

  @override
  String get deliverySchedule => 'कब आता है?';

  @override
  String get saturdayShort => 'श';

  @override
  String get unmarked => 'अभी नहीं बताया';

  @override
  String get runningTotal => 'अब तक का कुल';

  @override
  String get autoCame => 'बिना बताए आया गिना';

  @override
  String get calendarHint => 'किसी दिन को छूकर हरा / लाल बदलिए';

  @override
  String get nextMonth => 'अगला महीना';

  @override
  String notCameCount(String count) {
    return 'नहीं $count दिन';
  }

  @override
  String autoCounted(String count) {
    return 'बिना बताए आया गिना: $count दिन';
  }

  @override
  String get dayUnavailable => 'यह दिन उपलब्ध नहीं है';

  @override
  String cameCount(String count) {
    return 'आया $count दिन';
  }

  @override
  String get chooseVendor => 'हिसाब चुनिए';

  @override
  String get previousMonth => 'पिछला महीना';

  @override
  String get noVendorsCalendar => 'कैलेंडर देखने के लिए पहला हिसाब जोड़िए।';

  @override
  String get backupTooLarge => 'बैकअप 10 MB से बड़ा है। छोटी फ़ाइल चुनिए।';

  @override
  String get shareError => 'साझा नहीं हो सका। कृपया फिर कोशिश करें।';

  @override
  String get textSize => 'अक्षर का आकार';

  @override
  String get restoreSuccess => 'बैकअप वापस आ गया';

  @override
  String get largeText => 'बड़े अक्षर';

  @override
  String get languageLabel => 'भाषा';

  @override
  String get paid => 'चुका दिया';

  @override
  String get textSizeSample => 'अ';

  @override
  String get invalidBackup =>
      'यह हिसाब डायरी का मान्य बैकअप नहीं है। आपकी डायरी नहीं बदली।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get normalText => 'सामान्य अक्षर';

  @override
  String get shareWhatsApp => 'WhatsApp पर भेजिए';

  @override
  String get restoreBackup => 'बैकअप वापस लाएँ';

  @override
  String get markPaid => 'चुका दिया';

  @override
  String get noVendorsBill => 'बिल बनाने के लिए पहला हिसाब जोड़िए।';

  @override
  String get countUnmarkedLabel => 'बिना बताए = आया गिनो';

  @override
  String dayCount(String count) {
    return '$count दिन';
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
    return 'नमस्ते $name 🙏\n$month का $vendorType हिसाब: $days दिन × $quantity $unit = $total.\nधन्यवाद! — $appName\nPlay Store: [लिंक जल्द आएगा]';
  }

  @override
  String get totalDue => 'कुल देना है';

  @override
  String get smallText => 'छोटे अक्षर';

  @override
  String restoreSummary(String vendorCount, String entryCount) {
    return 'इस फ़ोन की डायरी में $vendorCount हिसाब और $entryCount दैनिक निशान वापस आएँगे। मौजूदा हिसाब, निशान, रेट, भुगतान और सेटिंग बदल जाएँगे। जारी रखें?';
  }

  @override
  String get shareBackup => 'बैकअप भेजिए';

  @override
  String get eveningReminder => 'शाम का रिमाइंडर';

  @override
  String get restoreError => 'बैकअप वापस नहीं आ सका। आपकी डायरी नहीं बदली।';

  @override
  String get genericVendorName => 'जी';

  @override
  String get reminderQuestion => 'आज सब आया?';

  @override
  String get reminderAllCame => 'हाँ, सब आया';

  @override
  String get reminderView => 'देखिए';

  @override
  String reminderAt(String time) {
    return 'याद दिलाएँ: $time';
  }

  @override
  String get reminderPermission =>
      'फोन की सेटिंग में नोटिफ़िकेशन की अनुमति दें, फिर याद दिलाना चालू करें।';

  @override
  String get reminderError =>
      'याद दिलाना या हिसाब सेव करना नहीं हो पाया। अनुमति जाँचें और ज़रूरत हो तो आज का हिसाब डायरी में दर्ज करें।';

  @override
  String get reminderApproximate =>
      'सटीक अलार्म बंद है। याद दिलाने में थोड़ी देर हो सकती है।';

  @override
  String get reminderHelpTitle => 'याद दिलाने में मदद';

  @override
  String get reminderBatteryIntro =>
      'कुछ फोन बैकग्राउंड में ऐप बंद कर देते हैं। याद न दिलाने पर हिसाब डायरी को बैकग्राउंड में चलने दें। सेटिंग के नाम फोन के अनुसार बदल सकते हैं।';

  @override
  String get reminderXiaomi =>
      'Xiaomi: ऑटोस्टार्ट की अनुमति दें और ऐप की बैटरी सेटिंग में कोई पाबंदी नहीं चुनें।';

  @override
  String get reminderOppo =>
      'Oppo: ऐप या बैटरी सेटिंग में अपने आप शुरू होने और बैकग्राउंड में चलने की अनुमति दें।';

  @override
  String get reminderVivo =>
      'Vivo: हिसाब डायरी के लिए ऑटोस्टार्ट और बैकग्राउंड में बैटरी इस्तेमाल की अनुमति दें।';

  @override
  String get reminderRealme =>
      'Realme: ऐप की बैटरी सेटिंग में अपने आप शुरू होने और बैकग्राउंड में चलने की अनुमति दें।';

  @override
  String get openBatterySettings => 'फोन की सेटिंग खोलें';

  @override
  String get testReminder => 'याद दिलाकर जाँचें';

  @override
  String get enableReminderFirst =>
      'पहले शाम को याद दिलाना चालू करें और नोटिफ़िकेशन की अनुमति दें।';

  @override
  String get testReminderSent =>
      'जाँच का नोटिफ़िकेशन भेजा गया। फोन के नोटिफ़िकेशन देखें।';

  @override
  String get proUpgradeTitle => 'ज़्यादा खाते। एक आसान डायरी।';

  @override
  String get proEverydayHeading =>
      'मुफ़्त और प्रो, दोनों में रोज़मर्रा की सुविधाएँ';

  @override
  String get proDailyHook => 'दूध और घर की सेवाओं का हिसाब, बस एक टैप।';

  @override
  String get proRecordsHook => 'हर दिन का साफ़ हिसाब, महीने के अंत में कम बहस।';

  @override
  String get proShareHook => 'महीने का बिल WhatsApp पर भेजें।';

  @override
  String get proOfflineHook => 'बिना इंटरनेट या लॉगिन के हिसाब रखें।';

  @override
  String get proContinue => 'अपनी डायरी पर लौटें';

  @override
  String get proPremium => 'प्रीमियम';

  @override
  String get proFree => 'मुफ़्त';

  @override
  String get proVendorCaption => 'सक्रिय खाते';

  @override
  String get proOneTime => 'एक बार खरीदें। कोई सदस्यता नहीं।';

  @override
  String get proLocalDiary => 'आपकी डायरी इसी फ़ोन पर रहती है।';

  @override
  String get proCapacity => '12 सक्रिय विक्रेता खातों तक का हिसाब रखें।';

  @override
  String get proTitle => 'हिसाब डायरी प्रो';

  @override
  String get proActive => 'प्रो चालू है — 12 सक्रिय हिसाब तक';

  @override
  String get proDescription => 'एक बार खरीदें, अधिक हिसाब जोड़ें';

  @override
  String get proLimits =>
      'मुफ़्त: 3 सक्रिय हिसाब। प्रो: 12 सक्रिय हिसाब। आपकी डायरी इसी फोन पर रहती है।';

  @override
  String buyPro(String price) {
    return 'प्रो लें · $price';
  }

  @override
  String get restorePurchases => 'खरीद वापस पाएँ';

  @override
  String get purchasePending => 'स्टोर का इंतज़ार है…';

  @override
  String get storeUnavailable =>
      'प्रो अभी स्टोर में उपलब्ध नहीं है। बाद में फिर कोशिश करें।';

  @override
  String get purchaseError =>
      'खरीद पूरी नहीं हो पाई। Play Store जाँचें और फिर कोशिश करें।';

  @override
  String get purchaseCanceled => 'खरीद रद्द हुई। आपका प्लान नहीं बदला है।';

  @override
  String get noProPurchase => 'इस Play Store खाते में प्रो की खरीद नहीं मिली।';

  @override
  String vendorLimitReached(String limit) {
    return 'आपके प्लान में $limit सक्रिय हिसाब हो सकते हैं। कोई हिसाब संग्रह में रखें या सेटिंग में प्रो लें।';
  }

  @override
  String get manageVendors => 'हिसाब सँभालें';

  @override
  String get archiveVendor => 'संग्रह में रखें';

  @override
  String get activateVendor => 'फिर सक्रिय करें';

  @override
  String get archiveExplanation =>
      'संग्रह में रखने पर हिसाब आज की सूची से हटता है। पुराने दिन, दरें और चुकाए बिल सुरक्षित रहते हैं। इसे फिर सक्रिय कर सकते हैं।';

  @override
  String get vendorArchived => 'संग्रह में';

  @override
  String get vendorActive => 'सक्रिय';

  @override
  String get splashTagline => 'हर दिन का हिसाब, आसानी से।';

  @override
  String get shareVendorName => 'विक्रेता का नाम';

  @override
  String get shareService => 'सेवा';

  @override
  String get shareBillingMonth => 'बिल का महीना';

  @override
  String get shareDailyQuantity => 'प्रतिदिन मात्रा';

  @override
  String get shareCalculation => 'गणना (दिन × प्रतिदिन मात्रा × दर)';

  @override
  String get shareTotalAmount => 'कुल राशि';

  @override
  String get shareSource => 'साझा किया गया';

  @override
  String get vegetables => 'सब्ज़ियाँ';

  @override
  String get fruits => 'फल';

  @override
  String get groceries => 'किराना';

  @override
  String get waterDelivery => 'पानी की डिलीवरी';

  @override
  String get eggs => 'अंडे';

  @override
  String get bread => 'ब्रेड';

  @override
  String get laundry => 'कपड़ों की धुलाई';

  @override
  String get ironing => 'इस्त्री';

  @override
  String get cook => 'रसोइया';

  @override
  String get gardener => 'माली';

  @override
  String get houseCleaning => 'घर की सफ़ाई';

  @override
  String get cookingGas => 'रसोई गैस';

  @override
  String get kilogram => 'किलो';

  @override
  String get proComingSoon => 'प्रो जल्द आ रहा है';

  @override
  String get allFeaturesFree =>
      'अभी सभी सुविधाएँ मुफ़्त हैं। आप असीमित हिसाब जोड़ सकते हैं।';

  @override
  String get tamil => 'तमिल';

  @override
  String get urdu => 'उर्दू';

  @override
  String get bengali => 'बंगाली';

  @override
  String get telugu => 'तेलुगु';

  @override
  String get kannada => 'कन्नड़';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privacyPolicyOpenError =>
      'गोपनीयता नीति नहीं खुल सकी। अपना ब्राउज़र और इंटरनेट कनेक्शन जाँचें।';

  @override
  String get accountTitle => 'आपका खाता';

  @override
  String get accountIntro =>
      'साइन इन वैकल्पिक है। आपकी डायरी इसी डिवाइस पर रहती है। क्लाउड बैकअप बाद में जोड़ा जाएगा।';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get googleSignIn => 'Google से जारी रखें';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get confirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get resetSent =>
      'इस ईमेल का खाता होने पर पासवर्ड रीसेट लिंक भेजा जाएगा। अपना इनबॉक्स देखें।';

  @override
  String get authEmailInvalid => 'सही ईमेल पता दर्ज करें।';

  @override
  String get authPasswordRequired => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get authPasswordWeak => 'पासवर्ड में कम से कम 6 अक्षर रखें।';

  @override
  String get authPasswordMismatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get authInvalidCredentials => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get authEmailUsed => 'इस ईमेल का खाता पहले से है। साइन इन करें।';

  @override
  String get authNetworkError => 'इंटरनेट कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get authUnavailable =>
      'साइन इन उपलब्ध नहीं है। Firebase सेटअप जाँचें।';

  @override
  String get authTryAgain => 'यह काम पूरा नहीं हुआ। बाद में फिर कोशिश करें।';

  @override
  String get authRecentLogin =>
      'खाता मिटाने से पहले साइन आउट करके फिर साइन इन करें।';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get deleteAccount => 'खाता मिटाएँ';

  @override
  String get deleteAccountConfirm =>
      'अपना साइन इन खाता मिटाएँ? इस डिवाइस के डायरी रिकॉर्ड बने रहेंगे।';

  @override
  String get signedInAs => 'इस खाते से साइन इन हैं';

  @override
  String get continueOffline => 'ऑफ़लाइन जारी रखें';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get helpAssistant => 'मदद सहायक';

  @override
  String get helpIntro =>
      'डायरी इस्तेमाल करने का सवाल पूछें या नीचे काम चुनें। हम सही स्क्रीन पर मार्गदर्शन दिखाएँगे।';

  @override
  String get helpQuestion => 'आप क्या करना चाहते हैं?';

  @override
  String get helpShowMe => 'मुझे दिखाएँ';

  @override
  String get helpNoMatch => 'मार्गदर्शन के लिए नीचे कोई काम चुनें।';

  @override
  String get helpChoices => 'किस काम में मदद चाहिए?';

  @override
  String get helpReminderBody =>
      'रिमाइंडर चालू करें, सूचना की अनुमति दें और समय चुनें।';

  @override
  String get helpBackupBody =>
      'डायरी की बैकअप फ़ाइल बनाने के लिए यहाँ टैप करें। फ़ाइल सुरक्षित जगह रखें।';

  @override
  String get helpRestoreBody =>
      'बैकअप फ़ाइल चुनने के लिए यहाँ टैप करें। पुष्टि ध्यान से पढ़ें: इससे इस डिवाइस की डायरी बदल जाएगी।';

  @override
  String get assistantHello => 'नमस्ते! मैं आपका डायरी सहायक हूँ।';

  @override
  String get assistantWelcome =>
      'जब भी मदद चाहिए, तैरती पेंसिल पर टैप करें। काम चुनें या सवाल पूछें, मैं सही जगह दिखाऊँगा। चलिए छोटा परिचय शुरू करें!';

  @override
  String get editVendor => 'खाता संपादित करें';

  @override
  String get deleteVendor => 'खाता हटाएँ';

  @override
  String deleteVendorConfirm(String name) {
    return '$name को हटाएँ? इसकी रोज़ की नोंद, सहेजे गए दर और भुगतान का इतिहास भी हट जाएगा। इसे वापस नहीं लाया जा सकता।';
  }

  @override
  String get editVendorRatesInfo =>
      'मात्रा और कीमत में बदलाव इस महीने से लागू होते हैं। डिलीवरी के दिन बदलने से बिना नोंद वाले दिनों का हिसाब भी बदलता है।';

  @override
  String get allVendors => 'सभी विक्रेता';

  @override
  String get monthlyTotal => 'मासिक कुल';

  @override
  String get allVendorsBillInfo =>
      'आपके सक्रिय खातों के मासिक बिल। भुगतान किए गए बिल भी कुल राशि में शामिल हैं।';
}
