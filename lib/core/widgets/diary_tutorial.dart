import 'package:flutter/material.dart';
import '../../app/theme/diary_motion.dart';
import '../../app/theme/diary_theme.dart';
import 'diary_button.dart';
import 'notebook_background.dart';
import '../../l10n/app_localizations.dart';

class DiaryTutorialStep {
  const DiaryTutorialStep({required this.target, required this.title, required this.body, this.onReveal});
  final GlobalKey target;
  final String title;
  final String body;
  final Future<void> Function()? onReveal;
}

class DiaryTutorial extends StatefulWidget {
  const DiaryTutorial({super.key, required this.steps, this.initialStep = 0, this.completionLabel, this.showProgress = true}) : assert(steps.length > 0);
  final List<DiaryTutorialStep> steps;
  final int initialStep;
  final String? completionLabel;
  final bool showProgress;
  @override
  State<DiaryTutorial> createState() => _DiaryTutorialState();
}

class _DiaryTutorialState extends State<DiaryTutorial> with WidgetsBindingObserver {
  int _step = 0;
  Rect? _target;
  bool _moving = true;
  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, widget.steps.length - 1);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }
  void _measure() {
    if (!mounted) return;
    final box = widget.steps[_step].target.currentContext?.findRenderObject();
    setState(() {
      _target = box is RenderBox && box.hasSize
        ? (box.localToGlobal(Offset.zero) & box.size).inflate(6) : null;
      _moving = false;
    });
  }
  Future<void> _reveal() async {
    await widget.steps[_step].onReveal?.call();
    if (!mounted) return;
    final targetContext = widget.steps[_step].target.currentContext;
    if (targetContext != null && targetContext.mounted) {
      await Scrollable.ensureVisible(targetContext, alignment: 0.5,
        duration: DiaryMotion.duration(context, DiaryMotion.transition));
    }
    if (!mounted) return;
    await WidgetsBinding.instance.endOfFrame;
    _measure();
  }
  void _next() {
    if (_step == widget.steps.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() { _step++; _target = null; _moving = true; });
    WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final step = widget.steps[_step];
    final height = MediaQuery.sizeOf(context).height;
    final atTop = _target != null && _target!.center.dy > height / 2;
    return Material(color: Colors.transparent, child: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _TutorialSpotlight(_target))),
      SafeArea(child: Align(alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: Padding(padding: const EdgeInsets.all(18),
          child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 480, maxHeight: height * 0.48),
            child: Container(clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: DiaryColors.paper,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: DiaryColors.ink, width: 2)),
              child: NotebookBackground(child: SingleChildScrollView(
                padding: const EdgeInsets.all(18), child: Column(
                  mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.showProgress) ...[
                      Text('${_step + 1} / ${widget.steps.length}',
                        style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                    ],
                    Semantics(header: true, liveRegion: true,
                      child: Text(step.title, style: Theme.of(context).textTheme.titleLarge)),
                    const SizedBox(height: 8),
                    Text(step.body, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    DiaryButton(label: _step == widget.steps.length - 1
                      ? (widget.completionLabel ?? strings.tutorialDone) : strings.tutorialNext,
                      onPressed: _moving ? null : _next),
                    TextButton(onPressed: () => Navigator.of(context).pop(),
                      child: Text(strings.tutorialSkip)),
                  ])))))))),
    ]));
  }
}

class _TutorialSpotlight extends CustomPainter {
  const _TutorialSpotlight(this.target);
  final Rect? target;
  @override
  void paint(Canvas canvas, Size size) {
    final background = Path()..addRect(Offset.zero & size);
    if (target == null) {
      canvas.drawPath(background, Paint()..color = const Color(0xB31B2233));
      return;
    }
    final highlight = RRect.fromRectAndRadius(target!, const Radius.circular(18));
    final cutout = Path()..addRRect(highlight);
    canvas.drawPath(Path.combine(PathOperation.difference, background, cutout),
      Paint()..color = const Color(0xB31B2233));
    canvas.drawRRect(highlight, Paint()..color = DiaryColors.haldi
      ..style = PaintingStyle.stroke..strokeWidth = 3);
  }
  @override
  bool shouldRepaint(_TutorialSpotlight oldDelegate) => target != oldDelegate.target;
}
