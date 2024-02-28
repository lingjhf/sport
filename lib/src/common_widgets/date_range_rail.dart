import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sport/src/utils/date.dart';

class DateRangeRail extends StatefulWidget {
  const DateRangeRail({
    super.key,
    required this.dateRange,
    this.selectedDate,
    this.builder,
  });

  //日期范围
  final DateTimeRange dateRange;

  //选中日期
  final DateTime? selectedDate;

  //自定义构建日期
  final Widget Function(DateTime date)? builder;

  @override
  State<StatefulWidget> createState() => _DateRangeRailState();
}

class _DateRangeRailState extends State<DateRangeRail> {
  final ScrollController _scrollController = ScrollController();

  late List<DateTime> _dates;

  DateTime? _selectedDate;

  @override
  void initState() {
    _dates = widget.dateRange.getBetweenDates();
    _selectedDate = widget.selectedDate;
    super.initState();
  }

  Widget _buildDefaultDate(DateTime date) {
    Color? textColor;
    if (DateUtils.isSameDay(date, _selectedDate)) {
      textColor = Colors.white;
    } else if (DateUtils.isSameDay(date, DateTime.now())) {
      textColor = Colors.orange;
    }
    return DefaultTextStyle(
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('E').format(date)),
          Text(DateFormat('MM月dd日').format(date))
        ],
      ),
    );
  }

  void _onSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _dates.length,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final date = _dates[index];
        return GestureDetector(
          onTap: () => _onSelected(date),
          child: Container(
            width: 80,
            height: 56,
            decoration: BoxDecoration(
              color: DateUtils.isSameDay(date, _selectedDate)
                  ? Colors.orange
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: widget.builder?.call(date) ?? _buildDefaultDate(date),
          ),
        );
      },
    );
  }
}
