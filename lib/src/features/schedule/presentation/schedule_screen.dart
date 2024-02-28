import 'package:flutter/material.dart';
import 'package:sport/src/common_widgets/date_range_rail.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: DateRangeRail(
            selectedDate: DateTime.now(),
            dateRange: DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now().add(const Duration(days: 7)),
            ),
          ),
        )
      ],
    );
  }
}
