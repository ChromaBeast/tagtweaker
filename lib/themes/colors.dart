import 'package:flutter/material.dart';

// Rating colors for product ratings (1-5 stars)
List<Color> ratingColors = [
  const Color(0xFFEF5350), // 0-1: Red
  const Color(0xFFFF7043), // 1-2: Deep Orange
  const Color(0xFFFFCA28), // 2-3: Amber
  const Color(0xFFFFEE58), // 3-4: Yellow
  const Color(0xFF66BB6A), // 4-5: Green
  const Color(0xFF4CAF50), // 5: Darker Green
];

// Monochrome Design System Colors
class AppColors {
  // Primary palette - Monochrome
  static const Color primary = Color(0xFFFFFFFF); // White
  static const Color onPrimary = Color(0xFF000000); // Black
  static const Color primaryContainer = Color(0xFF2D2D2D); // Medium Grey
  static const Color onPrimaryContainer = Color(0xFFFFFFFF); // White

  // Secondary palette - Greys
  static const Color secondary = Color(0xFF757575); // Light Grey
  static const Color onSecondary = Color(0xFF000000); // Black
  static const Color secondaryContainer = Color(0xFF2D2D2D); // Medium Grey
  static const Color onSecondaryContainer = Color(0xFFFFFFFF); // White

  // Tertiary palette - Greys
  static const Color tertiary = Color(0xFF757575); // Light Grey
  static const Color onTertiary = Color(0xFF000000); // Black
  static const Color tertiaryContainer = Color(0xFF2D2D2D); // Medium Grey
  static const Color onTertiaryContainer = Color(0xFFFFFFFF); // White

  // Error palette
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Surface colors
  static const Color surface = Color(0xFF121212); // Dark Grey
  static const Color onSurface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFF2D2D2D); // Medium Grey
  static const Color onSurfaceVariant = Color(0xFFB0B0B0); // Light Grey

  // Outline colors
  static const Color outline = Color(0xFF757575); // Light Grey
  static const Color outlineVariant = Color(0xFF3D3D3D); // Dark Grey

  // Action colors for interactive elements - Monochrome
  static const Color favoriteColor = Color(0xFFFFFFFF); // White
  static const Color shareColor = Color(0xFFFFFFFF); // White
  static const Color successColor = Color(0xFFB0B0B0); // Light Grey
  static const Color warningColor = Color(0xFF757575); // Light Grey

  // Neumorphism Palette
  static const Color neumorphicBackground = Color(0xFF2E3239);
  static const Color neumorphicLightShadow = Color(0xFF353941);
  static const Color neumorphicDarkShadow = Color(0xFF23262B);
}
