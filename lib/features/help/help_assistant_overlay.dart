import 'package:flutter/material.dart';
import '../../app/diary_navigation.dart';
import '../../core/widgets/diary_tutorial.dart';
import '../../l10n/app_localizations.dart';
import 'help_screen.dart';
import 'help_topic.dart';
import 'pencil_mascot.dart';
import '../settings/settings_repository.dart';

final assistantRequests = ValueNotifier<HelpTopic?>(null);
final _pencilAnchor = GlobalKey();

class HelpRouteObserver extends NavigatorObserver {
  final presentation = ValueNotifier<({bool visible, bool greeting})>((visible: false, greeting: false));
  bool _disposed = false;
  void dispose() { _disposed = true; presentation.dispose(); }
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    final greeting = topRoute.settings.name == '/assistant-introduction';
    final show = greeting || (topRoute is PageRoute && topRoute.settings.name != '/help');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) presentation.value = (visible: show, greeting: greeting);
    });
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
    if (widget.enabled) ValueListenableBuilder<({bool visible, bool greeting})>(
      valueListenable: widget.observer.presentation,
      builder: (context, state, _) => state.visible ? Positioned(
        right: 12, bottom: MediaQuery.viewInsetsOf(context).bottom +
          MediaQuery.paddingOf(context).bottom +
          (MediaQuery.viewInsetsOf(context).bottom > 0 ? 12 : 82),
        child: Semantics(key: const ValueKey('floatingHelpAssistant'),
          button: true, label: AppLocalizations.of(context)!.helpAssistant,
          enabled: !state.greeting,
          child: GestureDetector(behavior: HitTestBehavior.opaque,
            onTap: state.greeting ? null : _open,
            child: SizedBox(key: _pencilAnchor, width: 68, height: 68,
              child: Center(child: ExcludeSemantics(
                child: PencilMascot(waving: state.greeting, size: 64)))))))
        : const SizedBox.shrink()),
  ]);
}

Future<void> introduceHelpAssistant(BuildContext context) {
  final s = AppLocalizations.of(context)!;
  return showGeneralDialog<void>(context: context, barrierDismissible: false,
    barrierColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/assistant-introduction'),
    pageBuilder: (_, _, _) => DiaryTutorial(showProgress: false,
      completionLabel: s.continueLabel, steps: [
        DiaryTutorialStep(target: _pencilAnchor, title: s.assistantHello,
          body: s.assistantWelcome),
      ]));
}

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
