import 'package:flutter/material.dart';

class ThemeSettings extends ChangeNotifier {
  bool _isDark = false;
  int _page = 100;
  int _accentColor = 0xFF0000FF;
  String _country = "in";

  bool get isDark => _isDark;
  int get page => _page;
  int get accentColor => _accentColor;
  String get country => _country;

  void setDark(bool dark) {
    _isDark = dark;
    notifyListeners();
  }

  void setPage(int page) {
    _page = page;
    notifyListeners();
  }

  void setAccentColor(int color) {
    _accentColor = color;
    notifyListeners();
  }

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }
}
