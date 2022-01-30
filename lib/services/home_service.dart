import 'package:flutter/material.dart';
import 'package:tep_flutter/models/day_info.dart';
import 'package:tep_flutter/models/now_info.dart';
import 'package:tep_flutter/services/sp_service.dart';
import 'package:dart_date/dart_date.dart';
import 'package:tep_flutter/widgets/tools.dart';

class HomeService {
  Future<Map<String, dynamic>> initData() async {
    Map<String, dynamic> result;
    NowInfo nowInfo = NowInfo(now: DateTime.now());
    List<DayInfo> dayInfo = await SpService().getDayInfos();
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
      if (timeNow.isBetween(const TimeOfDay(hour: 7, minute: 30),
          const TimeOfDay(hour: 22, minute: 29))) {
        nowInfo.timeType = TimeType.peak;
        if (nowInfo.monthType == MonthType.sunmer) {
          nowInfo.price = TePrice.sunmer2Peak;
        } else {
          nowInfo.price = TePrice.nonSunmer2Peak;
        }
      } else {
        nowInfo.timeType = TimeType.offPeak;
        if (nowInfo.monthType == MonthType.sunmer) {
          nowInfo.price = TePrice.sumerOffPeak;
        } else {
          nowInfo.price = TePrice.nonSumerOffPeak;
        }
      }
    } else {
      if (nowInfo.monthType == MonthType.sunmer) {
        if (timeNow.isBetween(const TimeOfDay(hour: 10, minute: 00),
                const TimeOfDay(hour: 11, minute: 59)) ||
            timeNow.isBetween(const TimeOfDay(hour: 13, minute: 00),
                const TimeOfDay(hour: 16, minute: 59))) {
          nowInfo.timeType = TimeType.peak;
          nowInfo.price = TePrice.sunmer3Peak;
        } else if (timeNow.isBetween(const TimeOfDay(hour: 7, minute: 30),
                const TimeOfDay(hour: 9, minute: 59)) ||
            timeNow.isBetween(const TimeOfDay(hour: 12, minute: 00),
                const TimeOfDay(hour: 12, minute: 59)) ||
            timeNow.isBetween(const TimeOfDay(hour: 17, minute: 00),
                const TimeOfDay(hour: 22, minute: 29))) {
          nowInfo.timeType = TimeType.halfPeak;
          nowInfo.price = TePrice.sunmer3HalfPeak;
        } else {
          nowInfo.timeType = TimeType.offPeak;
          nowInfo.price = TePrice.sumerOffPeak;
        }
      } else {
        if (timeNow.isBetween(const TimeOfDay(hour: 7, minute: 30),
            const TimeOfDay(hour: 22, minute: 29))) {
          nowInfo.timeType = TimeType.halfPeak;
          nowInfo.price = TePrice.nonsunmer3HalfPeak;
        } else {
          nowInfo.timeType = TimeType.offPeak;
          nowInfo.price = TePrice.nonSumerOffPeak;
        }
      }
    }
    return nowInfo;
  }
}
