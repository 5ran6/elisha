import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier{
  String _theme = "";
  String get theme => _theme;

  void getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _theme = preferences.getString("themeMode")!;
  }
}