import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarControllerProvider =
    ChangeNotifierProvider((ref) => CalendarController());

class CalendarController extends ChangeNotifier {
  DateTime selectedDay;
  DateTime focusedDay;

  CalendarController()
      : selectedDay = DateTime.now(),
        focusedDay = DateTime.now();

  void onDaySelected(DateTime selectedDate, _) {
    selectedDay = selectedDate;
    focusedDay = selectedDate;
    notifyListeners();
  }
}
