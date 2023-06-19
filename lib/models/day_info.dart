// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'day_info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class DayInfo {
  DateTime date;
  String name;
  String description;
  int tep;
  DayInfo({
    required this.date,
    this.name = '',
    this.description = '',
    this.tep = 0,
  });

  factory DayInfo.fromJson(Map<String, dynamic> json) =>
      _$DayInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DayInfoToJson(this);
}
