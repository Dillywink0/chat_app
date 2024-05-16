import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier {
  double _fontSize = 16.0; // Doubles the font size every time the button is clicked onto the setting's page

  double get fontSize => _fontSize;

  void increaseFontSize() {
    _fontSize += 2.0; // Deals with the calculating of the doubling of the font size
    notifyListeners();
  }
}
