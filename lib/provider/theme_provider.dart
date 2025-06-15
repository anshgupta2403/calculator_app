import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode') ?? 'light';
    _themeMode = _stringToThemeMode(themeString);
    notifyListeners();
  }

  void setDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.dark;
    await prefs.setString('themeMode', 'dark');
    notifyListeners();
  }

  void setLightTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.light;
    await prefs.setString('themeMode', 'light');
    notifyListeners();
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}
