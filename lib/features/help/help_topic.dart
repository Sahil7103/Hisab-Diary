import '../../l10n/app_localizations.dart';

enum HelpTopic { addVendor, markDelivery, allCame, monthCalendar, billTotal,
  shareBill, reminder, backup, restore }

extension HelpTopicGuide on HelpTopic {
  int get tabIndex => switch (this) {
    HelpTopic.addVendor || HelpTopic.markDelivery || HelpTopic.allCame => 0,
    HelpTopic.monthCalendar => 1,
    HelpTopic.billTotal || HelpTopic.shareBill => 2,
    _ => 3,
  };
  int get tutorialStep => switch (this) {
    HelpTopic.markDelivery => 1,
    HelpTopic.allCame || HelpTopic.monthCalendar || HelpTopic.billTotal => 2,
    HelpTopic.shareBill => 3,
    _ => 0,
  };
  String label(AppLocalizations s) => switch (this) {
    HelpTopic.addVendor => s.tutorialAddTitle,
    HelpTopic.markDelivery => s.tutorialMarkTitle,
    HelpTopic.allCame => s.tutorialAllTitle,
    HelpTopic.monthCalendar => s.tutorialCalendarTitle,
    HelpTopic.billTotal => s.tutorialBillTotalTitle,
    HelpTopic.shareBill => s.tutorialShareTitle,
    HelpTopic.reminder => s.eveningReminder,
    HelpTopic.backup => s.shareBackup,
    HelpTopic.restore => s.restoreBackup,
  };
}

String _normalize(String value) => value.toLowerCase()
  .replaceAll(RegExp(r'[?.,!;:؟،।]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

// Questions remain on the device. Only supported tasks can select a destination.
List<HelpTopic> matchHelpTopics(String question, AppLocalizations strings) {
  final query = _normalize(question);
  if (query.isEmpty) return [];
  const phrases = {
    HelpTopic.addVendor: ['add vendor', 'new vendor', 'add milk', 'add supplier', 'vendor kaise', 'add a vendor', 'विक्रेता जोड़ें', 'वेंडर जोड़ें', 'વિક્રેતા ઉમેરો', 'विक्रेता जोडा', 'বিক্রেতা যোগ', 'فروشندہ شامل', 'விற்பனையாளர் சேர்', 'విక్రేతను జోడించు', 'ಮಾರಾಟಗಾರ ಸೇರಿಸಿ'],
    HelpTopic.markDelivery: ['delivery', 'mark came', 'mark absent', 'quantity', 'did not come', 'mark a delivery', 'डिलीवरी', 'आया', 'डिलिव्हरी', 'ડિલિવરી', 'ডেলিভারি', 'ڈیلیوری', 'விநியோகம்', 'డెలివరీ', 'ವಿತರಣೆ'],
    HelpTopic.allCame: ['all came', 'everyone came', 'sab aaye', 'सब आए', 'બધા આવ્યા', 'सगळे आले', 'সবাই এসেছে', 'سب آئے', 'அனைவரும் வந்தனர்', 'అందరూ వచ్చారు', 'ಎಲ್ಲರೂ ಬಂದರು'],
    HelpTopic.monthCalendar: ['calendar', 'monthly history', 'month', 'previous day', 'कैलेंडर', 'महीना', 'કૅલેન્ડર', 'महिना', 'ক্যালেন্ডার', 'کیلنڈر', 'நாட்காட்டி', 'క్యాలెండర్', 'ಕ್ಯಾಲೆಂಡರ್'],
    HelpTopic.billTotal: ['bill', 'total', 'balance', 'payment', 'paid', 'बिल', 'बकाया', 'બિલ', 'বিল', 'بل', 'பில்', 'బిల్లు', 'ಬಿಲ್'],
    HelpTopic.shareBill: ['share bill', 'send bill', 'export bill', 'whatsapp', 'बिल भेजें', 'बिल शेयर', 'બિલ મોકલો', 'बिल पाठवा', 'বিল পাঠান', 'بل بھیجیں', 'பில் பகிர்', 'బిల్లు పంపు', 'ಬಿಲ್ ಹಂಚಿ'],
    HelpTopic.reminder: ['reminder', 'notification', 'alarm', 'रिमाइंडर', 'याद दिलाना', 'રિમાઇન્ડર', 'রিমাইন্ডার', 'یاد دہانی', 'நினைவூட்டல்', 'రిమైండర్', 'ರಿಮೈಂಡರ್'],
    HelpTopic.backup: ['backup', 'back up', 'save my data', 'बैकअप', 'બેકઅપ', 'बॅकअप', 'ব্যাকআপ', 'بیک اپ', 'காப்புப்பிரதி', 'బ్యాకప్', 'ಬ್ಯಾಕಪ್'],
    HelpTopic.restore: ['restore', 'recover', 'import backup', 'रिस्टोर', 'वापस लाना', 'રીસ્ટોર', 'पुनर्संचयित', 'পুনরুদ্ধার', 'بحال', 'மீட்டமை', 'పునరుద్ధరణ', 'ಮರುಸ್ಥಾಪನೆ'],
  };
  final matches = HelpTopic.values.where((topic) {
    final terms = [...phrases[topic]!, topic.label(strings)];
    return terms.any((term) => ' $query '.contains(' ${_normalize(term)} '));
  }).toList();
  if (matches.contains(HelpTopic.shareBill)) matches.remove(HelpTopic.billTotal);
  if (matches.contains(HelpTopic.restore)) matches.remove(HelpTopic.backup);
  return matches;
}
