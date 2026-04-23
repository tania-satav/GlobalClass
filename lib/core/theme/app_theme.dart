import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      //THIS LINE MAKES ALL TEXT QUICKSAND
      fontFamily: 'Quicksand',

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0A7DAC),
      ),
    );
  }
}