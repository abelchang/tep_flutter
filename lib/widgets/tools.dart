import 'dart:io';

import 'package:flutter/material.dart';

class AdUnitId {
  static final String testBannerId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static final String bannerId = Platform.isAndroid
      ? 'ca-app-pub-1486315568349807/7923892362'
      : 'ca-app-pub-1486315568349807/4299314457';

  static final String testInterstitialId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static final String interstitialId = Platform.isAndroid
      ? 'ca-app-pub-1486315568349807/7212142582'
      : 'ca-app-pub-1486315568349807/8413543619';
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

class NormalPrice {
  static double uder120Summer = 1.63;
  static double under330Summer = 2.38;
  static double under500Summer = 3.52;
  static double under700Summer = 4.8;
  static double under1000Summer = 5.66;
  static double up1000Summer = 6.41;
  static double uder120NonSummer = 1.63;
  static double under330NonSummer = 2.1;
  static double under500NonSummer = 2.89;
  static double under700NonSummer = 3.94;
  static double under1000NonSummer = 4.6;
  static double up1000NonSummer = 5.03;

  double getUnder120Price(int type) {
    if (type == 0) {
      return uder120Summer;
    } else {
      return uder120NonSummer;
    }
  }

  double getUnder330Price(int type) {
    if (type == 0) {
      return under330Summer;
    } else {
      return under330NonSummer;
    }
  }

  double getUnder500Price(int type) {
    if (type == 0) {
      return under500Summer;
    } else {
      return under500NonSummer;
    }
  }

  double getUnder700Price(int type) {
    if (type == 0) {
      return under700Summer;
    } else {
      return under700NonSummer;
    }
  }

  double getUnder1000Price(int type) {
    if (type == 0) {
      return under1000Summer;
    } else {
      return under1000NonSummer;
    }
  }

  double getUp1000Price(int type) {
    if (type == 0) {
      return up1000Summer;
    } else {
      return up1000NonSummer;
    }
  }
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
