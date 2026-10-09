import '../month/month_bill.dart';

class AllVendorsBill {
  AllVendorsBill({required this.month, required List<MonthBill> bills})
      : bills = List.unmodifiable(bills);

  final DateTime month;
  final List<MonthBill> bills;
  int get totalPaise => bills.fold(0, (sum, bill) => sum + bill.totalPaise);
  double get total => totalPaise / 100;
}
