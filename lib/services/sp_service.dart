import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_info.dart';
import '../widgets/tools.dart';
import 'day_service.dart';

class SpService {
  Future<List<DayInfo>> getDayInfos() async {
    List<DayInfo> dayInfos = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var dayInfosData = localStorage.getString("dayInfos");
    if (dayInfosData != null) {
      dayInfos = (json.decode(dayInfosData) as List)
          .map((e) => DayInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (dayInfos.isEmpty || dayInfos[0].date.year != DateTime.now().year) {
      dayInfos = await DayInfoService().getDayInofs(DateTime.now().year);
    }
    return dayInfos;
  }

  Future<TepType> getTepType() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tepTypeData = localStorage.getInt("tepType");
    if (tepTypeData == null) {
      return TepType.twoWay;
    }
    final tepType = TepType.values[tepTypeData];
    switch (tepType) {
      case TepType.twoWay:
        return TepType.twoWay;
      case TepType.threeWay:
        return TepType.threeWay;
      default:
        return TepType.twoWay;
    }
  }

  Future<void> setTepType(TepType tepType) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt("tepType", tepType.index);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    debugPrint('in setThemeMode');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt("themeMode", themeMode.index);
  }

  Future<ThemeMode> getThemeMode() async {
    debugPrint('in getThemeMode');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var themeModeData = localStorage.getInt("themeMode");
    debugPrint('sp getThemeMode:$themeModeData');
    if (themeModeData == null) {
      return ThemeMode.system;
    }
    final themeMode = ThemeMode.values[themeModeData];
    debugPrint('convert getThemeMode:$themeMode');
    switch (themeMode) {
      case ThemeMode.light:
        debugPrint('switch ThemeMode.light');
        return ThemeMode.light;
      case ThemeMode.dark:
        debugPrint('switch ThemeMode.dark');
        return ThemeMode.dark;
      case ThemeMode.system:
        debugPrint('switch ThemeMode.system');
        return ThemeMode.system;
      default:
        debugPrint('switch default ThemeMode.system');
        return ThemeMode.system;
    }
  }
}
