import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../l10n/app_localizations.dart';
import 'month_bill.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({super.key, required this.number, required this.dateLabel,
    required this.attendance, required this.isToday, required this.onPressed});
  final String number;
  final String dateLabel;
  final DayAttendance attendance;
  final bool isToday;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final came = attendance == DayAttendance.came || attendance == DayAttendance.automatic;
    final absent = attendance == DayAttendance.notCame;
    final disabled = attendance == DayAttendance.disabled;
    final ink = came ? DiaryColors.cameEdge : absent ? DiaryColors.absentEdge : DiaryColors.muted;
    final color = came ? DiaryColors.cameTint : absent ? DiaryColors.absentTint : Colors.white;
    final label = switch (attendance) {
      DayAttendance.came => strings.came,
      DayAttendance.notCame => strings.notCame,
      DayAttendance.automatic => strings.autoCame,
      DayAttendance.unmarked => strings.unmarked,
      DayAttendance.disabled => strings.dayUnavailable,
    };
    return Semantics(button: true, label: [dateLabel, if (isToday) strings.today, label].join(', '),
      enabled: onPressed != null, onTap: onPressed, excludeSemantics: true,
      child: CustomPaint(foregroundPainter: disabled ? const _DashedBorder() : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isToday ? Border.all(color: DiaryColors.haldi, width: 3)
              : disabled ? null : Border.all(color: ink, width: 2),
          ),
          child: Padding(padding: EdgeInsets.all(isToday ? 2 : 0),
            child: Material(color: disabled ? DiaryColors.paper : color,
              borderRadius: BorderRadius.circular(isToday ? 7 : 10),
              child: InkWell(onTap: onPressed,
                borderRadius: BorderRadius.circular(10),
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(number, textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w700, color: ink))),
              ))),
        ),
      ));
  }
}
class _DashedBorder extends CustomPainter {
  const _DashedBorder();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(1), const Radius.circular(12)));
    final paint = Paint()..color = DiaryColors.muted..strokeWidth = 2..style = PaintingStyle.stroke;
    for (final metric in path.computeMetrics()) {
      for (double start = 0; start < metric.length; start += 8) {
        canvas.drawPath(metric.extractPath(start, start + 4), paint);
      }
    }
  }
  @override
  bool shouldRepaint(_DashedBorder oldDelegate) => false;
}
