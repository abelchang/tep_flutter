import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tep_flutter/models/day_info.dart';
import 'package:tep_flutter/services/day_service.dart';
import 'package:tep_flutter/widgets/tools.dart';

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
      localStorage.setString('dayInfos', json.encode(dayInfos));
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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt("themeMode", themeMode.index);
  }

  Future<ThemeMode> getThemeMode() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var themeModeData = localStorage.getInt("themeMode");
    if (themeModeData == null) {
      return ThemeMode.system;
    }
    final themeMode = ThemeMode.values[themeModeData];
    switch (themeMode) {
      case ThemeMode.light:
        return ThemeMode.light;
      case ThemeMode.dark:
        return ThemeMode.dark;
      case ThemeMode.system:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
