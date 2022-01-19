import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tep_flutter/models/day_info.dart';
import 'package:tep_flutter/models/now_info.dart';
import 'package:tep_flutter/services/home_service.dart';
import 'package:tep_flutter/services/sp_service.dart';
import 'package:tep_flutter/widgets/tools.dart';

class HomeProvider with ChangeNotifier {
  NowInfo _nowInfo = NowInfo(now: DateTime.now());

  List<DayInfo> _dayInfos = [];

  NowInfo get nowInfo => _nowInfo;
  List<DayInfo> get dayInfos => _dayInfos;

  void setNowInfo(NowInfo nowInfo) {
    _nowInfo = nowInfo;
    notifyListeners();
  }

  void initNowInfo(NowInfo nowInfo) {
    _nowInfo = nowInfo;
    // notifyListeners();
  }

  void setDayInfos(List<DayInfo> dayInfos) {
    _dayInfos = dayInfos;
    notifyListeners();
  }

  void setTepType(TepType tepType) {
    _nowInfo.tepType = tepType;
    SpService().setTepType(tepType);
    notifyListeners();
  }

  void updateTimer() {
    _nowInfo = HomeService().checkTime(_nowInfo);
    notifyListeners();
  }

  Future<void> updateNowInfo() async {
    _nowInfo = await HomeService().initData();
    notifyListeners();
  }
}
