import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom status bar widget matching the Figma "bar" component.
/// Shows time, signal, Wi-Fi, and battery indicators.
class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Time
            Text(
              '10:03',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            // Status icons
            Row(
              children: [
                // Signal
                Icon(Icons.signal_cellular_alt, size: 18, color: AppColors.black),
                const SizedBox(width: AppSpacing.xs),
                // Wi-Fi
                Icon(Icons.wifi, size: 18, color: AppColors.black),
                const SizedBox(width: AppSpacing.xs),
                // Battery
                Icon(Icons.battery_full, size: 18, color: AppColors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
