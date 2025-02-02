import 'package:flutter/material.dart';
import 'package:pestakle/applications_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  final Color seedColor = Colors.teal;

  ThemeData get currentTheme =>
      isDarkMode ? ApplicationTheme.darkTheme : ApplicationTheme.lightTheme;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData generateTheme(Color seedColor, bool isDarkMode) {
    return ThemeData(
      colorSchemeSeed: seedColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );
  }
}
