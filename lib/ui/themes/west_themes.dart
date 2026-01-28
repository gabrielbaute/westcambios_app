import 'package:flutter/material.dart';

class WestColors {
  // Colores extraídos del CSS del cliente
  static const Color orangePrimary = Color(0xFFFF6B00);
  static const Color orangeLight = Color(0xFFFF8C42);
  static const Color orangeSoft = Color(0xFFFFBC8F);
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color whiteBone = Color(0xFFF8F9FA);
  static const Color grayDark = Color(0xFF333333);
  static const Color successGreen = Color(0xFF28A745);
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: WestColors.whiteBone,
  colorScheme: ColorScheme.light(
    primary: WestColors.orangePrimary,
    onPrimary: WestColors.whitePure,
    secondary: WestColors.orangeLight,
    surface: WestColors.whitePure,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: WestColors.orangePrimary,
    foregroundColor: WestColors.whitePure,
    elevation: 0,
  ),
  // Estilo de los inputs según el HTML
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: WestColors.whitePure,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: WestColors.orangePrimary, width: 2),
    ),
  ),
);

// Placeholder para Dark Theme (invirtiendo tonos grises)
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: WestColors.orangePrimary,
    surface: const Color(0xFF1E1E1E),
  ),
);
