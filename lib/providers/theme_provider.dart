import 'package:flutter/material.dart';
import '../services/sp_service.dart';

class ThemeChanger with ChangeNotifier {
  final _brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  var _themeMode = ThemeMode.system;
  get getTheme => _themeMode;

  setTheme(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    await SpService().setThemeMode(_themeMode);
    notifyListeners();
  }

  Future<void> initThemeMode() async {
    ThemeMode local = await SpService().getThemeMode();
    debugPrint('local:$local');
    if (local == ThemeMode.system) {
      if (_brightness == Brightness.dark) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    } else {
      _themeMode = local;
    }
    debugPrint('_themeMode:$_themeMode');
    notifyListeners();
  }
}
