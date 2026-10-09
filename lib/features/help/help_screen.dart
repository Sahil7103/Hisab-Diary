import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'help_topic.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _question = TextEditingController();
  List<HelpTopic>? _matches;
  @override
  void dispose() { _question.dispose(); super.dispose(); }

  void _answer() {
    final matches = matchHelpTopics(_question.text, AppLocalizations.of(context)!);
    if (matches.length == 1) {
      Navigator.of(context).pop(matches.single);
    } else {
      setState(() => _matches = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final choices = _matches?.isNotEmpty == true ? _matches! : HelpTopic.values;
    return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
      padding: const EdgeInsets.all(18), children: [
        Row(children: [
          IconButton(onPressed: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(Icons.arrow_back)),
          Expanded(child: DiaryScreenHeader(title: s.helpAssistant)),
        ]),
        const SizedBox(height: 16),
        Text(s.helpIntro, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        TextField(controller: _question, maxLength: 200,
          textInputAction: TextInputAction.search, onSubmitted: (_) => _answer(),
          decoration: InputDecoration(labelText: s.helpQuestion,
            prefixIcon: const Icon(Icons.help_outline_rounded))),
        const SizedBox(height: 12),
        DiaryButton(label: s.helpShowMe, onPressed: _answer),
        const SizedBox(height: 24),
        if (_matches != null) Padding(padding: const EdgeInsets.only(bottom: 12),
          child: Text(_matches!.isEmpty ? s.helpNoMatch : s.helpChoices,
            style: Theme.of(context).textTheme.bodyLarge)),
        for (final topic in choices) Padding(padding: const EdgeInsets.only(bottom: 12),
          child: DiaryButton(label: topic.label(s), color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: () => Navigator.of(context).pop(topic))),
      ],
    ))));
  }
}
