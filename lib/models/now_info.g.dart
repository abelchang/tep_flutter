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
    );

Map<String, dynamic> _$NowInfoToJson(NowInfo instance) => <String, dynamic>{
      'holidayType': _$HolidayTypeEnumMap[instance.holidayType],
      'monthType': _$MonthTypeEnumMap[instance.monthType],
      'timeType': _$TimeTypeEnumMap[instance.timeType],
      'tepType': _$TepTypeEnumMap[instance.tepType],
      'price': instance.price,
      'now': instance.now.toIso8601String(),
      'holidayNmae': instance.holidayNmae,
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
