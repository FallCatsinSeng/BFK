import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

/// Detail room screen matching Figma Frames 4 & 5 "detail room".
/// Dynamically handles available and booked states based on room.status.
/// Shows room image, title, status badge, description card with time/AC info,
/// calendar picker, location with map placeholder, and Book Now / Already Booked button.
class DetailRoomScreen extends StatefulWidget {
  final Room room;

  const DetailRoomScreen({super.key, required this.room});

  @override
  State<DetailRoomScreen> createState() => _DetailRoomScreenState();
}

class _DetailRoomScreenState extends State<DetailRoomScreen> {
  int? _selectedDay = 27; // Default selected day from Figma

  void _onBookNow() {
    if (widget.room.isAvailable) {
      Navigator.pushNamed(context, '/fix-booking', arguments: widget.room);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // White background
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

          // Main scrollable content
          SafeArea(
            child: Column(
              children: [
                // Top bar with back button and title
                _buildTopBar(),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Room image
                        _buildRoomImage(),
                        const SizedBox(height: AppSpacing.lg),
                        // Description card
                        _buildDescriptionCard(),
                        const SizedBox(height: AppSpacing.lg),
                        // Calendar section
                        _buildCalendarSection(),
                        const SizedBox(height: AppSpacing.lg),
                        // Location section
                        _buildLocationSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Book Now button
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl,
            child: PrimaryButton(
              text: widget.room.isAvailable ? 'Book Now' : 'Already Booked',
              isDisabled: !widget.room.isAvailable,
              onPressed: _onBookNow,
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
          Text(widget.room.name, style: AppTypography.titleLarge),
          const Spacer(),
          StatusBadge(status: widget.room.status),
        ],
      ),
    );
  }

  Widget _buildRoomImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Center(
          child: Icon(
            Icons.meeting_room_outlined,
            size: 64,
            color: AppColors.grey,
          ),
        ),
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
            // AC icon
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
            // Text content
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
                    style: AppTypography.bodySmall.copyWith(
                      height: 1.5,
                    ),
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
          // Map placeholder
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: AppColors.grey,
                  ),
                ),
                // See Location button overlay
                Positioned(
                  bottom: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: _buildSeeLocationButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeLocationButton() {
    return Container(
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
          const Icon(
            Icons.location_on,
            size: 16,
            color: AppColors.white,
          ),
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
    );
  }
}
