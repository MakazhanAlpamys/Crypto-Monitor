import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Glassmorphism container widget
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Border? border;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.blur = 10,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient ?? AppColors.glassGradient,
            color: backgroundColor ?? AppColors.glassDark,
            border: border ??
                Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      container = Padding(padding: margin!, child: container);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

/// Gradient glass card with premium look
class GradientGlassCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GradientGlassCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      onTap: onTap,
      gradient: LinearGradient(
        colors: gradientColors ??
            [
              AppColors.surfaceLight.withOpacity(0.8),
              AppColors.cardBackground.withOpacity(0.6),
            ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}
