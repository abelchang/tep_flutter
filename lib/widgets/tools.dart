import 'dart:io';

import 'package:flutter/material.dart';

class AdUnitId {
  static final String testBannerId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static final String bannerId = Platform.isAndroid
      ? 'ca-app-pub-1486315568349807/7923892362'
      : 'ca-app-pub-1486315568349807/4299314457';
}

enum HolidayType {
  nonholiday,
  holiday,
}

extension HolidayExtension on HolidayType {
  static const labels = ['非假日', '假日離峰'];
  String get label => labels[index];
}

enum MonthType {
  nonsunmer,
  sunmer,
}

extension MonthExtensin on MonthType {
  static const labels = ['非夏月', '夏月'];
  String get label => labels[index];
}

enum TimeType {
  offPeak,
  halfPeak,
  peak,
}

extension TimeTypeExtensin on TimeType {
  static const labels = ['離峰', '半尖峰', '尖峰'];
  String get label => labels[index];
}

enum TepType {
  twoWay,
  threeWay,
}

extension TepExtension on TepType {
  static const labels = ['住商兩段式', '住商三段式'];
  String get label => labels[index];
}

extension DateOnisSameDatelyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class TePrice {
  static double sumerOffPeak = 1.8;
  static double nonSumerOffPeak = 1.73;
  static double sunmer2Peak = 4.44;
  static double nonSunmer2Peak = 4.23;
  static double sunmer3Peak = 6.2;
  static double sunmer3HalfPeak = 4.07;
  static double nonsunmer3Peak = 3.88;
  static double nonsunmer3HalfPeak = 3.88;
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  bool isBetween(TimeOfDay a, TimeOfDay b) {
    num aMinute = a.hour * 60 + a.minute;
    num bMinute = b.hour * 60 + b.minute;
    num thisMinute = hour * 60 + minute;
    return ((thisMinute - aMinute).abs() + (thisMinute - bMinute).abs() ==
        (aMinute - bMinute).abs());
  }
}
