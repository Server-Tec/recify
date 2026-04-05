import 'package:flutter/material.dart';

class QuantumDesign {
  static const Color primary = Color(0xFF00FFB2);
  static const Color bg = Color(0xFF020202);
  static const Color cardBg = Color(0xFF0A0A0A);

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: bg,
    cardColor: cardBg,
    colorScheme: ThemeData.dark().colorScheme.copyWith(primary: primary),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardBg,
      selectedItemColor: primary,
      unselectedItemColor: Colors.white70,
    ),
  );

  static BoxDecoration glassNode = BoxDecoration(
    color: Colors.white.withOpacity(0.05),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white10),
  );

  static BoxDecoration glowEffect = BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.15),
        blurRadius: 100,
        spreadRadius: 20,
      ),
    ],
  );
}
