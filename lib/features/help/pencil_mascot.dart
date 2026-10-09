import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PencilMascot extends StatefulWidget {
  const PencilMascot({super.key, this.waving = false, this.size = 56});
  final bool waving;
  final double size;
  @override
  State<PencilMascot> createState() => _PencilMascotState();
}

class _PencilMascotState extends State<PencilMascot> with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(vsync: this,
    duration: const Duration(milliseconds: 4200));
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
  Widget build(BuildContext context) => RepaintBoundary(child: AnimatedBuilder(
    animation: _motion,
    child: SizedBox.square(dimension: widget.size,
      child: SvgPicture.asset('assets/branding/help-pencil.svg',
        excludeFromSemantics: true)),
    builder: (context, child) {
      final phase = _motion.value;
      final float = math.sin(phase * math.pi * 2);
      // Two restrained greeting tilts, followed by a pause between waves.
      final wave = widget.waving && phase < 0.55
        ? math.sin(phase / 0.55 * math.pi * 4) * math.sin(phase / 0.55 * math.pi) : 0.0;
      return Transform.translate(offset: Offset(0, float * 1.5),
        child: Transform.rotate(angle: 0.52 + wave * 0.16,
          child: child));
    },
  ));
}
