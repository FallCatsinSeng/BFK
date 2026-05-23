import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../providers/auth_provider.dart';

/// OTP verification screen matching Figma Frames 8, 9, 10.
/// Now integrates with AuthProvider for real OTP verification.
enum OtpState { empty, filled, success }

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpState _state = OtpState.empty;
  String _otpValue = '';
  bool _verifying = false;

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

  Future<void> _onVerify() async {
    setState(() => _verifying = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(_otpValue);

    if (success && mounted) {
      setState(() {
        _state = OtpState.success;
        _verifying = false;
      });
    } else if (mounted) {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  void _onGoBack() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _onResendOtp() async {
    final auth = context.read<AuthProvider>();
    await auth.sendOtp();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.white),
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
          const Positioned(top: 0, left: 0, right: 0, child: CustomStatusBar()),
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
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: Column(
              children: [
                Container(
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
                      Text('Verify OTP', style: AppTypography.headlineLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Enter the 6-digit code sent to ${auth.userEmail}',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      OtpInput(
                        length: 6,
                        onChanged: _onOtpChanged,
                        onCompleted: _onOtpCompleted,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _state == OtpState.filled && !_verifying ? _onVerify : null,
                          child: _verifying
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                                )
                              : const Text('Verify'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
                    ),
                    GestureDetector(
                      onTap: _onResendOtp,
                      child: Text(
                        'Resend OTP',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge, horizontal: AppSpacing.xxl),
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
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.available.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 48, color: AppColors.available),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text('Room Booked', style: AppTypography.headlineLarge),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(text: 'Go back', onPressed: _onGoBack),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
