import 'package:dart_date/dart_date.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tep_flutter/models/now_info.dart';
import 'package:tep_flutter/providers/home_provider.dart';
import 'package:tep_flutter/services/home_service.dart';
import 'package:tep_flutter/widgets/style.dart';
import 'package:tep_flutter/widgets/tools.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ShowNowInfo extends StatefulWidget {
  const ShowNowInfo({Key? key}) : super(key: key);

  @override
  _ShowNowInfoState createState() => _ShowNowInfoState();
}

class _ShowNowInfoState extends State<ShowNowInfo> {
  Timer? timer;
  late int _tepTypeIndex;
  @override
  void initState() {
    super.initState();
    _tepTypeIndex = context.read<HomeProvider>().nowInfo.tepType?.index ?? 0;
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => initNowInfo());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  initNowInfo() {
    context.read<HomeProvider>().updateTimer();
  }

  @override
  Widget build(BuildContext context) {
    NowInfo nowInfo = context.watch<HomeProvider>().nowInfo;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 64,
        ),
        Text(
          (nowInfo.monthType as MonthType).label,
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 18,
          ),
        ),
        (nowInfo.holidayType == HolidayType.holiday)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nowInfo.holidayNmae != null
                        ? '${nowInfo.holidayNmae}: '
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    (nowInfo.holidayType as HolidayType).label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        const SizedBox(
          height: 16,
        ),
        Text(
          nowInfo.now.format('jms'),
          // DateFormat('MM/dd  kk:mm').format(nowInfo.now),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
            shadows: const [
              Shadow(
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2)
            ],
            color: NeumorphicTheme.defaultTextColor(context),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        const Flexible(child: NeumorphicClock()),
        const SizedBox(
          height: 32,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 0),
            child: NeumorphicToggle(
              width: 256,
              movingCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 220),
              height: 50,
              selectedIndex: _tepTypeIndex,
              displayForegroundOnlyIfSelected: true,
              children: [
                ToggleElement(
                  background: Center(
                      child: Text(
                    TepType.twoWay.label,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )),
                  foreground: Center(
                      child: Text(
                    TepType.twoWay.label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
                ToggleElement(
                  background: Center(
                      child: Text(
                    TepType.threeWay.label,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )),
                  foreground: Center(
                      child: Text(
                    TepType.threeWay.label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              ],
              thumb: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  surfaceIntensity: .2,
                ),
              ),
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _tepTypeIndex = value;
                    switch (_tepTypeIndex) {
                      case 0:
                        context.read<HomeProvider>().setTepType(TepType.twoWay);
                        initNowInfo();
                        break;
                      case 1:
                        context
                            .read<HomeProvider>()
                            .setTepType(TepType.threeWay);
                        initNowInfo();
                        break;
                      default:
                    }
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class NeumorphicClock extends StatelessWidget {
  const NeumorphicClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480, minWidth: 240),
      child: AspectRatio(
        aspectRatio: 1,
        child: Neumorphic(
          margin: const EdgeInsets.all(14),
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            // depth: -1,
            // intensity: .2,
          ),
          child: Neumorphic(
            style: const NeumorphicStyle(
              depth: 14,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            margin: const EdgeInsets.all(20),
            child: Neumorphic(
              style: const NeumorphicStyle(
                depth: -8,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              margin: const EdgeInsets.all(10),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((context
                                      .watch<HomeProvider>()
                                      .nowInfo
                                      .timeType as TimeType)
                                  .label),
                              RichText(
                                text: TextSpan(
                                  text: '每度  ',
                                  style: TextStyle(
                                    color: NeumorphicTheme.defaultTextColor(
                                        context),
                                    // fontSize: 32.0,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: NumberFormat.simpleCurrency(
                                              decimalDigits: 2)
                                          .format(context
                                              .watch<HomeProvider>()
                                              .nowInfo
                                              .price),
                                      style: const TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '  TWD',
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Text((context
                                      .watch<HomeProvider>()
                                      .nowInfo
                                      .tepType as TepType)
                                  .label),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: const Alignment(-0.7, -0.7),
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: const Alignment(0.7, -0.7),
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: const Alignment(-0.7, 0.7),
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: const Alignment(0.7, 0.7),
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _createDot(context),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _createDot(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDot(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        depth: -10,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: const SizedBox(
        height: 10,
        width: 10,
      ),
    );
  }
}
