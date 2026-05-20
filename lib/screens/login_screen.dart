import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Login screen matching Figma Frame 3 "Login".
/// Features orange gradient circle background, frosted card with
/// Username/Password fields, Login button, Google sign-in, and "or" divider.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    Navigator.pushReplacementNamed(context, '/otp');
  }

  void _onGoogleLogin() {
    Navigator.pushReplacementNamed(context, '/otp');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(color: AppColors.white),

          // Orange gradient circle (background decoration)
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

          // Login card (centered)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              child: _buildLoginCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
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
          Text('Login', style: AppTypography.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Log in to access the application using your account.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Google sign-in button
          _buildGoogleButton(),
          const SizedBox(height: AppSpacing.lg),

          // "or" divider
          _buildOrDivider(),
          const SizedBox(height: AppSpacing.lg),

          // Username field
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: 'Username'),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Password field
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onLogin,
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: _onGoogleLogin,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google icon placeholder
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.g_mobiledata,
                size: 28,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Google',
              style: AppTypography.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppColors.greyLight),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.greyLight),
        ),
      ],
    );
  }
}
