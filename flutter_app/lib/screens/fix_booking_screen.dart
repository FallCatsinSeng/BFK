import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

/// Fix Booking screen matching Figma Frame 6 "Fix booking".
/// Shows room details confirmation with description, calendar,
/// location, countdown timer widget, and Verify button.
class FixBookingScreen extends StatefulWidget {
  final Room room;

  const FixBookingScreen({super.key, required this.room});

  @override
  State<FixBookingScreen> createState() => _FixBookingScreenState();
}

class _FixBookingScreenState extends State<FixBookingScreen> {
  int? _selectedDay = 27;

  void _onVerify() {
    // Skip face verify — go directly to OTP success (booking confirmed)
    Navigator.pushNamed(context, '/otp');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.white),

          // Decorative ellipses
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 169,
              height: 169,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            left: -60,
            child: Container(
              width: 242,
              height: 247,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.08),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        // Description card
                        _buildDescriptionCard(),
                        const SizedBox(height: AppSpacing.lg),
                        // Calendar
                        _buildCalendarSection(),
                        const SizedBox(height: AppSpacing.lg),
                        // Location
                        _buildLocationSection(),
                        const SizedBox(height: AppSpacing.lg),
                        // Timer widget
                        _buildTimerWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Verify button
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl,
            child: PrimaryButton(
              text: 'Verify',
              onPressed: _onVerify,
            ),
          ),
        ],
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
          Text('Fix Booking', style: AppTypography.titleLarge),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.ac_unit,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.timeSlot,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.room.description,
                    style: AppTypography.bodySmall.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: CalendarGrid(
        month: widget.room.date.month,
        year: widget.room.date.year,
        selectedDay: _selectedDay,
        onDaySelected: (day) {
          setState(() => _selectedDay = day);
        },
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.room.location,
            style: AppTypography.bodySmall.copyWith(height: 1.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.map_outlined, size: 48, color: AppColors.grey),
                ),
                Positioned(
                  bottom: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.white),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'See Location',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          children: [
            Text(
              'Booking Timer',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Timer display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimerSegment('05', 'Min'),
                _buildTimerSeparator(),
                _buildTimerSegment('00', 'Sec'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.75,
                backgroundColor: AppColors.greyLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSegment(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Text(
            value,
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildTimerSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        ':',
        style: AppTypography.headlineLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
