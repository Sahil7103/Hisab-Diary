import 'package:flutter/material.dart';

abstract final class DiaryMotion {
  static const press = Duration(milliseconds: 120);
  static const transition = Duration(milliseconds: 220);
  static const intro = Duration(seconds: 3);

  static Duration duration(BuildContext context, Duration value) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : value;
}
