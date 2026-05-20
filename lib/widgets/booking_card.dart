import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/booking.dart';
import 'status_badge.dart';

/// Booking card for the "ready booked" screen.
/// Shows room image placeholder, name, status, time, and location.
class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            // Room image placeholder
            Container(
              width: 100,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.meeting_room,
                color: AppColors.grey,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.room.name,
                    style: AppTypography.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  StatusBadge(status: booking.room.status),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        booking.timeSlot,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          booking.room.location.replaceAll('\n', ', '),
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
