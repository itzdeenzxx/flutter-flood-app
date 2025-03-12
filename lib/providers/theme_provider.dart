import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('darkMode');
      
      if (isDark != null) {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
    } catch (e) {
      print('Error loading theme: $e');
      _themeMode = ThemeMode.system;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', isDark);
    } catch (e) {
      print('Error saving theme: $e');
    }
    
    notifyListeners();
  }
}