import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/room.dart';
import 'status_badge.dart';

/// Room card widget matching the Figma home screen room list items.
/// Shows room name, time slot, availability badge, date, and action button.
class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            // Date column with vertical accent bar
            _buildDateSection(),
            const SizedBox(width: AppSpacing.md),
            // Vertical accent bar
            Container(
              width: 2,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Room info
            Expanded(child: _buildInfoSection()),
            // Arrow button
            _buildArrowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${room.date.day}',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _getMonthName(room.date.month),
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          style: AppTypography.labelMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          room.timeSlot,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        StatusBadge(status: room.status),
      ],
    );
  }

  Widget _buildArrowButton() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward,
        size: 16,
        color: AppColors.white,
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
