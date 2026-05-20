/// Represents a single day in the calendar grid.
class CalendarDay {
  final int day;
  final int month;
  final int year;
  final bool isCurrentMonth;
  final bool isWeekend;
  final bool isSelected;
  final bool isToday;

  const CalendarDay({
    required this.day,
    required this.month,
    required this.year,
    this.isCurrentMonth = true,
    this.isWeekend = false,
    this.isSelected = false,
    this.isToday = false,
  });

  DateTime get dateTime => DateTime(year, month, day);

  String get dayOfWeekShort {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  }

  String get monthShort {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
