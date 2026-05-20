import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Face Verify screen matching Figma Frame 12 "Face verify".
/// Shows a camera placeholder for face verification with a back button
/// at top and a "Face Verify" action button at the bottom.
class FaceVerifyScreen extends StatelessWidget {
  const FaceVerifyScreen({super.key});

  void _onFaceVerify(BuildContext context) {
    // Navigate to OTP for final confirmation
    Navigator.pushNamed(context, '/otp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview placeholder (full screen dark background)
          Container(
            color: AppColors.black.withOpacity(0.85),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Face outline indicator
                  Container(
                    width: 220,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.face,
                          size: 80,
                          color: AppColors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Position your face\nwithin the frame',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Scanning indicator
                  SizedBox(
                    width: 160,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Scanning...',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Semi-transparent overlay on status bar area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Back button (top left)
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            left: AppSpacing.lg,
            child: CustomBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Face Verify button (bottom)
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl + MediaQuery.of(context).padding.bottom,
            child: PrimaryButton(
              text: 'Face Verify',
              onPressed: () => _onFaceVerify(context),
            ),
          ),
        ],
      ),
    );
  }
}
