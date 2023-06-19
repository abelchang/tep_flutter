import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_info.dart';
import '../network_utils/api.dart';

class DayInfoService {
  Future<List<DayInfo>> getDayInofs(int thisYear) async {
    final Map<String, dynamic> holidayData = {
      'thisYear': thisYear,
    };
    List<DayInfo> dayInfo = [];
    var res = await Network().postData(holidayData, "/getholidays");
    debugPrint('get holidays');
    if (res['success']) {
      debugPrint('get success');
      dayInfo = (res['holidays'] as List)
          .map((e) => DayInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('dayInfos', json.encode(dayInfo));
    }
    return dayInfo;
  }
}
