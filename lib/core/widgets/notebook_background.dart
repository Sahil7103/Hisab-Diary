import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';

class NotebookBackground extends StatelessWidget {
  const NotebookBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _NotebookPainter(), child: child);
}
class _NotebookPainter extends CustomPainter {
  const _NotebookPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = DiaryColors.paper);
    final rule = Paint()..color = DiaryColors.rule..strokeWidth = 1;
    for (double y = 31; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), rule);
    }
  }
  @override
  bool shouldRepaint(_NotebookPainter oldDelegate) => false;
}
