import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../app/theme/diary_theme.dart';
import '../../l10n/app_localizations.dart';
import '../month/month_bill.dart';
import '../vendors/vendor_type.dart';
import 'all_vendors_bill.dart';
import 'bill_message.dart';

enum BillExportFormat { pdf, csv }

class BillExportFile {
  const BillExportFile({required this.bytes, required this.name, required this.mimeType});
  final Uint8List bytes;
  final String name;
  final String mimeType;
}

class BillExportService {
  Future<BillExportFile> createExport(AllVendorsBill bill,
      AppLocalizations strings, BillExportFormat format) async {
    final month = diaryMonth(bill.month);
    final scope = bill.bills.length == 1 ? 'vendor-${bill.bills.single.vendor.id}' : 'all-vendors';
    return BillExportFile(
      bytes: format == BillExportFormat.csv ? _csv(bill, strings) : await _pdf(bill, strings),
      name: 'hisab-diary-$month-$scope.${format.name}',
      mimeType: format == BillExportFormat.csv ? 'text/csv' : 'application/pdf',
    );
  }

  Uint8List _csv(AllVendorsBill bill, AppLocalizations strings) {
    // Stable headers and decimal numbers allow imports regardless of app language.
    final rows = <List<String>>[
      ['billing_month', 'vendor_name', 'service', 'unit', 'came_days',
        'not_came_days', 'automatic_days', 'daily_quantity', 'unit_rate_inr', 'total_inr'],
      for (final row in bill.bills)
        [diaryMonth(bill.month), _csvText(row.vendor.name.trim().isEmpty
          ? vendorTypeLabel(strings, row.vendor.type) : row.vendor.name),
          _csvText(vendorTypeLabel(strings, row.vendor.type)),
          _csvText(vendorUnitLabel(strings, row.vendor.unit)),
          '${row.cameDays}', '${row.notCameDays}', '${row.automaticDays}',
          _decimal(row.quantity), _decimal(row.rate), _money(row.totalPaise)],
      [diaryMonth(bill.month), _csvText(strings.monthlyTotal), '', '', '', '', '', '', '',
        _money(bill.totalPaise)],
    ];
    return Uint8List.fromList(utf8.encode('\uFEFF${rows.map((row) => row.join(',')).join('\r\n')}\r\n'));
  }

  String _csvText(String text) {
    var value = text.replaceAll('\u0000', '');
    // Quoting alone does not stop spreadsheet formulas in untrusted vendor names.
    if (RegExp(r'^[\s\u0000-\u001f\uFEFF]*[=+\-@]').hasMatch(value) ||
        RegExp(r'^[\t\r\n]').hasMatch(value)) {
      value = "'$value";
    }
    return '"${value.replaceAll('"', '""')}"';
  }

  String _decimal(double value) => value == value.roundToDouble()
    ? value.toInt().toString() : value.toString();

  String _money(int paise) => '${paise < 0 ? '-' : ''}${paise.abs() ~/ 100}.'
    '${(paise.abs() % 100).toString().padLeft(2, '0')}';

