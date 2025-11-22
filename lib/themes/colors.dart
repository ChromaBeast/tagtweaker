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

// M3 Expressive Design System Colors
class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF4FD8C4);
  static const Color onPrimary = Color(0xFF003731);
  static const Color primaryContainer = Color(0xFF005048);
  static const Color onPrimaryContainer = Color(0xFF70F5DF);

  // Secondary palette
  static const Color secondary = Color(0xFFB3C5FF);
  static const Color onSecondary = Color(0xFF1E2E60);
  static const Color secondaryContainer = Color(0xFF354578);
  static const Color onSecondaryContainer = Color(0xFFDAE2FF);

  // Tertiary palette
  static const Color tertiary = Color(0xFFFFB599);
  static const Color onTertiary = Color(0xFF5C1900);
  static const Color tertiaryContainer = Color(0xFF7E2E0E);
  static const Color onTertiaryContainer = Color(0xFFFFDBCE);

  // Error palette
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Surface colors
  static const Color surface = Color(0xFF121212);
  static const Color onSurface = Color(0xFFE6E1E5);
  static const Color surfaceVariant = Color(0xFF2D2D2D);
  static const Color onSurfaceVariant = Color(0xFFCAC4D0);

  // Outline colors
  static const Color outline = Color(0xFF938F99);
  static const Color outlineVariant = Color(0xFF49454F);

  // Action colors for interactive elements
  static const Color favoriteColor = Color(0xFFEF5350);
  static const Color shareColor = Color(0xFF42A5F5);
  static const Color successColor = Color(0xFF66BB6A);
  static const Color warningColor = Color(0xFFFFCA28);
}
