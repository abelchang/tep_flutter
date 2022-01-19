import 'package:tep_flutter/models/day_info.dart';
import 'package:tep_flutter/network_utils/api.dart';

class DayInfoService {
  Future<List<DayInfo>> getDayInofs(int thisYear) async {
    final Map<String, dynamic> holidayData = {
      'thisYear': thisYear,
    };
    var res = await Network().postData(holidayData, "/getholidays");

    return (res['holidays'] as List)
        .map((e) => DayInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
