import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/theme/diary_theme.dart';
import 'vendor_type.dart';

class VendorIcon extends StatelessWidget {
  const VendorIcon({super.key, required this.type, this.size = 28});
  final String type;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: type == 'fruits'
      ? SvgPicture.asset('assets/illustrations/fruits.svg', width: size, height: size,
          colorFilter: const ColorFilter.mode(DiaryColors.pen, BlendMode.srcIn))
      : Icon(vendorTypeIcon(type), size: size, color: DiaryColors.pen));
}
