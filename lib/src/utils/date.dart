import 'package:flutter/material.dart';

extension DateRangeUtils on DateTimeRange {
  List<DateTime> getBetweenDates() {
    final dates = <DateTime>[];
    for (var date = start;
        date.isBefore(end);
        date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }
}
