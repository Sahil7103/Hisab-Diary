import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../month/month_bill.dart';
import '../vendors/vendor_type.dart';

String billTotalLabel(MonthBill bill, String locale) => NumberFormat.currency(
  locale: locale, symbol: '₹', decimalDigits: bill.totalPaise % 100 == 0 ? 0 : 2,
).format(bill.total);

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
