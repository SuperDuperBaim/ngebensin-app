import 'package:flutter/material.dart';

class AppColors {
  // Primary Greens
  static const Color primaryDark = Color(0xFF1A2E0D);
  static const Color primaryMedium = Color(0xFF2E4420);
  static const Color primaryLight = Color(0xFF4A6335);
  static const Color olive = Color(0xFF5A7245);

  // Surfaces
  static const Color surface = Color(0xFFF5F2EB);
  static const Color cardBg = Color(0xFFFFFDF8);
  static const Color cream = Color(0xFFE8E2CC);
  static const Color creamDark = Color(0xFFDDD8C4);

  // Text
  static const Color textDark = Color(0xFF1A2E0D);
  static const Color textSub = Color(0xFF6B7A5E);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Accent
  static const Color priceGreen = Color(0xFF3D5228);

  // Input
  static const Color inputBgOnDark = Color(0x33FFFFFF);

  // Gradients
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, Color(0xFF2A3E18), Color(0xFF3D5228)],
  );
}
