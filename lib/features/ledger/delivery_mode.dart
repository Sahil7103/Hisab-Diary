import 'dart:convert';
import '../../core/utils/date_keys.dart';

Map<String,bool> decodePurchaseModes(String? raw) {
  if (raw == null) return {};
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String,dynamic>) throw const FormatException('Invalid purchase modes');
  final result=<String,bool>{};
  for(final row in decoded.entries) {
    final day=DateTime.tryParse(row.key);
    if(day == null || day.year<1 || day.year>2100 || diaryDate(day)!=row.key ||
      !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(row.key) || row.value is! bool) {
      throw const FormatException('Invalid purchase mode date');
    }
    result[row.key]=row.value as bool;
  }
  return result;
}
bool purchasesOnlyOn(Map<String,String> settings,int id,String date) {
  final modes=decodePurchaseModes(settings['v3PurchaseModes:$id']);
  if (modes.isEmpty) return settings['v3PurchasesOnly:$id']=='true';
  var value=false;
  for(final key in modes.keys.toList()..sort()) {
    if(key.compareTo(date)>0) break;
    value=modes[key]!;
  }
  return value;
}
