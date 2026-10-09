import 'package:flutter/material.dart';
import '../../app/diary_navigation.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../l10n/app_localizations.dart';
import 'help_screen.dart';
import 'help_topic.dart';
import 'pencil_mascot.dart';
import '../settings/settings_repository.dart';

final assistantRequests = ValueNotifier<HelpTopic?>(null);

class HelpRouteObserver extends NavigatorObserver {
  final visible = ValueNotifier<bool>(false);
  bool _disposed = false;
  void dispose() { _disposed = true; visible.dispose(); }
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    final show = topRoute is PageRoute && topRoute.settings.name != '/help';
    WidgetsBinding.instance.addPostFrameCallback((_) { if (!_disposed) visible.value = show; });
  }
}

class HelpAssistantOverlay extends StatefulWidget {
  const HelpAssistantOverlay({super.key, required this.child, required this.enabled,
    required this.observer});
  final Widget child;
  final bool enabled;
  final HelpRouteObserver observer;
  @override
  State<HelpAssistantOverlay> createState() => _HelpAssistantOverlayState();
}

class _HelpAssistantOverlayState extends State<HelpAssistantOverlay> {
  bool _opening = false;
  Future<void> _open() async {
    final navigator = diaryNavigatorKey.currentState;
    if (_opening || navigator == null) return;
    _opening = true;
    try {
      final topic = await navigator.push<HelpTopic>(MaterialPageRoute(
        settings: const RouteSettings(name: '/help'), builder: (_) => const HelpScreen()));
      if (!mounted || topic == null) return;
      navigator.popUntil((route) => route.isFirst);
      assistantRequests.value = topic;
      assistantRequests.value = null;
    } finally {
      _opening = false;
    }
  }
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned.fill(child: widget.child),
    if (widget.enabled) ValueListenableBuilder<bool>(valueListenable: widget.observer.visible,
      builder: (context, visible, _) => visible ? Positioned(
        right: 14, bottom: MediaQuery.viewInsetsOf(context).bottom +
          MediaQuery.paddingOf(context).bottom +
          (MediaQuery.viewInsetsOf(context).bottom > 0 ? 12 : 84),
        child: Material(color: DiaryColors.paper, elevation: 3,
          shape: const CircleBorder(side: BorderSide(color: DiaryColors.ink, width: 2)),
          child: InkWell(customBorder: const CircleBorder(), onTap: _open,
            child: Semantics(key: const ValueKey('floatingHelpAssistant'),
              button: true, label: AppLocalizations.of(context)!.helpAssistant,
                child: const SizedBox(width: 64, height: 64,
                  child: Center(child: ExcludeSemantics(child: PencilMascot())))))))
        : const SizedBox.shrink()),
  ]);
}

Future<void> introduceHelpAssistant(BuildContext context) => showDialog<void>(
  context: context, barrierDismissible: false,
  builder: (context) {
    final s = AppLocalizations.of(context)!;
    return AlertDialog(title: Text(s.assistantHello),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const ExcludeSemantics(child: PencilMascot(waving: true, size: 112)),
        const SizedBox(height: 16), Text(s.assistantWelcome),
      ]), actions: [DiaryButton(label: s.continueLabel,
        onPressed: () => Navigator.of(context).pop())]);
  });

Future<void>? _firstGreeting;
Future<void> greetAssistantOnce(BuildContext context, SettingsRepository repository,
    {required bool alreadyIntroduced}) async {
  if (alreadyIntroduced) return;
  await (_firstGreeting ??= () async {
    await introduceHelpAssistant(context);
    if (!context.mounted) return;
    try {
      await repository.markAssistantIntroduced();
    } catch (error) {
      debugPrint('Assistant introduction could not be saved (${error.runtimeType}).');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveError)));
      }
    }
  }());
}
