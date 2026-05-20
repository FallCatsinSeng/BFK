import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/mock_data.dart';

/// OTP verification screen matching Figma Frames 8, 9, 10.
/// Handles three states: empty input, filled input, and success confirmation.
enum OtpState { empty, filled, success }

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpState _state = OtpState.empty;
  String _otpValue = '';

  void _onOtpChanged(String value) {
    setState(() {
      _otpValue = value;
      _state = value.length == 6 ? OtpState.filled : OtpState.empty;
    });
  }

  void _onOtpCompleted(String value) {
    setState(() {
      _otpValue = value;
      _state = OtpState.filled;
    });
  }

  void _onVerify() {
    // Simulate verification success
    setState(() => _state = OtpState.success);
  }

  void _onGoBack() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(color: AppColors.white),

          // Orange gradient circle (background)
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

          // Status bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomStatusBar(),
          ),

          // Content
          SafeArea(
            child: _state == OtpState.success
                ? _buildSuccessContent()
                : _buildOtpContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Verify OTP', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the 6-digit code sent to ${MockData.currentUser.email}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // OTP input boxes
              OtpInput(
                length: 6,
                onChanged: _onOtpChanged,
                onCompleted: _onOtpCompleted,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _state == OtpState.filled ? _onVerify : null,
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Spacer(),
        // Success card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.huge,
              horizontal: AppSpacing.xxl,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.available.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 48,
                    color: AppColors.available,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Room Booked',
                  style: AppTypography.headlineLarge,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Go back button
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            text: 'Go back',
            onPressed: _onGoBack,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Resend OTP footer widget used below the OTP card.
class _ResendFooter extends StatelessWidget {
  final VoidCallback? onResend;

  const _ResendFooter({this.onResend});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
        ),
        GestureDetector(
          onTap: onResend,
          child: Text(
            'Resend OTP',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
