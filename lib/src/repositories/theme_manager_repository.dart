import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:flutter/material.dart';


class ThemeManagerRepository with ChangeNotifier{
  String theme;
  String get currentTheme => theme;
  ThemeManagerRepository({
    this.theme = "System"
});

  void changeTheme(newTheme) {
    PrefManager.setTheme(newTheme);
    theme = newTheme;
    notifyListeners();
  }
}