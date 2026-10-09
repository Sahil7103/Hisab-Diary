import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../app/theme/diary_theme.dart';
import '../../app/theme/diary_motion.dart';
import '../../core/widgets/diary_button.dart';
import '../../l10n/app_localizations.dart';
import 'today_repository.dart';
import '../vendors/vendor_type.dart';
import '../vendors/vendor_icon.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.record, required this.busy,
    required this.onMark, required this.onOpen, required this.onEdit, required this.onDelete});
  final TodayVendor record;
  final bool busy;
  final ValueChanged<Attendance> onMark;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final vendor = record.vendor;
    final title = vendorTypeLabel(strings, vendor.type);
    final came = record.status == Attendance.came;
    final absent = record.status == Attendance.notCame;
    final color = came ? DiaryColors.cameEdge : absent
        ? DiaryColors.absentEdge : DiaryColors.ink;
    final quantity = NumberFormat.decimalPattern(strings.localeName)
      .format(vendor.defaultQty);
    final subtitle = [if (vendor.name.trim().isNotEmpty) vendor.name,
      '$quantity ${vendorUnitLabel(strings, vendor.unit)}'].join(' · ');
    return AnimatedContainer(
      duration: DiaryMotion.duration(context, DiaryMotion.transition),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: came ? DiaryColors.cameTint : absent
          ? DiaryColors.absentTint : Colors.white,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(builder: (context, constraints) {
        final large = MediaQuery.textScalerOf(context).scale(18) > 22 ||
            constraints.maxWidth < 280;
        final stamp = record.status == null ? null : TweenAnimationBuilder<double>(
          key: ValueKey(record.status),
          tween: Tween(begin: MediaQuery.disableAnimationsOf(context) ? 1.0 : 0.8, end: 1.0),
          duration: DiaryMotion.duration(context, DiaryMotion.transition),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Transform.scale(scale: value, child: child),
          child: _StatusStamp(
          label: came ? strings.came : strings.notCame,
          icon: came ? Icons.check : Icons.close, color: color));
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(textDirection: TextDirection.ltr, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Semantics(button: true, onTap: onOpen, label: strings.openMonth([title, subtitle].join(' · ')),
              excludeSemantics: true,
              child: Material(color: Colors.transparent,
                child: InkWell(onTap: onOpen,
                  borderRadius: BorderRadius.circular(18),
                  child: Row(children: [
                    Container(width: 56, height: 56, padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: DiaryColors.haldiSoft,
                        borderRadius: BorderRadius.circular(18)),
                      child: VendorIcon(type: vendor.type, size: 32)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleLarge),
                        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                      ])),
                    if (!large && stamp != null) ...[
                      const SizedBox(width: 8), stamp,
                    ],
                  ]))))),
            PopupMenuButton<int>(enabled: !busy, padding: EdgeInsets.zero,
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              color: DiaryColors.paper,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: DiaryColors.ink, width: 2)),
              icon: const Icon(Icons.more_vert_rounded, color: DiaryColors.ink),
              onSelected: (action) { if (action == 0) { onEdit(); } else { onDelete(); } },
              itemBuilder: (_) => [
                PopupMenuItem(value: 0, child: Row(children: [
                  const Icon(Icons.edit_outlined, size: 20, color: DiaryColors.ink),
                  const SizedBox(width: 10), Expanded(child: Text(strings.editVendor,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DiaryColors.ink))),
                ])),
                PopupMenuItem(value: 1, child: Row(children: [
                  const Icon(Icons.delete_outline_rounded, size: 20, color: DiaryColors.absentEdge),
                  const SizedBox(width: 10), Expanded(child: Text(strings.deleteVendor,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DiaryColors.absentEdge))),
                ])),
              ]),
          ]),
          if (large && stamp != null) Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(alignment: Alignment.centerRight, child: stamp)),
          const SizedBox(height: 12),
          Flex(direction: large ? Axis.vertical : Axis.horizontal,
            children: [
              Flexible(flex: large ? 0 : 1, child: DiaryButton(
                label: '${strings.came} ✔', selected: came,
                color: came ? DiaryColors.cameEdge : DiaryColors.cameTint,
                foreground: came ? Colors.white : DiaryColors.cameEdge,
                edge: DiaryColors.cameEdge,
                onPressed: busy ? null : () => onMark(Attendance.came))),
              SizedBox(width: large ? 0 : 10, height: large ? 10 : 0),
              Flexible(flex: large ? 0 : 1, child: DiaryButton(
                label: '${strings.notCame} ✕', selected: absent,
                color: absent ? DiaryColors.absentEdge : DiaryColors.absentTint,
                foreground: absent ? Colors.white : DiaryColors.absentEdge,
                edge: DiaryColors.absentEdge,
                onPressed: busy ? null : () => onMark(Attendance.notCame))),
            ]),
        ]);
      }),
    );
  }
}
class _StatusStamp extends StatelessWidget {
  const _StatusStamp({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: Transform.rotate(
    angle: -12 * math.pi / 180,
    child: Container(width: 62, height: 62, padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
        border: Border.all(color: color, width: 3)),
      child: Container(decoration: BoxDecoration(shape: BoxShape.circle,
        border: Border.all(color: color)),
        child: Padding(padding: const EdgeInsets.all(5),
          child: FittedBox(fit: BoxFit.scaleDown,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(label, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.w700, color: color)),
              Icon(icon, color: color, size: 20),
            ])))),
    ),
  ));
}

