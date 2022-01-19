// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayInfo _$DayInfoFromJson(Map<String, dynamic> json) => DayInfo(
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tep: json['tep'] as int? ?? 0,
    );

Map<String, dynamic> _$DayInfoToJson(DayInfo instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'tep': instance.tep,
    };
