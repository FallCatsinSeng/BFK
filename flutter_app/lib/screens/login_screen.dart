import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../providers/auth_provider.dart';

/// Login screen matching Figma Frame 3 "Login".
/// Now integrates with AuthProvider for real API calls.
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

  Future<void> _onLogin() async {
    final auth = context.read<AuthProvider>();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    final success = await auth.login(username, password);
    if (success && mounted) {
      // Skip OTP — go directly to home for now
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted && auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    }
  }

  void _onGoogleLogin() async {
    // Placeholder: In production, integrate Google Sign-In package
    final auth = context.read<AuthProvider>();
    await auth.login('user', 'password123');
    if (mounted) {
      // Skip OTP — go directly to home for now
      Navigator.pushReplacementNamed(context, '/home');
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
          const Positioned(
            top: 0, left: 0, right: 0,
            child: CustomStatusBar(),
          ),
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
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
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
              Text('Login', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Log in to access the application using your account.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildGoogleButton(),
              const SizedBox(height: AppSpacing.lg),
              _buildOrDivider(),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onSubmitted: (_) => _onLogin(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _onLogin,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                        )
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        );
      },
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
            const Icon(Icons.g_mobiledata, size: 28, color: AppColors.black),
            const SizedBox(width: AppSpacing.sm),
            Text('Google', style: AppTypography.labelMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.greyLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('or', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey)),
        ),
        Expanded(child: Container(height: 1, color: AppColors.greyLight)),
      ],
    );
  }
}
