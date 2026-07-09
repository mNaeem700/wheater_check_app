import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.white,
        secondary: const Color(0xFFFFD54F),
      ),
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
    );
  }
}
