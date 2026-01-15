import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto de la aplicación
/// Tipografías modernas y legibles
class AppTextStyles {
  AppTextStyles._();

  // Font family base
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;
  static String get _fontFamilyDisplay => GoogleFonts.poppins().fontFamily!;

  // Headings - Poppins
  static TextStyle get h1 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h4 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get h5 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get h6 => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // Body text - Inter
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // Labels
  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // Button text
  static TextStyle get buttonLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        height: 1.25,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        height: 1.25,
        letterSpacing: 0.25,
      );

  static TextStyle get buttonSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        height: 1.25,
        letterSpacing: 0.25,
      );

  // Caption
  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // Overline
  static TextStyle get overline => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        height: 1.5,
        letterSpacing: 1.5,
      );

  // Numbers (for stats, prices, etc.)
  static TextStyle get numberLarge => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        height: 1.2,
      );

  static TextStyle get numberMedium => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: 1.25,
      );

  static TextStyle get numberSmall => TextStyle(
        fontFamily: _fontFamilyDisplay,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: 1.3,
      );
}
