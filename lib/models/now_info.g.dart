// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NowInfo _$NowInfoFromJson(Map<String, dynamic> json) => NowInfo(
      holidayType:
          $enumDecodeNullable(_$HolidayTypeEnumMap, json['holidayType']),
      monthType: $enumDecodeNullable(_$MonthTypeEnumMap, json['monthType']),
      timeType: $enumDecodeNullable(_$TimeTypeEnumMap, json['timeType']),
      tepType: $enumDecodeNullable(_$TepTypeEnumMap, json['tepType']),
      price: (json['price'] as num?)?.toDouble(),
      now: DateTime.parse(json['now'] as String),
      holidayNmae: json['holidayNmae'] as String?,
      nextPrice: (json['nextPrice'] as num?)?.toDouble(),
      nextTimeEnd: json['nextTimeEnd'] == null
          ? TimeofDayPeriod.nonSummer2OffPeekTime1End
          : timeofDayPeriodFormJson(json['nextTimeEnd'] as String),
      nextTimeStart: json['nextTimeStart'] == null
          ? TimeofDayPeriod.nonSummer2OffPeekTime1Start
          : timeofDayPeriodFormJson(json['nextTimeStart'] as String),
      nextTimeType:
          $enumDecodeNullable(_$TimeTypeEnumMap, json['nextTimeType']),
    );

Map<String, dynamic> _$NowInfoToJson(NowInfo instance) => <String, dynamic>{
      'holidayType': _$HolidayTypeEnumMap[instance.holidayType],
      'monthType': _$MonthTypeEnumMap[instance.monthType],
      'timeType': _$TimeTypeEnumMap[instance.timeType],
      'tepType': _$TepTypeEnumMap[instance.tepType],
      'price': instance.price,
      'now': instance.now.toIso8601String(),
      'holidayNmae': instance.holidayNmae,
      'nextTimeType': _$TimeTypeEnumMap[instance.nextTimeType],
      'nextPrice': instance.nextPrice,
      'nextTimeStart': timeofDayPeriodToJson(instance.nextTimeStart),
      'nextTimeEnd': timeofDayPeriodToJson(instance.nextTimeEnd),
    };

const _$HolidayTypeEnumMap = {
  HolidayType.nonholiday: 'nonholiday',
  HolidayType.holiday: 'holiday',
};

const _$MonthTypeEnumMap = {
  MonthType.nonsunmer: 'nonsunmer',
  MonthType.sunmer: 'sunmer',
};

const _$TimeTypeEnumMap = {
  TimeType.offPeak: 'offPeak',
  TimeType.halfPeak: 'halfPeak',
  TimeType.peak: 'peak',
};

const _$TepTypeEnumMap = {
  TepType.twoWay: 'twoWay',
  TepType.threeWay: 'threeWay',
};
