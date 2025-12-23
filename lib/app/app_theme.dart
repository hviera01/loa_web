import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFFFF4D8D),
        secondary: const Color(0xFFFFC2D4),
        surface: const Color(0xFF120A1B),
        background: const Color(0xFF0B0610),
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0610),
    );
  }
}