  Future<Uint8List> _pdf(AllVendorsBill bill, AppLocalizations strings) async {
    final renderer = _BillPdfText(strings.localeName);
    final pageNumberFont = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansDevanagari.ttf'));
    final document = pw.Document(title: '${strings.appName} - ${strings.bill}',
      author: strings.appName, creator: strings.appName);
    final numbers = NumberFormat.decimalPattern(strings.localeName);
    final pageWidth = PdfPageFormat.a4.width - 80;
    final title = await renderer.text(strings.appName, pageWidth, size: 14, bold: true,
      color: DiaryColors.pen);
    final subtitle = await renderer.text(
      '${strings.bill} \u00b7 ${DateFormat.yMMMM(strings.localeName).format(bill.month)}',
      pageWidth, size: 23, bold: true);
    final totalLabel = await renderer.text(strings.monthlyTotal, pageWidth - 28,
      size: 11, color: DiaryColors.muted);
    final total = await renderer.text(allVendorsTotalLabel(bill, strings.localeName),
      pageWidth - 28, size: 28, bold: true, color: DiaryColors.pen);
    final info = await renderer.text(strings.allVendorsBillInfo, pageWidth, size: 9,
      color: DiaryColors.muted);
    final footer = await renderer.text('${strings.shareSource}: ${strings.appName}',
      pageWidth - 70, size: 9, color: DiaryColors.muted);
    final content = <pw.Widget>[
      title,
      pw.SizedBox(height: 5),
      subtitle,
      pw.SizedBox(height: 20),
      pw.Container(width: pageWidth, padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(color: _color(DiaryColors.haldiSoft),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12))),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [totalLabel, pw.SizedBox(height: 3), total])),
      pw.SizedBox(height: 12),
      info,
      pw.SizedBox(height: 16),
    ];
    for (var index = 0; index < bill.bills.length; index++) {
      final row = bill.bills[index];
      final name = row.vendor.name.trim().replaceAll(RegExp(r'[\r\n]+'), ' ');
      final type = vendorTypeLabel(strings, row.vendor.type);
      final unit = vendorUnitLabel(strings, row.vendor.unit);
      final nameParts = await renderer.parts(
        '${numbers.format(index + 1)}. ${name.isEmpty ? type : name}',
        pageWidth - 138, size: 12, bold: true);
      final amount = await renderer.text(billTotalLabel(row, strings.localeName),
        124, size: 13, bold: true, align: TextAlign.right);
      final service = await renderer.text(type, pageWidth, size: 9,
        color: DiaryColors.muted);
      final counts = await renderer.text([
        strings.cameCount(numbers.format(row.cameDays)),
        strings.notCameCount(numbers.format(row.notCameDays)),
        if (row.automaticDays > 0) strings.autoCounted(numbers.format(row.automaticDays)),
      ].join(' \u00b7 '), pageWidth, size: 9, color: DiaryColors.muted);
      final rate = NumberFormat.currency(locale: strings.localeName, symbol: '\u20b9',
        decimalDigits: row.rate == row.rate.roundToDouble() ? 0 : 2).format(row.rate);
      final calculation = await renderer.text(
        '${strings.shareDailyQuantity}: ${numbers.format(row.quantity)} $unit'
        ' \u00b7 ${strings.unitRate(unit)}: $rate', pageWidth, size: 9,
        color: DiaryColors.muted);
      content.addAll([
        pw.NewPage(freeSpace: 110),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          nameParts.first, pw.SizedBox(width: 14), amount]),
        for (final part in nameParts.skip(1)) part,
        pw.SizedBox(height: 3),
        if (name.isNotEmpty) service,
        pw.SizedBox(height: 5),
        counts,
        pw.SizedBox(height: 3),
        calculation,
        pw.Container(height: 1, color: _color(DiaryColors.rule),
          margin: const pw.EdgeInsets.only(top: 12, bottom: 14)),
      ]);
    }
    document.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40), maxPages: bill.bills.length * 2 + 20,
      footer: (context) => pw.Padding(padding: const pw.EdgeInsets.only(top: 14),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [footer, pw.Text('${context.pageNumber} / ${context.pagesCount}',
            style: pw.TextStyle(font: pageNumberFont, fontSize: 9, color: PdfColors.grey600))])),
      build: (context) => content));
    return document.save();
  }
}

PdfColor _color(Color color) => PdfColor.fromInt(color.toARGB32());

class _BillPdfText {
  _BillPdfText(this.locale);
  final String locale;
  late final _style = diaryTheme(locale).textTheme.bodyMedium!;
  static const _scale = 3.0;
  static const _maxPartHeight = 180.0;
  static const _fonts = ['NotoSansDevanagari', 'NotoSansGujarati', 'NotoSansTamil',
    'NotoSansArabic', 'NotoSansBengali', 'NotoSansTelugu', 'NotoSansKannada'];

  Future<pw.Widget> text(String value, double width, {double size = 12,
      bool bold = false, Color color = DiaryColors.ink, TextAlign? align}) async {
    final fragments = await parts(value, width, size: size, bold: bold,
      color: color, align: align);
    return fragments.length == 1 ? fragments.first
      : pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: fragments);
  }

  Future<List<pw.Widget>> parts(String value, double width, {double size = 12,
      bool bold = false, Color color = DiaryColors.ink, TextAlign? align}) async {
    // Flutter shapes Indic and Urdu text; raw PDF Text cannot shape these scripts.
    final painter = TextPainter(text: TextSpan(text: value,
      style: _style.copyWith(fontSize: size,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500, color: color,
        fontFamilyFallback: _fonts, height: 1.35)),
      textDirection: locale == 'ur' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      textAlign: align ?? (locale == 'ur' ? TextAlign.right : TextAlign.left))
      ..layout(minWidth: width, maxWidth: width);
    final result = <pw.Widget>[];
    try {
      final lines = painter.computeLineMetrics();
      var start = 0.0;
      var end = 0.0;
      for (var index = 0; index < lines.length; index++) {
        end += lines[index].height;
        if (index + 1 < lines.length && end - start + lines[index + 1].height < _maxPartHeight) {
          continue;
        }
        final height = (end - start).ceilToDouble() + 2;
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder)..scale(_scale)..translate(0, -start);
        painter.paint(canvas, Offset.zero);
        final picture = recorder.endRecording();
        ui.Image? image;
        try {
          image = await picture.toImage((width * _scale).ceil(), (height * _scale).ceil());
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          if (png == null) throw StateError('Could not render bill text');
          result.add(pw.Image(pw.MemoryImage(png.buffer.asUint8List(
            png.offsetInBytes, png.lengthInBytes)), width: width, height: height));
        } finally {
          image?.dispose();
          picture.dispose();
        }
        start = end;
      }
      return result;
    } finally {
      painter.dispose();
    }
  }
}
