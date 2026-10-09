import 'package:flutter/material.dart';
import '../../core/widgets/diary_tutorial.dart';

class HelpSpotlight extends StatefulWidget {
  const HelpSpotlight({super.key, required this.enabled, required this.title,
    required this.body, required this.child});
  final bool enabled;
  final String title;
  final String body;
  final Widget child;
  @override
  State<HelpSpotlight> createState() => _HelpSpotlightState();
}

class _HelpSpotlightState extends State<HelpSpotlight> {
  final _target = GlobalKey();
  bool _shown = false;
  @override
  Widget build(BuildContext context) {
    if (widget.enabled && !_shown) {
      _shown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
          _shown = false;
          return;
        }
        showGeneralDialog<void>(context: context, barrierDismissible: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, _, _) => DiaryTutorial(steps: [
            DiaryTutorialStep(target: _target, title: widget.title, body: widget.body),
          ]));
      });
    }
    return Container(key: _target, child: widget.child);
  }
}
