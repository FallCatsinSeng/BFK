import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../providers/booking_provider.dart';

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
  bool _isBooking = false;

  Future<void> _onVerify() async {
    setState(() => _isBooking = true);

    // Build the booking date from selected day
    final year = widget.room.date.year;
    final month = widget.room.date.month;
    final day = _selectedDay ?? widget.room.date.day;
    final date = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

    // Parse start/end time from room's timeSlot (e.g. "9:00 AM - 11:00 AM")
    final times = widget.room.timeSlot.split(' - ');
    final startTime = _to24h(times.isNotEmpty ? times[0].trim() : '09:00');
    final endTime = _to24h(times.length > 1 ? times[1].trim() : '11:00');

    final bookingProvider = context.read<BookingProvider>();
    final success = await bookingProvider.createBooking(
      roomId: widget.room.id,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );

    setState(() => _isBooking = false);

    if (success && mounted) {
      // Go to OTP success screen (shows "Room Booked")
      Navigator.pushNamed(context, '/otp');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookingProvider.error ?? 'Booking failed. Try a different time slot.')),
      );
    }
  }

  /// Convert "9:00 AM" or "11:00 AM" to "09:00" or "11:00" (24h format).
  String _to24h(String time) {
    try {
      final parts = time.replaceAll(RegExp(r'[APap][Mm]'), '').trim().split(':');
      var hour = int.parse(parts[0]);
      final min = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (time.toUpperCase().contains('PM') && hour != 12) hour += 12;
      if (time.toUpperCase().contains('AM') && hour == 12) hour = 0;
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    } catch (_) {
      return '09:00';
    }
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
              text: _isBooking ? 'Booking...' : 'Verify',
              isDisabled: _isBooking,
              onPressed: _isBooking ? null : _onVerify,
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
