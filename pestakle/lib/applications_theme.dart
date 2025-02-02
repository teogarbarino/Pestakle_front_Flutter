// applicationTheme.dart

import 'package:flutter/material.dart';

class ApplicationTheme {
  // Définition des couleurs de l'application
  static const Color primaryColor = Color(0xFFF2BB3A); // doré
  static const Color accentColor = Color(0xFF07B4DC); // bleu vif
  static const Color secondaryColor =
      Color(0xFF94B727); // vert (pour validations par exemple)
  static const Color errorColor = Color(0xFFF23E41); // rouge
  static const Color backgroundColor = Color(0xFFFAF6EB); // fond clair
  static const Color textColor = Color(0xFF2A2A2A); // texte foncé

  static const Color primaryDark =
      Color(0xFF424242); // Couleur principale pour le thème sombre
  static const Color surfaceDark =
      Color(0xFF303030); // Couleur de surface sombre (ex: cartes, etc.)

  /// Thème clair de l'application
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white, // Texte sur fond primary
      secondary: accentColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surfaceBright: backgroundColor,
      onSurfaceVariant: textColor,
      surface: backgroundColor,
      onSurface: textColor,
    ),
  );

  /// Thème sombre de l'application
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
    // Pour le thème sombre, on définit la couleur des boutons identique à celle de l'AppBar
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900], // même couleur que l'AppBar
        foregroundColor: Colors.white,
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surfaceBright: surfaceDark,
      onSurfaceVariant: Colors.white,
      surface: Colors.grey[850]!,
      onSurface: Colors.white,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
  );
}
