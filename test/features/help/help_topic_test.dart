import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/features/help/help_topic.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  final strings = lookupAppLocalizations(const Locale('en'));
  test('questions route to supported tasks and specific actions take priority', () {
    final questions = {
      'How do I add a new vendor?': HelpTopic.addVendor,
      'How do I mark a delivery?': HelpTopic.markDelivery,
      'Everyone came today': HelpTopic.allCame,
      'Where is my calendar?': HelpTopic.monthCalendar,
      'How much is my bill?': HelpTopic.billTotal,
      'How can I share bill on WhatsApp?': HelpTopic.shareBill,
      'How do I set a reminder?': HelpTopic.reminder,
      'How do I back up my data?': HelpTopic.backup,
      'How do I restore my backup?': HelpTopic.restore,
    };
    for (final entry in questions.entries) {
      expect(matchHelpTopics(entry.key, strings), [entry.value], reason: entry.key);
    }
  });
  test('unknown and ambiguous questions require the user to choose', () {
    expect(matchHelpTopics('', strings), isEmpty);
    expect(matchHelpTopics('Change my password', strings), isEmpty);
    expect(matchHelpTopics('billing reminderless', strings), isEmpty);
    expect(matchHelpTopics('calendar and reminder', strings),
      [HelpTopic.monthCalendar, HelpTopic.reminder]);
  });
  test('task labels in every app language are recognized', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final localized = lookupAppLocalizations(locale);
      for (final topic in HelpTopic.values) {
        expect(matchHelpTopics(topic.label(localized), localized), contains(topic),
          reason: '${locale.languageCode}: ${topic.name}');
      }
    }
  });
}
