import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Dynamic calendar grid widget matching the Figma "Month / 2026 / 04 April" component.
/// Generates calendar days dynamically for any month/year.
class CalendarGrid extends StatelessWidget {
  final int month;
  final int year;
  final int? selectedDay;
  final ValueChanged<int>? onDaySelected;

  const CalendarGrid({
    super.key,
    required this.month,
    required this.year,
    this.selectedDay,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month header
          _buildHeader(),
          const SizedBox(height: AppSpacing.md),
          // Weekday labels
          _buildWeekdayLabels(),
          const SizedBox(height: AppSpacing.sm),
          // Day grid
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final monthName = _getMonthName(month);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          monthName,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        final isWeekend = day == 'Sa' || day == 'Su';
        return SizedBox(
          width: 28,
          child: Center(
            child: Text(
              day,
              style: AppTypography.bodySmall.copyWith(
                color: isWeekend ? AppColors.calendarWeekend : AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayGrid() {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun

    // Previous month days
    final prevMonthDays = DateTime(year, month, 0).day;
    final leadingDays = firstWeekday - 1;

    final List<Widget> rows = [];
    int currentDay = 1;
    int nextMonthDay = 1;

    // Calculate total rows needed
    final totalCells = leadingDays + daysInMonth;
    final totalRows = ((totalCells + 6) ~/ 7);

    for (int row = 0; row < totalRows; row++) {
      final List<Widget> rowCells = [];

      for (int col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;

        if (cellIndex < leadingDays) {
          // Previous month
          final day = prevMonthDays - leadingDays + cellIndex + 1;
          rowCells.add(_buildDayCell(day, isCurrentMonth: false, col: col));
        } else if (currentDay <= daysInMonth) {
          // Current month
          final day = currentDay;
          final isSelected = day == selectedDay;
          rowCells.add(
            _buildDayCell(
              day,
              isCurrentMonth: true,
              isSelected: isSelected,
              col: col,
              onTap: () => onDaySelected?.call(day),
            ),
          );
          currentDay++;
        } else {
          // Next month
          rowCells.add(
              _buildDayCell(nextMonthDay, isCurrentMonth: false, col: col));
          nextMonthDay++;
        }
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowCells,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(
    int day, {
    bool isCurrentMonth = true,
    bool isSelected = false,
    int col = 0,
    VoidCallback? onTap,
  }) {
    final isWeekend = col >= 5;

    Color textColor;
    if (isSelected) {
      textColor = AppColors.white;
    } else if (!isCurrentMonth) {
      textColor = AppColors.calendarInactive;
    } else if (isWeekend) {
      textColor = AppColors.calendarWeekend;
    } else {
      textColor = AppColors.calendarActive;
    }

    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.calendarHighlight : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: AppTypography.bodyMedium.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
