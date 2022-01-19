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

  NowInfo({
    this.holidayType,
    this.monthType,
    this.timeType,
    this.tepType,
    this.price,
    required this.now,
    this.holidayNmae,
  });

  factory NowInfo.fromJson(Map<String, dynamic> json) =>
      _$NowInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NowInfoToJson(this);
}
