import '../../core/constants/app_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_repository.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key, this.initialLanguage = 'hi', this.changing = false});
  final String initialLanguage;
  final bool changing;
  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}
class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _selected;
  @override
  void initState() {
    super.initState();
    _selected = widget.initialLanguage;
  }
  bool _saving = false;


  Future<void> _save(AppLocalizations strings) async {
    setState(() => _saving = true);
    try {
      await ref.read(settingsRepositoryProvider).setLanguage(_selected);
      if (mounted && widget.changing) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.saveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Localizations.override(
    context: context, locale: Locale(_selected),
    child: Theme(data: diaryTheme(_selected), child: Builder(builder: (context) {
      final strings = AppLocalizations.of(context)!;
      final names = languageNativeNames;
      return Directionality(
        textDirection: _selected == 'ur' ? TextDirection.rtl : TextDirection.ltr,
        child: NotebookBackground(
        child: Scaffold(body: SafeArea(child: ListView(
          padding: const EdgeInsets.all(18), children: [
            if (widget.changing) Align(alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(onPressed: _saving ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
                icon: const Icon(Icons.arrow_back), label: Text(strings.back))),
            const SizedBox(height: 18),
            ExcludeSemantics(child: Center(child: Container(
              width: 84, height: 84,
              decoration: BoxDecoration(color: DiaryColors.haldiSoft,
                borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.menu_book_rounded, size: 50,
                color: DiaryColors.pen)))),
            const SizedBox(height: 10),
            Text(strings.appName, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge),
            Text(strings.chooseLanguage, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            for (final entry in names.entries) Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(selected: _selected == entry.key,
                child: DiaryButton(label: entry.value, selected: _selected == entry.key,
                  color: _selected == entry.key ? DiaryColors.haldi : Colors.white,
                  foreground: DiaryColors.ink, edge: DiaryColors.ink,
                  onPressed: _saving ? null : () => setState(() => _selected = entry.key),
                  child: Row(children: [
                    Expanded(child: Text(entry.value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: diaryTheme(entry.key).textTheme.titleLarge?.fontFamily))),
                    Text(switch (entry.key) {
                      'hi' => strings.hindi, 'en' => strings.english,
                      'gu' => strings.gujarati, 'mr' => strings.marathi,
                      'ta' => strings.tamil, 'ur' => strings.urdu,
                      'bn' => strings.bengali, 'te' => strings.telugu,
                      _ => strings.kannada,
                    }, style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ))),
            DiaryButton(label: _saving ? strings.saving : widget.changing ? strings.saveVendor : strings.continueLabel,
              onPressed: _saving ? null : () => _save(strings)),
            const SizedBox(height: 12),
            Text(strings.languageLater, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          ]))),
      ));
    })),
  );
}



