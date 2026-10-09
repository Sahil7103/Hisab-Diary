import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/theme/diary_theme.dart';
import '../../app/theme/diary_motion.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onComplete});
  final VoidCallback? onComplete;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: DiaryMotion.intro)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete?.call();
      });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      if (_controller.value != 1) {
        // Complete after this frame so the parent can safely replace the splash.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _controller.value = 1;
        });
      }
    } else if (!_started) {
      _controller.forward();
    }
    _started = true;
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget _reveal({required Widget child, required double start}) =>
    AnimatedBuilder(animation: _controller, child: child, builder: (context, child) {
      final value = Curves.easeOutCubic.transform(
        ((_controller.value - start) / (1 - start)).clamp(0.0, 1.0));
      return Opacity(opacity: value, child: Transform.translate(
        offset: Offset(0, 10 * (1 - value)), child: child));
    });
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return NotebookBackground(child: Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: Padding(padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ExcludeSemantics(child: AnimatedBuilder(animation: _controller,
                builder: (context, _) {
                  final progress = _controller.value;
                  final entrance = Curves.easeOutBack.transform((progress / 0.3).clamp(0.0, 1.0));
                  final sway = math.sin(progress * math.pi * 4) * (1 - progress);
                  return Transform.translate(offset: Offset(0, -6 * sway),
                    child: Transform.rotate(angle: -0.18 * (1 - entrance) + 0.035 * sway,
                      child: Transform.scale(scale: 0.72 + 0.28 * entrance,
                        child: CustomPaint(size: const Size(176, 176),
                          painter: _NotebookRevealPainter(progress)))));
                })),
              const SizedBox(height: 28),
              _reveal(start: 0.2, child: Semantics(header: true, child: Text(strings.appName,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge))),
              const SizedBox(height: 8),
              _reveal(start: 0.35, child: Text(strings.splashTagline, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: DiaryColors.muted))),
              const SizedBox(height: 28),
              Semantics(label: strings.loading, liveRegion: true,
                child: SizedBox(width: 72, child: LinearProgressIndicator(
                  value: MediaQuery.disableAnimationsOf(context) ? 1 : null,
                  color: DiaryColors.pen, backgroundColor: DiaryColors.haldiSoft,
                  minHeight: 4, borderRadius: const BorderRadius.all(Radius.circular(4))))),
            ]))),
        ),
      )),
    )));
  }
}

class _NotebookRevealPainter extends CustomPainter {
  const _NotebookRevealPainter(this.progress);
  final double progress;

  double _stage(double start, double end) =>
      ((progress - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 176, size.height / 176);
    final glow = math.sin(progress * math.pi);
    canvas.drawCircle(const Offset(88, 88), 72 + 8 * glow,
      Paint()..color = DiaryColors.haldi.withValues(alpha: 0.12 + 0.12 * glow));
    final spark = math.sin(_stage(0.5, 0.95) * math.pi);
    final accent = Paint()..color = DiaryColors.haldi..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final angle = math.pi / 4 + i * math.pi / 2;
      final center = Offset(88 + math.cos(angle) * (76 + 5 * spark),
        88 + math.sin(angle) * (76 + 5 * spark));
      canvas.drawLine(center - Offset(4 * spark, 0), center + Offset(4 * spark, 0), accent);
      canvas.drawLine(center - Offset(0, 4 * spark), center + Offset(0, 4 * spark), accent);
    }
    // Keep the icon's original notebook coordinates for the drawing sequence.
    canvas.translate(24, 13);
    canvas.scale(128 / 72);
    canvas.translate(-18, -12);
    final outline = Paint()..color = DiaryColors.ink..style = PaintingStyle.stroke
      ..strokeWidth = 3..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final book = RRect.fromRectAndRadius(const Rect.fromLTWH(20, 14, 68, 80), const Radius.circular(8));
    canvas.drawRRect(book, Paint()..color = DiaryColors.paper);
    canvas.save();
    canvas.clipRRect(book);
    canvas.drawRect(const Rect.fromLTWH(20, 14, 18, 80), Paint()..color = DiaryColors.haldi);
    canvas.restore();
    canvas.drawRRect(book, outline);
    canvas.drawLine(const Offset(39, 15), const Offset(39, 93), outline..strokeWidth = 2);
    final pen = Paint()..color = DiaryColors.pen..strokeWidth = 3..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final amount = _stage(0.18 + i * 0.08, 0.36 + i * 0.08);
      if (amount > 0) {
        canvas.drawLine(Offset(48, 30 + i * 12),
          Offset(48 + (i == 2 ? 11 : 28) * amount, 30 + i * 12), pen);
      }
    }
    final check = Path()..moveTo(49, 70)..lineTo(58, 79)..lineTo(77, 60);
    final amount = Curves.easeInOut.transform(_stage(0.52, 0.82));
    if (amount > 0) {
      final metric = check.computeMetrics().first;
      canvas.drawPath(metric.extractPath(0, metric.length * amount),
        Paint()..color = DiaryColors.cameEdge..style = PaintingStyle.stroke
          ..strokeWidth = 5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_NotebookRevealPainter oldDelegate) => oldDelegate.progress != progress;
}
