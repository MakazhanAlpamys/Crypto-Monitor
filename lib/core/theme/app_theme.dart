import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Theme Configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textTertiary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textTertiary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),
      
      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Color(0xFFF5F5F7),
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A1E),
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1A1A1E),
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1E),
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1E),
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A1E),
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B7280),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1A1A1E),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF9CA3AF),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B7280),
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF9CA3AF),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF9CA3AF),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1A1A1E),
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1E),
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF6B7280),
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF5F5F7),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A1E),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      
      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: const Color(0xFF9CA3AF),
        indicatorColor: AppColors.primary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
