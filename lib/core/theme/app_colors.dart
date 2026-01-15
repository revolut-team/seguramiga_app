import 'package:flutter/material.dart';

/// Paleta de colores principal de la aplicación de seguros
/// Diseño profesional, confiable y moderno
class AppColors {
  AppColors._();

  // Colores primarios - Azul oscuro (confianza y profesionalismo)
  static const Color primary = Color(0xFF1A365D);
  static const Color primaryLight = Color(0xFF2D4A7C);
  static const Color primaryDark = Color(0xFF0F2442);

  // Colores secundarios - Celeste (salud y bienestar)
  static const Color secondary = Color(0xFF4299E1);
  static const Color secondaryLight = Color(0xFF63B3ED);
  static const Color secondaryDark = Color(0xFF2B77CB);

  // Colores de acento
  static const Color accent = Color(0xFF38B2AC); // Verde azulado (salud)
  static const Color accentOrange = Color(0xFFED8936); // Naranja (alertas)
  static const Color accentGreen = Color(0xFF48BB78); // Verde (éxito)

  // Colores de emergencia
  static const Color emergency = Color(0xFFE53E3E);
  static const Color emergencyLight = Color(0xFFFC8181);
  static const Color emergencyDark = Color(0xFFC53030);

  // Colores neutrales
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Grises
  static const Color grey50 = Color(0xFFF7FAFC);
  static const Color grey100 = Color(0xFFEDF2F7);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E0);
  static const Color grey400 = Color(0xFFA0AEC0);
  static const Color grey500 = Color(0xFF718096);
  static const Color grey600 = Color(0xFF4A5568);
  static const Color grey700 = Color(0xFF2D3748);
  static const Color grey800 = Color(0xFF1A202C);
  static const Color grey900 = Color(0xFF171923);

  // Textos
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textTertiary = Color(0xFF718096);
  static const Color textLight = Color(0xFFFFFFFF);

  // Estados
  static const Color success = Color(0xFF48BB78);
  static const Color successLight = Color(0xFFC6F6D5);
  static const Color warning = Color(0xFFED8936);
  static const Color warningLight = Color(0xFFFEEBC8);
  static const Color error = Color(0xFFE53E3E);
  static const Color errorLight = Color(0xFFFED7D7);
  static const Color info = Color(0xFF4299E1);
  static const Color infoLight = Color(0xFFBEE3F8);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emergency, emergencyLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFF4FD1C5)],
  );
}
