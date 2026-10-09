import '../core/constants/app_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shell/diary_shell.dart';
import '../features/auth/language_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_providers.dart';
import 'diary_navigation.dart';
import '../features/splash/splash_screen.dart';
import 'theme/diary_theme.dart';
import '../features/help/help_assistant_overlay.dart';

class HisabApp extends ConsumerStatefulWidget {
  const HisabApp({super.key});
  @override
  ConsumerState<HisabApp> createState() => _HisabAppState();
}
class _HisabAppState extends ConsumerState<HisabApp> {
  bool _introFinished = false;
  final _helpObserver = HelpRouteObserver();
  @override
  void dispose() { _helpObserver.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final values = settings.asData?.value ?? const <String, String>{};
    final requestedLanguage = values['language'] ?? 'hi';
    final language = supportedLanguageCodes.contains(requestedLanguage)
        ? requestedLanguage : 'hi';
    final requestedScale = double.tryParse(values['textScale'] ?? '') ?? 1.0;
    final scale = [0.9, 1.0, 1.2].contains(requestedScale) ? requestedScale : 1.0;
    return MaterialApp(
      navigatorKey: diaryNavigatorKey,
      navigatorObservers: [_helpObserver],
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      locale: Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: diaryTheme(language),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(data: media.copyWith(textScaler:
          _DiaryTextScaler(media.textScaler, scale)), child: HelpAssistantOverlay(
            enabled: _introFinished && settings.hasValue && !settings.hasError && values.containsKey('language'),
            observer: _helpObserver, child: child!));
      },
      home: !settings.hasError && (!_introFinished || (settings.isLoading && !settings.hasValue))
          ? SplashScreen(onComplete: () {
              if (mounted) setState(() => _introFinished = true);
            })
          : settings.hasValue && !settings.hasError && !values.containsKey('language')
          ? const LanguageScreen()
          : DiaryShell(storageLoading: settings.isLoading,
        storageError: settings.hasError,
        onRetry: () => ref.invalidate(settingsProvider)),
    );
  }
}
class _DiaryTextScaler extends TextScaler {
  const _DiaryTextScaler(this.system, this.factor);
  final TextScaler system;
  final double factor;
  @override
  double scale(double fontSize) => system.scale(fontSize) * factor;
  @override
  double get textScaleFactor => scale(14) / 14;
}




