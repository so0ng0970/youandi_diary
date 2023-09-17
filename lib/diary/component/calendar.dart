import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/const/color.dart';

class Calendar extends StatefulWidget {
  static String get routeName => 'calendar';
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  final OnDaySelected? onDaySelected;
  final String? diaryId;
  const Calendar(
      {this.onDaySelected,
      this.focusedDay,
      this.selectedDay,
      this.diaryId,
      super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return Dialog(
      child: Container(
        child: TableCalendar(
          // locale: 'ko_KR',
          focusedDay: widget.focusedDay ?? DateTime.now(),

          firstDay: DateTime(1800),
          lastDay: DateTime(2500),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),
          ),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            defaultDecoration: defaultBoxDeco,
            weekendDecoration: defaultBoxDeco,
            selectedDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: DIVTHR,
                width: 1.0,
              ),
            ),
            todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: FOURCOLOR,
                width: 1.0,
              ),
              shape: BoxShape.rectangle,
            ),
            todayTextStyle: const TextStyle(
              color: DIVTHR,
              fontWeight: FontWeight.bold,
            ),
            outsideDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            defaultTextStyle: defaultTextStyle,
            selectedTextStyle: defaultTextStyle.copyWith(
              color: FOURCOLOR,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
          ),
          onDaySelected: widget.onDaySelected,
          selectedDayPredicate: (DateTime date) {
            if (widget.selectedDay == null) {
              return false;
            }
            return date.year == widget.selectedDay!.year &&
                date.month == widget.selectedDay!.month &&
                date.day == widget.selectedDay!.day;
          },
        ),
      ),
    );
  }
}
