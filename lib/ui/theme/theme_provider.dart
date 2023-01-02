import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DarkModeProvider with ChangeNotifier {
  bool isDarkTheme;

  DarkModeProvider({required this.isDarkTheme});
  toggleDarkMode() async {
    final Box settings = await Hive.openBox('settings');
    settings.put('isLightTheme', !isDarkTheme);
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
