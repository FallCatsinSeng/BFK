import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Full calendar screen matching Figma Frame 7 "Calendar 2026 #866".
/// Dynamically generates a full-year calendar grid (Jan–Dec 2026)
/// using the reusable CalendarGrid widget instead of hardcoding 1500+ nodes.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final int _year = 2026;
  final Map<int, int?> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(),
            const SizedBox(height: AppSpacing.md),
            // Year indicator
            _buildYearIndicator(),
            const SizedBox(height: AppSpacing.lg),
            // Scrollable calendar grid (all 12 months)
            Expanded(child: _buildCalendarGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: AppSpacing.md),
          Text('Calendar $_year', style: AppTypography.titleLarge),
        ],
      ),
    );
  }

  Widget _buildYearIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_left, color: AppColors.grey),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '$_year',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        return CalendarGrid(
          month: month,
          year: _year,
          selectedDay: _selectedDays[month],
          onDaySelected: (day) {
            setState(() {
              _selectedDays[month] = day;
            });
          },
        );
      },
    );
  }
}
