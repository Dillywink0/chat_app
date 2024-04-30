import 'package:chat_app/colours/themes.dart'; // Importing themes.dart file which contains theme data
import 'package:flutter/material.dart';

// ThemeProvider class for managing app theme
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode; // Default theme set to light mode

  // Getter for theme data
  ThemeData get themeData => _themeData;

  // Setter for theme data
  set themeData(ThemeData themeData) {
    _themeData = themeData; // Setting the new theme data
    notifyListeners(); // Notifying listeners that theme has changed
  }

  // Method to toggle between light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode; // Setting theme to dark mode if it's currently light mode
    } else {
      themeData = lightMode; // Setting theme to light mode if it's currently dark mode
    }
  }
}
