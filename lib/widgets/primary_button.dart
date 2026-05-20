import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary action button matching the Figma "Booking sekarang" component.
/// Orange rounded button with text and arrow icon.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDisabled
        ? AppColors.grey
        : (backgroundColor ?? AppColors.primary);

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            // Arrow circle
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
