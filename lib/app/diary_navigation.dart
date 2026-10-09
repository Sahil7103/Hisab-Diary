import 'package:flutter/material.dart';

final diaryNavigatorKey = GlobalKey<NavigatorState>();
final todayRequests = ValueNotifier<int>(0);

void openToday() {
  diaryNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  todayRequests.value++;
}
