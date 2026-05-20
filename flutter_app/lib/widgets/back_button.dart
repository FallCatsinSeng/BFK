import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Circular back button matching the Figma "button" component.
/// 40x40 circle with a left arrow.
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.greyLight, width: 1),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.black,
        ),
      ),
    );
  }
}
