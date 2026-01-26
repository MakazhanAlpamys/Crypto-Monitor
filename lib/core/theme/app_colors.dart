import 'package:flutter/material.dart';

/// App Color Palette - Premium Dark Theme
class AppColors {
  // Primary Background Colors
  static const Color background = Color(0xFF0D0D0F);
  static const Color surfaceDark = Color(0xFF121214);
  static const Color surfaceLight = Color(0xFF1A1A1E);
  static const Color cardBackground = Color(0xFF16161A);
  
  // Glass Effect Colors
  static const Color glassDark = Color(0x1AFFFFFF);
  static const Color glassLight = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  
  // Accent Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7CF6);
  static const Color secondary = Color(0xFF00D9FF);
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF6C5CE7);
  static const Color gradientMiddle = Color(0xFF8B5CF6);
  static const Color gradientEnd = Color(0xFFA855F7);
  
  static const Color gradientBlueStart = Color(0xFF0EA5E9);
  static const Color gradientBlueEnd = Color(0xFF6366F1);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF4B5563);
  
  // Chart Colors
  static const Color chartGreen = Color(0xFF10B981);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartLine = Color(0xFF6C5CE7);
  static const Color chartFill = Color(0x336C5CE7);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientMiddle, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFF1E1E24),
      Color(0xFF16161A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0AFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient shimmerGradient = LinearGradient(
    colors: [
      surfaceLight.withOpacity(0.5),
      surfaceLight.withOpacity(0.8),
      surfaceLight.withOpacity(0.5),
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.5, -0.3),
    end: const Alignment(1.5, 0.3),
  );
}
