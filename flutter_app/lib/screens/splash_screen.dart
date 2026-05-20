import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Splash/Landing screen matching Figma Frame 1 "Before home".
/// Features a glass panel with date/time, an orange gradient circle,
/// "Booking your room now" tagline, and a "Book Now" CTA button.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(color: AppColors.white),

          // Orange gradient circle (centered)
          Positioned(
            top: size.height * 0.34,
            left: size.width * 0.16,
            child: Container(
              width: size.width * 0.67,
              height: size.width * 0.67,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),

          // "Booking your room now" text (top right)
          Positioned(
            top: size.height * 0.12,
            right: AppSpacing.xxl,
            child: Text(
              'Booking your\nroom now',
              textAlign: TextAlign.right,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          // Glass panel (left side)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: _buildGlassPanel(size),
          ),

          // Status bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomStatusBar(),
          ),

          // Book Now button (bottom)
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: size.height * 0.05,
            child: PrimaryButton(
              text: 'Book Now',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel(Size size) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size.width * 0.52,
          decoration: BoxDecoration(
            color: AppColors.glassPanelBackground,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxxl,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Day name
                Text(
                  'Mon',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 60,
                  ),
                ),
                // Date
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '27',
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 60,
                          color: AppColors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'th',
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Time
                Text(
                  '11 PM',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Description
                Text(
                  'View all available\nrooms in one app',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // AI tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'AI supported',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
