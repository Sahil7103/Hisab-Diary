import 'package:flutter/material.dart';

abstract final class DiaryColors {
  static const paper = Color(0xFFFFFEF8);
  static const rule = Color(0xFFE3ECF7);
  static const ink = Color(0xFF1B2233);
  static const muted = Color(0xFF55607A);
  static const pen = Color(0xFF1C3FA0);
  static const penEdge = Color(0xFF10286B);
  static const came = Color(0xFF1E8A4C);
  static const cameEdge = Color(0xFF0F5C31);
  static const cameTint = Color(0xFFDDF3E5);
  static const absent = Color(0xFFD2382C);
  static const absentEdge = Color(0xFF8F2018);
  static const absentTint = Color(0xFFFBE3E0);
  static const haldi = Color(0xFFFFC93C);
  static const haldiSoft = Color(0xFFFFF1BF);
  static const messageTint = Color(0xFFDCF8C6);
  static const messageBorder = Color(0xFFB9E3A0);
}

ThemeData diaryTheme(String language) {
  final bodyFont = switch (language) {
    'gu' => 'NotoSansGujarati', 'ta' => 'NotoSansTamil',
    'ur' => 'NotoSansArabic', 'bn' => 'NotoSansBengali',
    'te' => 'NotoSansTelugu', 'kn' => 'NotoSansKannada',
    _ => 'NotoSansDevanagari',
  };
  final headingFont = ['ta', 'ur', 'bn', 'te', 'kn'].contains(language)
    ? bodyFont : 'Baloo2';
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: bodyFont,
    fontFamilyFallback: const ['NotoSansDevanagari', 'NotoSansGujarati',
      'NotoSansTamil', 'NotoSansArabic', 'NotoSansBengali',
      'NotoSansTelugu', 'NotoSansKannada'],
    colorScheme: ColorScheme.fromSeed(seedColor: DiaryColors.pen,
      primary: DiaryColors.pen, surface: DiaryColors.paper,
      onSurface: DiaryColors.ink),
    textTheme: TextTheme(
      displaySmall: TextStyle(fontFamily: headingFont, fontSize: 40,
        fontWeight: FontWeight.w800, color: DiaryColors.ink),
      headlineLarge: TextStyle(fontFamily: headingFont, fontSize: 32,
        fontWeight: FontWeight.w800, color: DiaryColors.ink),
      titleLarge: TextStyle(fontFamily: headingFont, fontSize: 24,
        fontWeight: FontWeight.w800, color: DiaryColors.ink),
      labelLarge: TextStyle(fontFamily: headingFont, fontSize: 21,
        fontWeight: FontWeight.w800),
      bodyLarge: TextStyle(fontFamily: bodyFont, fontSize: 19,
        fontWeight: FontWeight.w500, color: DiaryColors.ink),
      bodyMedium: TextStyle(fontFamily: bodyFont, fontSize: 16,
        fontWeight: FontWeight.w500, color: DiaryColors.muted),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: DiaryColors.paper,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: DiaryColors.ink, width: 2)),
      dialBackgroundColor: DiaryColors.haldiSoft,
      dialHandColor: DiaryColors.pen,
      dialTextColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? Colors.white : DiaryColors.ink),
      dialTextStyle: TextStyle(fontFamily: bodyFont, fontSize: 16,
        fontWeight: FontWeight.w700),
      hourMinuteColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? DiaryColors.haldi : Colors.white),
      hourMinuteTextColor: DiaryColors.ink,
      hourMinuteTextStyle: TextStyle(fontFamily: headingFont, fontSize: 40,
        fontWeight: FontWeight.w800),
      hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DiaryColors.ink, width: 2)),
      dayPeriodColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? DiaryColors.haldi : Colors.white),
      dayPeriodTextColor: DiaryColors.ink,
      dayPeriodTextStyle: TextStyle(fontFamily: bodyFont, fontSize: 16,
        fontWeight: FontWeight.w700),
      dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      dayPeriodBorderSide: const BorderSide(color: DiaryColors.ink, width: 2),
      helpTextStyle: TextStyle(fontFamily: headingFont, fontSize: 21,
        fontWeight: FontWeight.w800, color: DiaryColors.ink),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: DiaryColors.ink, backgroundColor: Colors.white,
        minimumSize: const Size(72, 56),
        side: const BorderSide(color: DiaryColors.ink, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: DiaryColors.pen,
        minimumSize: const Size(72, 56),
        side: const BorderSide(color: DiaryColors.penEdge, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
      minimumSize: const Size(56, 56), foregroundColor: DiaryColors.ink)),
    iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(
      minimumSize: const Size(56, 56), foregroundColor: DiaryColors.ink)),
    cardTheme: CardThemeData(color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: DiaryColors.ink, width: 2))),
  );
}




