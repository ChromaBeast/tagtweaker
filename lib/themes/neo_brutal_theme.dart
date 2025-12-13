import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeoBrutalColors {
  static const Color background = Color(0xFF262626);
  static const Color lime = Color(0xFFA3E635);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color mediumGrey = Color(0xFF333333);
  static const Color lightGrey = Color(0xFF4A4A4A);
  static const Color purple = Color(0xFF9333EA); // From HTML bg-purple-500
  static const Color orange = Color(0xFFF97316);
}

class NeoBrutalTheme {
  static TextStyle get heading => GoogleFonts.spaceGrotesk(
    color: NeoBrutalColors.white,
    fontWeight: FontWeight.w900,
    height: 1.0,
  );

  static TextStyle get body => GoogleFonts.spaceGrotesk(
    color: NeoBrutalColors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get mono => GoogleFonts.robotoMono(
    color: NeoBrutalColors.lime,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration brutalBox({
    Color color = NeoBrutalColors.darkGrey,
    Color borderColor = NeoBrutalColors.white,
    double borderWidth = 4.0,
    Color shadowColor = NeoBrutalColors.white,
    double shadowOffset = 4.0,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }
}
