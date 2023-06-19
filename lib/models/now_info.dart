import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:tep_flutter/widgets/tools.dart';

part 'now_info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class NowInfo {
  HolidayType? holidayType;
  MonthType? monthType;
  TimeType? timeType;
  TepType? tepType;
  double? price;
  DateTime now;
  String? holidayNmae;
  TimeType? nextTimeType;
  double? nextPrice;
  @JsonKey(fromJson: timeofDayPeriodFormJson, toJson: timeofDayPeriodToJson)
  TimeOfDay nextTimeStart, nextTimeEnd;

  NowInfo({
    this.holidayType,
    this.monthType,
    this.timeType,
    this.tepType,
    this.price,
    required this.now,
    this.holidayNmae,
    this.nextPrice = 0,
    this.nextTimeEnd = TimeofDayPeriod.nonSummer2OffPeekTime1End,
    this.nextTimeStart = TimeofDayPeriod.nonSummer2OffPeekTime1Start,
    this.nextTimeType = TimeType.offPeak,
  });

  factory NowInfo.fromJson(Map<String, dynamic> json) =>
      _$NowInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NowInfoToJson(this);
}

TimeOfDay timeofDayPeriodFormJson(String timestamp) {
  return TimeOfDay.fromDateTime(DateTime.parse(timestamp));
}

String? timeofDayPeriodToJson(TimeOfDay timestamp) {
  return timestamp.toString();
}
