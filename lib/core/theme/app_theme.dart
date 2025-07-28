import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = {};

  // Assuming color.r, color.g, color.b, color.a are doubles from 0 to 1
  final int r = (color.r * 255).round();
  final int g = (color.g * 255).round();
  final int b = (color.b * 255).round();
  final int a = (color.a * 255).round();

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  int argb = (a << 24) | (r << 16) | (g << 8) | b;
  return MaterialColor(argb, swatch);
}

class AppTheme {
  static final Color _primaryDark = const Color(0xFF1A1A1A);
  static final MaterialColor primaryMaterialColor = createMaterialColor(
    _primaryDark,
  );

  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color accentGold = Color(0xFFFFEB3B);

  static const Color canvasCream = Color(0xFFF8F4ED);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primarySwatch: primaryMaterialColor,
    primaryColor: _primaryDark,

    scaffoldBackgroundColor: const Color.fromARGB(255, 237, 248, 240),
    canvasColor: canvasCream,

    colorScheme: ColorScheme.light(
      primary: _primaryDark,
      secondary: accentGreen,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: accentRed,
      surface: canvasCream, // use this for background surfaces
      onSurface:
          _primaryDark, // use this for text/icons on surfaces and background
      // Remove onBackground entirely
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(color: Color(0xFF1A1A1A)),
      headlineSmall: TextStyle(color: Color(0xFF1A1A1A)),
      titleLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(color: Color(0xFF1A1A1A)),
      titleSmall: TextStyle(color: Color(0xFF1A1A1A)),
      bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
      bodyMedium: TextStyle(color: Color(0xFF1A1A1A)),
      bodySmall: TextStyle(color: Color(0xB31A1A1A)),
      labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: Color(0xFF1A1A1A)),
      labelSmall: TextStyle(color: Color(0xFF1A1A1A)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: accentGreen),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryDark,
        side: BorderSide(
          color: _primaryDark.withAlpha((0.5 * 255).round()),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _primaryDark.withAlpha((0.5 * 255).round()),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _primaryDark.withAlpha((0.3 * 255).round()),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentGreen, width: 2),
      ),
      labelStyle: TextStyle(color: _primaryDark.withAlpha((0.7 * 255).round())),
      hintStyle: TextStyle(color: _primaryDark.withAlpha((0.5 * 255).round())),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withAlpha((0.2 * 255).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8),
    ),
  );
}
