import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Black & White Dark Mode Palette
const Color _pureBlack = Color(0xFF000000); // Background
const Color _darkGrey = Color(0xFF121212); // Surface
const Color _mediumGrey = Color(0xFF2D2D2D); // Surface variant
const Color _lightGrey = Color(0xFF757575); // Outline
const Color _pureWhite = Color(0xFFFFFFFF); // Primary/Text

// Neumorphic Palette
const Color _neumorphicBackground = Color(0xFF2E3239);

// Monochrome dark color scheme
final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _pureWhite,
  onPrimary: _pureBlack,
  primaryContainer: _mediumGrey,
  onPrimaryContainer: _pureWhite,
  secondary: _lightGrey,
  onSecondary: _pureBlack,
  secondaryContainer: _mediumGrey,
  onSecondaryContainer: _pureWhite,
  tertiary: _lightGrey,
  onTertiary: _pureBlack,
  tertiaryContainer: _mediumGrey,
  onTertiaryContainer: _pureWhite,
  error: const Color(0xFFCF6679),
  onError: _pureBlack,
  surface: _neumorphicBackground,
  onSurface: _pureWhite,
  surfaceContainerHighest: _mediumGrey,
  onSurfaceVariant: const Color(0xFFB0B0B0),
  outline: _lightGrey,
  outlineVariant: const Color(0xFF3D3D3D),
  shadow: Colors.black.withOpacity(0.5),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: _neumorphicBackground,

  // Typography
  textTheme: TextTheme(
    displayLarge: GoogleFonts.rajdhani(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.1,
    ),
    displayMedium: GoogleFonts.rajdhani(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.1,
    ),
    displaySmall: GoogleFonts.rajdhani(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.1,
    ),
    headlineLarge: GoogleFonts.rajdhani(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.rajdhani(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.rajdhani(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.rajdhani(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: _pureWhite,
    ),
    titleMedium: GoogleFonts.sora(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.sora(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 0.1,
    ),
    bodyLarge: GoogleFonts.sora(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.sora(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    bodySmall: GoogleFonts.sora(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),
    labelLarge: GoogleFonts.rajdhani(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 1.0,
    ),
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.rajdhani(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.5,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: _mediumGrey,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: _lightGrey.withOpacity(0.3), width: 1),
    ),
    margin: const EdgeInsets.all(8),
  ),

  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _pureWhite,
      foregroundColor: _pureBlack,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _pureWhite,
      side: const BorderSide(color: _pureWhite, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  ),

  // Input Decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _mediumGrey,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _lightGrey.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _pureWhite, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCF6679)),
    ),
    labelStyle: GoogleFonts.sora(color: Colors.white70),
    hintStyle: GoogleFonts.sora(color: Colors.white38),
  ),

  // Icon Theme
  iconTheme: const IconThemeData(color: _pureWhite, size: 24),
);
