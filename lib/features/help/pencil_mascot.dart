import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';

class PencilMascot extends StatefulWidget {
  const PencilMascot({super.key, this.waving = false, this.size = 56});
  final bool waving;
  final double size;
  @override
  State<PencilMascot> createState() => _PencilMascotState();
}

class _PencilMascotState extends State<PencilMascot> with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(vsync: this,
    duration: const Duration(milliseconds: 1800));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
      _motion.value = 0;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }
  @override
  void dispose() { _motion.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => RepaintBoundary(child: CustomPaint(
    size: Size.square(widget.size), painter: _PencilPainter(_motion, widget.waving)));
}

class _PencilPainter extends CustomPainter {
  _PencilPainter(this.motion, this.waving) : super(repaint: motion);
  final Animation<double> motion;
  final bool waving;
  @override
  void paint(Canvas canvas, Size size) {
    final beat = math.sin(motion.value * math.pi * 2);
    canvas.save();
    canvas.scale(size.width / 64, size.height / 64);
    canvas.translate(32, 32 + beat * 1.5);
    canvas.rotate(-0.16 + beat * 0.035);
    canvas.translate(-32, -32);
    final fill = Paint()..color = DiaryColors.haldi;
    final edge = Paint()..color = DiaryColors.ink..style = PaintingStyle.stroke
      ..strokeWidth = 2..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final body = RRect.fromRectAndRadius(const Rect.fromLTWH(22, 12, 20, 34), const Radius.circular(5));
    canvas.drawRRect(body, fill);
    canvas.drawRRect(body, edge);
    canvas.drawLine(const Offset(27, 19), const Offset(27, 39), Paint()
      ..color = Colors.white.withValues(alpha: 0.65)..strokeWidth = 3..strokeCap = StrokeCap.round);
    final eraser = RRect.fromRectAndRadius(const Rect.fromLTWH(22, 7, 20, 10), const Radius.circular(4));
    canvas.drawRRect(eraser, Paint()..color = DiaryColors.pen);
    canvas.drawRRect(eraser, edge);
    final tip = Path()..moveTo(22, 44)..lineTo(32, 58)..lineTo(42, 44)..close();
    canvas.drawPath(tip, Paint()..color = DiaryColors.haldiSoft);
    canvas.drawPath(tip, edge);
    canvas.drawPath(Path()..moveTo(28, 53)..lineTo(32, 58)..lineTo(36, 53)..close(),
      Paint()..color = DiaryColors.ink);
    canvas.drawCircle(const Offset(30, 27), 1.5, Paint()..color = DiaryColors.ink);
    canvas.drawCircle(const Offset(37, 27), 1.5, Paint()..color = DiaryColors.ink);
    canvas.drawArc(const Rect.fromLTWH(30, 29, 8, 6), 0.1, math.pi - 0.2, false, edge);
    canvas.drawLine(const Offset(22, 32), const Offset(16, 37), edge);
    canvas.save();
    canvas.translate(42, 31);
    canvas.rotate(waving ? -0.55 + beat * 0.55 : 0.1);
    canvas.drawPath(Path()..moveTo(0, 0)..quadraticBezierTo(9, 0, 9, -10), edge);
    canvas.drawCircle(const Offset(9, -12), 3, Paint()..color = DiaryColors.paper);
    canvas.drawCircle(const Offset(9, -12), 3, edge);
    canvas.restore();
    canvas.restore();
  }
  @override
  bool shouldRepaint(_PencilPainter oldDelegate) => waving != oldDelegate.waving;
}
