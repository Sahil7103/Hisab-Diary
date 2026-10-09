import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../app/theme/diary_motion.dart';

class DiaryButton extends StatefulWidget {
  const DiaryButton({super.key, required this.label, required this.onPressed,
    this.color = DiaryColors.pen, this.edge = DiaryColors.penEdge,
    this.foreground = Colors.white, this.child, this.selected = false, this.radius = 16});
  final String label;
  final double radius;
  final Widget? child;
  final bool selected;
  final VoidCallback? onPressed;
  final Color color;
  final Color edge;
  final Color foreground;
  @override
  State<DiaryButton> createState() => _DiaryButtonState();
}
class _DiaryButtonState extends State<DiaryButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => AnimatedPadding(
    duration: DiaryMotion.duration(context, DiaryMotion.press),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(top: _pressed ? 3 : 0, bottom: _pressed ? 0 : 3),
    child: Semantics(button: true, onTap: widget.onPressed, label: widget.label, selected: widget.selected, enabled: widget.onPressed != null, excludeSemantics: true, child: Material(color: widget.color,
      animationDuration: DiaryMotion.duration(context, DiaryMotion.press),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
      child: InkWell(onTap: widget.onPressed,
        onHighlightChanged: (value) => setState(() => _pressed = value),
        borderRadius: BorderRadius.circular(widget.radius),
        child: AnimatedContainer(
          duration: DiaryMotion.duration(context, DiaryMotion.press),
          curve: Curves.easeOut, constraints: const BoxConstraints(minHeight: 56),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.radius),
            border: Border(top: BorderSide(color: widget.edge, width: 2),
              left: BorderSide(color: widget.edge, width: 2),
              right: BorderSide(color: widget.edge, width: 2),
              bottom: BorderSide(color: widget.edge, width: _pressed ? 3 : 6))),
          child: widget.child ?? Text(widget.label, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge!
              .copyWith(color: widget.foreground))),
      ),
    )),
  );
}



