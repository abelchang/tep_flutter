import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class NowTimer extends StatefulWidget {
  const NowTimer({Key? key}) : super(key: key);

  @override
  State<NowTimer> createState() => _NowTimerState();
}

class _NowTimerState extends State<NowTimer> {
  Timer? timer;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => initNowInfo());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  initNowInfo() {
    if (mounted) {
      setState(() {
        now = DateTime.now();
        if ((now.minute == 0 && now.second == 0) ||
            (now.minute == 30 && now.second == 0)) {
          debugPrint('update nowInfo');
          context.read<HomeProvider>().updateNowInfo();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: '        ',
            style: TextStyle(
              color: NeumorphicTheme.defaultTextColor(context),
              fontSize: 18.0,
              fontWeight: FontWeight.w200,
            ),
            children: <TextSpan>[
              TextSpan(
                text: DateFormat('KK:mm:ss').format(now),
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                        color: Colors.black38,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2)
                  ],
                  color: NeumorphicTheme.defaultTextColor(context),
                ),
              ),
              TextSpan(
                text: '   ${DateFormat('a').format(now)}',
                style: const TextStyle(
                  letterSpacing: 0,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(now),
          style: TextStyle(
            color: NeumorphicTheme.defaultTextColor(context),
            // fontSize: 32.0,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
    // return Text(
    //   DateFormat('a KK:mm:ss').format(now),
    //   style: TextStyle(
    //     fontWeight: FontWeight.w700,
    //     fontSize: 36,
    //     shadows: const [
    //       Shadow(color: Colors.black38, offset: Offset(1.0, 1.0), blurRadius: 2)
    //     ],
    //     color: NeumorphicTheme.defaultTextColor(context),
    //   ),
    // );
  }
}
