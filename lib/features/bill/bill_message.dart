import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../month/month_bill.dart';
import '../vendors/vendor_type.dart';
import 'all_vendors_bill.dart';

String _totalLabel(int totalPaise, String locale) => NumberFormat.currency(
  locale: locale, symbol: '\u20b9', decimalDigits: totalPaise % 100 == 0 ? 0 : 2,
).format(totalPaise / 100);

String billTotalLabel(MonthBill bill, String locale) =>
    _totalLabel(bill.totalPaise, locale);

String allVendorsTotalLabel(AllVendorsBill bill, String locale) =>
    _totalLabel(bill.totalPaise, locale);

String billVendorLabel(MonthBill bill, AppLocalizations strings) {
  final name = bill.vendor.name.trim().replaceAll(RegExp(r'[\r\n]+'), ' ');
  final type = vendorTypeLabel(strings, bill.vendor.type);
  return name.isEmpty ? type : '$name \u00b7 $type';
}

String allVendorsShareMessage(AllVendorsBill bill, AppLocalizations strings) {
  final numbers = NumberFormat.decimalPattern(strings.localeName);
  return [
    '*${strings.bill}: ${strings.allVendors}*',
    '${strings.shareBillingMonth}: ${DateFormat.yMMMM(strings.localeName).format(bill.month)}',
    '',
    for (var index = 0; index < bill.bills.length; index++)
      '${numbers.format(index + 1)}. ${billVendorLabel(bill.bills[index], strings)}: ${billTotalLabel(bill.bills[index], strings.localeName)}',
    '',
    '*${strings.monthlyTotal}: ${allVendorsTotalLabel(bill, strings.localeName)}*',
    strings.allVendorsBillInfo,
    '',
    '${strings.shareSource}: ${strings.appName}',
    'https://play.google.com/store/apps/details?id=com.trevio.hisabdiary',
  ].join('\n');
}

String billShareMessage(MonthBill bill, AppLocalizations strings) {
  final numbers = NumberFormat.decimalPattern(strings.localeName);
  final name = bill.vendor.name.trim().replaceAll(RegExp(r'[\r\n]+'), ' ');
  final unit = vendorUnitLabel(strings, bill.vendor.unit);
  final rate = NumberFormat.currency(locale: strings.localeName,
    symbol: '\u20b9', decimalDigits: bill.rate == bill.rate.roundToDouble() ? 0 : 2)
    .format(bill.rate);
  return [
    '*${strings.bill}*',
    '${strings.shareService}: ${vendorTypeLabel(strings, bill.vendor.type)}',
    if (name.isNotEmpty) '${strings.shareVendorName}: $name',
    '${strings.shareBillingMonth}: ${DateFormat.yMMMM(strings.localeName).format(bill.month)}',
    '',
    strings.cameCount(numbers.format(bill.cameDays)),
    strings.notCameCount(numbers.format(bill.notCameDays)),
    if (bill.automaticDays > 0) strings.autoCounted(numbers.format(bill.automaticDays)),
    '',
    '${strings.shareDailyQuantity}: ${numbers.format(bill.quantity)} $unit',
    '${strings.unitRate(unit)}: $rate',
    '${strings.shareCalculation}:',
    '${numbers.format(bill.cameDays)} \u00d7 ${numbers.format(bill.quantity)} $unit \u00d7 $rate',
    '',
    '*${strings.shareTotalAmount}: ${billTotalLabel(bill, strings.localeName)}*',
    '',
    '${strings.shareSource}: ${strings.appName}',
    'https://play.google.com/store/apps/details?id=com.trevio.hisabdiary',
  ].join('\n');
}
