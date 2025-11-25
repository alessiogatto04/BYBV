// theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // O ThemeMode.light di default

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    // Alterna tra scuro e chiaro
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); 
  }
  
  // Aggiungi un getter utile per mostrare lo stato corrente nel bottone
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}