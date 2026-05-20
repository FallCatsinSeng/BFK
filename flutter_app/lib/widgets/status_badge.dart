import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/room.dart';

/// Status badge widget showing "available" or "Booked" state.
class StatusBadge extends StatelessWidget {
  final RoomStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isAvailable = status == RoomStatus.available;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.available.withOpacity(0.15)
            : AppColors.booked.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        isAvailable ? 'available' : 'Booked',
        style: AppTypography.bodySmall.copyWith(
          color: isAvailable ? AppColors.available : AppColors.booked,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }
}
