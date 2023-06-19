import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import '../models/day_info.dart';
import '../models/now_info.dart';
import '../widgets/tools.dart';
import 'day_service.dart';
import 'sp_service.dart';

class HomeService {
  Future<Map<String, dynamic>> initData() async {
    Map<String, dynamic> result;
    NowInfo nowInfo = NowInfo(now: DateTime.now());
    List<DayInfo> dayInfo =
        await DayInfoService().getDayInofs(DateTime.now().year);
    nowInfo.tepType = await SpService().getTepType();

    if (nowInfo.now.month <= 9 && nowInfo.now.month >= 6) {
      nowInfo.monthType = MonthType.sunmer;
    } else {
      nowInfo.monthType = MonthType.nonsunmer;
    }
    if (nowInfo.now.isSaturday || nowInfo.now.isSunday) {
      nowInfo.holidayType = HolidayType.holiday;
      nowInfo.timeType = TimeType.offPeak;
    } else {
      nowInfo.holidayType = HolidayType.nonholiday;
    }
    for (var element in dayInfo) {
      if (element.date.isSameDate(nowInfo.now)) {
        nowInfo.holidayNmae = element.name;
        if (element.tep == 1) {
          nowInfo.holidayType = HolidayType.holiday;
          nowInfo.timeType = TimeType.offPeak;
        }
        break;
      }
    }
    if (nowInfo.holidayType == HolidayType.holiday) {
      switch (nowInfo.monthType) {
        case MonthType.sunmer:
          nowInfo.price = TePrice.sumerOffPeak;
          break;
        case MonthType.nonsunmer:
          nowInfo.price = TePrice.nonSumerOffPeak;
          break;
        default:
      }
      result = {
        'dayInfo': dayInfo,
        'nowInfo': nowInfo,
      };
      return result;
    }

    nowInfo = checkTime(nowInfo);
    result = {
      'dayInfo': dayInfo,
      'nowInfo': nowInfo,
    };
    return result;
  }

