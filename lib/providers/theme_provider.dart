import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('themeMode') ?? 'system';
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDarkMode) {
      _themeMode = ThemeMode.light;
      await prefs.setString('themeMode', 'light');
    } else {
      _themeMode = ThemeMode.dark;
      await prefs.setString('themeMode', 'dark');
    }
    notifyListeners();
  }
}


