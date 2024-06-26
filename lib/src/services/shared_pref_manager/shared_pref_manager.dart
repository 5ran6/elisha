import 'package:shared_preferences/shared_preferences.dart';

class PrefManager{
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setTheme(String theme) async =>
      await _preferences?.setString("themeMode", theme);

  static String? getTheme() => _preferences!.getString("themeMode");

  static Future setTime(String time) async =>
      await _preferences?.setString("alarmTime", time);

  static String? getTime() => _preferences?.getString("alarmTime");

  static Future setFont(String fontIndex) async =>
      await _preferences?.setString("fontIndex", fontIndex);

  static String? getFont() => _preferences?.getString("fontIndex");

  static Future setDND(String time) async =>
      await _preferences?.setString("dnd", time);

  static String? getDND() => _preferences?.getString("dnd");
}