  NowInfo checkTime(NowInfo nowInfo) {
    nowInfo.now = DateTime.now();
    TimeOfDay timeNow = TimeOfDay.fromDateTime(nowInfo.now);
    if (nowInfo.tepType == TepType.twoWay) {
      switch (nowInfo.monthType) {
        case MonthType.sunmer:
          if (timeNow.isBetween(TimeofDayPeriod.summer2PeekTimeStart,
              TimeofDayPeriod.summer2PeekTimeEnd)) {
            nowInfo.timeType = TimeType.peak;
            nowInfo.price = TePrice.sunmer2Peak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer2OffPeakTimeStart;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer2OffPeakTimeEnd;
            nowInfo.nextPrice = TePrice.sumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.sumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer2PeekTimeStart;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer2PeekTimeEnd;
            nowInfo.nextPrice = TePrice.sunmer2Peak;
            nowInfo.nextTimeType = TimeType.peak;
          }
          break;
        case MonthType.nonsunmer:
          if (timeNow.isBetween(TimeofDayPeriod.nonSummer2PeekTime1Start,
              TimeofDayPeriod.nonSummer2PeekTime1End)) {
            nowInfo.timeType = TimeType.peak;
            nowInfo.price = TePrice.nonSunmer2Peak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer2OffPeekTime2Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer2OffPeekTime2End;
            nowInfo.nextPrice = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else if (timeNow.isBetween(TimeofDayPeriod.nonSummer2PeekTime2Start,
              TimeofDayPeriod.nonSummer2PeekTime2End)) {
            nowInfo.timeType = TimeType.peak;
            nowInfo.price = TePrice.nonSunmer2Peak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer2OffPeekTime1Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer2OffPeekTime1End;
            nowInfo.nextPrice = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.nonSummer2OffPeekTime1Start,
              TimeofDayPeriod.nonSummer2OffPeekTime1End)) {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer2PeekTime1Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer2PeekTime1End;
            nowInfo.nextPrice = TePrice.nonSunmer2Peak;
            nowInfo.nextTimeType = TimeType.peak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.nonSummer2OffPeekTime2Start,
              TimeofDayPeriod.nonSummer2OffPeekTime2End)) {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer2PeekTime2Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer2PeekTime2End;
            nowInfo.nextPrice = TePrice.nonSunmer2Peak;
            nowInfo.nextTimeType = TimeType.peak;
          }
          break;
        default:
          break;
      }
    } else {
      switch (nowInfo.monthType) {
        case MonthType.sunmer:
          if (timeNow.isBetween(TimeofDayPeriod.summer3PeekTimeStart,
              TimeofDayPeriod.summer3PeekTimeEnd)) {
            nowInfo.timeType = TimeType.peak;
            nowInfo.price = TePrice.sunmer3Peak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer3HalfPeekTime2Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer3HalfPeekTime2End;
            nowInfo.nextPrice = TePrice.sunmer3HalfPeak;
            nowInfo.nextTimeType = TimeType.halfPeak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.summer3HalfPeekTime1Start,
              TimeofDayPeriod.summer3HalfPeekTime1End)) {
            nowInfo.timeType = TimeType.halfPeak;
            nowInfo.price = TePrice.sunmer3HalfPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer3PeekTimeStart;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer3PeekTimeEnd;
            nowInfo.nextPrice = TePrice.sunmer3Peak;
            nowInfo.nextTimeType = TimeType.peak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.summer3HalfPeekTime2Start,
              TimeofDayPeriod.summer3HalfPeekTime2End)) {
            nowInfo.timeType = TimeType.halfPeak;
            nowInfo.price = TePrice.sunmer3HalfPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer3OffPeekTimeStart;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer3OffPeekTimeEnd;
            nowInfo.nextPrice = TePrice.sumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.sumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.summer3HalfPeekTime1Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.summer3HalfPeekTime1End;
            nowInfo.nextPrice = TePrice.sunmer3HalfPeak;
            nowInfo.nextTimeType = TimeType.halfPeak;
          }
          break;
        case MonthType.nonsunmer:
          if (timeNow.isBetween(TimeofDayPeriod.nonSummer3PeekTime1Start,
              TimeofDayPeriod.nonSummer3PeekTime1End)) {
            nowInfo.timeType = TimeType.halfPeak;
            nowInfo.price = TePrice.nonsunmer3HalfPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer3OffPeekTime2Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer3OffPeekTime2End;
            nowInfo.nextPrice = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else if (timeNow.isBetween(TimeofDayPeriod.nonSummer3PeekTime2Start,
              TimeofDayPeriod.nonSummer3PeekTime2End)) {
            nowInfo.timeType = TimeType.halfPeak;
            nowInfo.price = TePrice.nonsunmer3HalfPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer3OffPeekTime1Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer3OffPeekTime1End;
            nowInfo.nextPrice = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeType = TimeType.offPeak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.nonSummer3OffPeekTime1Start,
              TimeofDayPeriod.nonSummer3OffPeekTime1End)) {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer3PeekTime1Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer3PeekTime1End;
            nowInfo.nextPrice = TePrice.nonsunmer3HalfPeak;
            nowInfo.nextTimeType = TimeType.halfPeak;
          } else if (timeNow.isBetween(
              TimeofDayPeriod.nonSummer3OffPeekTime2Start,
              TimeofDayPeriod.nonSummer3OffPeekTime2End)) {
            nowInfo.timeType = TimeType.offPeak;
            nowInfo.price = TePrice.nonSumerOffPeak;
            nowInfo.nextTimeStart = TimeofDayPeriod.nonSummer3PeekTime2Start;
            nowInfo.nextTimeEnd = TimeofDayPeriod.nonSummer3PeekTime2End;
            nowInfo.nextPrice = TePrice.nonsunmer3HalfPeak;
            nowInfo.nextTimeType = TimeType.halfPeak;
          }
          break;
        default:
          break;
      }
    }
    return nowInfo;
  }
}
