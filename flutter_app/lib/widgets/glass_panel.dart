import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glass panel widget matching the Figma "Rectangle 55" with glass effect.
/// Used in the "Before home" splash screen.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final double width;

  const GlassPanel({
    super.key,
    required this.child,
    this.width = 0.52,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppRadius.xl),
        bottomRight: Radius.circular(AppRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: screenWidth * width,
          decoration: BoxDecoration(
            color: AppColors.glassPanelBackground,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppRadius.xl),
              bottomRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
