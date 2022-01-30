import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tep_flutter/services/sp_service.dart';

class ThemeChanger with ChangeNotifier {
  final _brightness = SchedulerBinding.instance!.window.platformBrightness;
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
    debugPrint('local:' + local.toString());
    if (local == ThemeMode.system) {
      if (_brightness == Brightness.dark) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    } else {
      _themeMode = local;
    }
    debugPrint('_themeMode:' + _themeMode.toString());
    notifyListeners();
  }
}
