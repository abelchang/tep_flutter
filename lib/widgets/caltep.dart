import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dart_date/dart_date.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tep_flutter/providers/home_provider.dart';
import 'package:tep_flutter/widgets/tools.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalTep extends StatefulWidget {
  const CalTep({Key? key}) : super(key: key);

  @override
  _CalTepState createState() => _CalTepState();
}

class _CalTepState extends State<CalTep> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  TepPriceCal tepPrice = TepPriceCal();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _summerkwhController = TextEditingController();
  final TextEditingController _nonsummerkwhController = TextEditingController();
  final TextEditingController _summerPeekController = TextEditingController();
  final TextEditingController _summerHalfPeekController =
      TextEditingController();
  final TextEditingController _summerOffPeekController =
      TextEditingController();
  final TextEditingController _nonsummerHalfPeekController =
      TextEditingController();
  final TextEditingController _nonsummerOffPeekController =
      TextEditingController();

  final FocusNode _summerkwhNode = FocusNode();
  final FocusNode _nonsummerkwhNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    initTextController();
  }

  @override
  void dispose() {
    _summerkwhController.dispose();
    _nonsummerkwhController.dispose();
    _nonsummerHalfPeekController.dispose();
    _nonsummerOffPeekController.dispose();
    _summerHalfPeekController.dispose();
    _summerOffPeekController.dispose();
    _summerPeekController.dispose();
    _summerkwhNode.dispose();
    _nonsummerkwhNode.dispose();
    super.dispose();
  }

  Future _createInterstitialAd() async {
    InterstitialAd.load(
        //TODO: chang id when release
        adUnitId: AdUnitId.interstitialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 48,
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 6,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '????????????',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(flex: 2, child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                      titleRow(1, '?????? / ?????????????????????'),
                      FractionallySizedBox(
                        widthFactor: .8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _summerkwhController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _summerkwhController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _summerkwhController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                tepPrice.summerKwh = int.parse(value);
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: '????????????????????????',
                                hintText: '????????????',
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _nonsummerkwhController,
                              textInputAction: TextInputAction.next,
                              // focusNode: _nonsummerkwhNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _nonsummerkwhController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _nonsummerkwhController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                tepPrice.nonsummerKwh = int.parse(value);
                                return null;
                              },

                              decoration: const InputDecoration(
                                labelText: '???????????????????????????',
                                hintText: '????????????',
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              '*  ????????????????????????(??????6??????9???)/????????????????????????????????????????????????????????????2???????????????????????????????????????2????????????????????? ',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      titleRow(2, '????????????????????????'),
                      FractionallySizedBox(
                        widthFactor: .8,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _summerPeekController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _summerPeekController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _summerPeekController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                if (int.parse(value) > 100) {
                                  return '???????????????100?????????';
                                }
                                tepPrice.summerPeek = int.parse(value);
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: '????????????',
                                hintText: '',
                                suffix: Text('%'),
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Icon(Icons.add),
                            ),
                            TextFormField(
                              controller: _summerHalfPeekController,
                              textInputAction: TextInputAction.next,
                              // focusNode: _summerkwhNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _summerHalfPeekController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _summerHalfPeekController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                if (_summerPeekController.text.isNotEmpty &&
                                    int.parse(_summerPeekController.text) +
                                            int.parse(_summerHalfPeekController
                                                .text) >
                                        100) {
                                  return '??????????????????????????????100??????';
                                }
                                tepPrice.summerHalfPeek = int.parse(value);
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    _summerPeekController.text.isNotEmpty) {
                                  if (int.parse(_summerPeekController.text) +
                                          int.parse(
                                              _summerHalfPeekController.text) <
                                      100) {
                                    int temp = 100 -
                                        int.parse(_summerPeekController.text) -
                                        int.parse(
                                            _summerHalfPeekController.text);
                                    _summerOffPeekController.text =
                                        temp.toString();
                                  }
                                }
                              },

                              decoration: const InputDecoration(
                                labelText: '???????????????',
                                hintText: '',
                                suffix: Text('%'),
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Icon(Icons.add),
                            ),
                            TextFormField(
                              controller: _summerOffPeekController,
                              textInputAction: TextInputAction.next,
                              // focusNode: _summerkwhNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _summerOffPeekController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _summerOffPeekController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                if (value.isNotEmpty &&
                                    _summerPeekController.text.isNotEmpty &&
                                    _summerHalfPeekController.text.isNotEmpty) {
                                  if (int.parse(_summerPeekController.text) +
                                          int.parse(
                                              _summerHalfPeekController.text) +
                                          int.parse(
                                              _summerOffPeekController.text) !=
                                      100) {
                                    return '?????????????????????????????????100??????';
                                  }
                                }
                                tepPrice.summerOffPeek = int.parse(value);
                                return null;
                              },

                              decoration: const InputDecoration(
                                labelText: '????????????',
                                hintText: '',
                                suffix: Text('%'),
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      titleRow(3, '???????????????????????????'),
                      FractionallySizedBox(
                        widthFactor: .8,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nonsummerHalfPeekController,
                              textInputAction: TextInputAction.next,
                              // focusNode: _summerkwhNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _nonsummerHalfPeekController
                                      .selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _nonsummerHalfPeekController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                if (int.parse(value) > 100) {
                                  return '????????????100??????';
                                }
                                tepPrice.nonsummerHalfPeek = int.parse(value);
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    int.parse(value) < 100) {
                                  int temp = 100 -
                                      int.parse(
                                          _nonsummerHalfPeekController.text);

                                  _nonsummerOffPeekController.text =
                                      temp.toString();
                                }
                              },

                              decoration: const InputDecoration(
                                labelText: '???????????????',
                                hintText: '',
                                suffix: Text('%'),
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Icon(Icons.add),
                            ),
                            TextFormField(
                              controller: _nonsummerOffPeekController,
                              textInputAction: TextInputAction.next,
                              // focusNode: _summerkwhNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () => _nonsummerOffPeekController
                                      .selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _nonsummerOffPeekController
                                          .value.text.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '??????????????????';
                                }
                                if (_nonsummerHalfPeekController
                                    .text.isNotEmpty) {
                                  if (int.parse(value) +
                                          int.parse(_nonsummerHalfPeekController
                                              .text) !=
                                      100) {
                                    return '????????????????????????????????????100??????';
                                  }
                                }
                                tepPrice.nonsummerOffPeek = int.parse(value);
                                return null;
                              },

                              decoration: const InputDecoration(
                                labelText: '????????????',
                                hintText: '',
                                suffix: Text('%'),
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Future.delayed(const Duration(seconds: 1), () {
                              debugPrint("Future.delayed");
                              _showInterstitialAd();
                              return;
                            });
                            _calTepPrice();
                          }
                        },
                        child: const Text('????????????'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleRow(int no, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('$no'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  void initTextController() {
    _summerHalfPeekController.text = '0';
    _summerkwhController.text = '0';
    _nonsummerkwhController.text = '0';
    _nonsummerHalfPeekController.text = '0';
    _nonsummerOffPeekController.text = '0';
    _summerHalfPeekController.text = '0';
    _summerOffPeekController.text = '0';
    _summerPeekController.text = '0';
  }

  void _calTepPrice() {
    DateTime index = DateTime(DateTime.now().year, 1, 1);
    Iterable<DateTime> listDays = index.endOfYear.eachDay(index);
    tepPrice.summerOffDay = 0;
    tepPrice.nonsummerOffDay = 0;
    tepPrice.summerPeekDay = 0;
    tepPrice.nonsummerPeekDay = 0;
    debugPrint(listDays.length.toString());
    for (var day in listDays) {
      if (day.isSaturday ||
          day.isSunday ||
          context.read<HomeProvider>().dayInfos.any((element) =>
              (element.date.isSameDate(day) && element.tep == 1))) {
        if (day.month <= 9 && day.month >= 6) {
          tepPrice.summerOffDay += 1;
        } else {
          tepPrice.nonsummerOffDay += 1;
        }
      } else {
        if (day.month <= 9 && day.month >= 6) {
          tepPrice.summerPeekDay += 1;
        } else {
          tepPrice.nonsummerPeekDay += 1;
        }
      }
    }

    tepPrice.threewayPrice = ((tepPrice.summerKwh *
                        (tepPrice.summerPeek / 100) *
                        TePrice.sunmer3Peak) +
                    (tepPrice.summerKwh *
                        (tepPrice.summerHalfPeek / 100) *
                        TePrice.sunmer3HalfPeak) +
                    (tepPrice.summerKwh *
                        (tepPrice.summerOffPeek / 100) *
                        TePrice.sumerOffPeak))
                .round() *
            4 +
        ((tepPrice.nonsummerKwh *
                        (tepPrice.nonsummerHalfPeek / 100) *
                        TePrice.nonsunmer3HalfPeak) +
                    (tepPrice.nonsummerKwh *
                        (tepPrice.nonsummerOffPeek / 100) *
                        TePrice.nonSumerOffPeak))
                .round() *
            8 +
        900;

    tepPrice.twowayPrinc = ((tepPrice.summerKwh *
                        ((tepPrice.summerPeek + tepPrice.summerHalfPeek) /
                            100) *
                        TePrice.sunmer2Peak) +
                    (tepPrice.summerKwh *
                        (tepPrice.summerOffPeek / 100) *
                        TePrice.sumerOffPeak))
                .round() *
            4 +
        ((tepPrice.nonsummerKwh *
                        (tepPrice.nonsummerHalfPeek / 100) *
                        TePrice.nonSunmer2Peak) +
                    (tepPrice.nonsummerKwh *
                        (tepPrice.nonsummerOffPeek / 100) *
                        TePrice.nonSumerOffPeak))
                .round() *
            8 +
        900;

    if (tepPrice.summerKwh > 2000) {
      tepPrice.twowayPrinc +=
          (((tepPrice.summerKwh - 2000) * 0.96).round() * 4);
      tepPrice.threewayPrice +=
          (((tepPrice.summerKwh - 2000) * 0.96).round() * 4);
    }
    if (tepPrice.nonsummerKwh > 2000) {
      tepPrice.twowayPrinc +=
          (((tepPrice.nonsummerKwh - 2000) * 0.96).round() * 8);
      tepPrice.threewayPrice +=
          (((tepPrice.nonsummerKwh - 2000) * 0.96).round() * 8);
    }
    tepPrice.normalPrice =
        calNormalPrice(tepPrice.summerKwh, tepPrice.nonsummerKwh);

    showBarModalBottomSheet(
      // expand: true,
      context: context,
      builder: (context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '??????????????????',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  DateTime.now().year.toString() + '???',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  '??????(6-9???)???????????????' + tepPrice.summerOffDay.toString() + '???',
                  style: const TextStyle(
                    // fontSize: 32.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  '????????????????????????' + tepPrice.nonsummerOffDay.toString() + '???',
                  style: const TextStyle(
                    // fontSize: 32.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.only(top: 32, bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: const Text('1'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    title: const Text('???????????????????????????(?????????)'),
                    subtitle: RichText(
                      text: TextSpan(
                        text: '????????????  ',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.color
                              ?.withOpacity(.8),
                          // fontSize: 32.0,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: NumberFormat.simpleCurrency(decimalDigits: 0)
                                .format(tepPrice.threewayPrice),
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: '  ???/??????',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: const Text('2'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    title: const Text('???????????????????????????(?????????)'),
                    subtitle: RichText(
                      text: TextSpan(
                        text: '????????????  ',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.color
                              ?.withOpacity(.8),
                          // fontSize: 32.0,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: NumberFormat.simpleCurrency(decimalDigits: 0)
                                .format(tepPrice.twowayPrinc),
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: '  ???/??????',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.only(top: 8, bottom: 32),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: const Text('3'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    title: const Text('??????????????? : ?????????'),
                    subtitle: RichText(
                      text: TextSpan(
                        text: '????????????  ',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.color
                              ?.withOpacity(.8),
                          // fontSize: 32.0,
                          fontWeight: FontWeight.w300,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: NumberFormat.simpleCurrency(decimalDigits: 0)
                                .format(tepPrice.normalPrice),
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: '  ???/??????',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text(
                  '?????????????????????????????????????????????????????????',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calNormalPrice(int summerKwh, int nonSummerKwh) {
    double normalPrice = 0;
    normalPrice = calSummerOrnot(0, summerKwh).round() * 4;
    normalPrice += calSummerOrnot(1, nonSummerKwh).round() * 8;
    return normalPrice;
  }

  double calSummerOrnot(int type, int kwh) {
    int tempKwh = kwh;
    double price = 0;

    if (kwh > 120) {
      price += 120 * NormalPrice().getUnder120Price(type);
      tempKwh = kwh - 120;
    } else {
      return tempKwh * NormalPrice().getUnder120Price(type);
    }

    if (kwh > 330) {
      price += (330 - 120) * NormalPrice().getUnder330Price(type);
      tempKwh = kwh - 330;
    } else {
      price += tempKwh * NormalPrice().getUnder330Price(type);
      return price;
    }

    if (kwh > 500) {
      price += (500 - 330) * NormalPrice().getUnder500Price(type);
      tempKwh = kwh - 500;
    } else {
      price += tempKwh * NormalPrice().getUnder500Price(type);
      return price;
    }
    if (kwh > 700) {
      price += (700 - 500) * NormalPrice().getUnder700Price(type);
      tempKwh = kwh - 700;
    } else {
      price += tempKwh * NormalPrice().getUnder700Price(type);
      return price;
    }
    if (kwh >= 1000) {
      price += (1000 - 700) * NormalPrice().getUnder1000Price(type);
      tempKwh = kwh - 1000;
    } else {
      price += tempKwh * NormalPrice().getUnder1000Price(type);
      return price;
    }
    if ((kwh - 1000) > 0) {
      price += tempKwh * NormalPrice().getUp1000Price(type);
    }

    return price;
  }
}

class TepPriceCal {
  double twowayPrinc;
  double threewayPrice;
  double normalPrice;
  int summerPeek;
  int summerOffPeek;
  int summerHalfPeek;
  int nonsummerHalfPeek;
  int nonsummerOffPeek;
  int summerOffDay;
  int summerPeekDay;
  int nonsummerOffDay;
  int nonsummerPeekDay;
  int summerKwh;
  int nonsummerKwh;
  TepPriceCal({
    this.twowayPrinc = 0,
    this.threewayPrice = 0,
    this.normalPrice = 0,
    this.summerPeek = 0,
    this.summerOffPeek = 0,
    this.summerHalfPeek = 0,
    this.nonsummerHalfPeek = 0,
    this.nonsummerOffPeek = 0,
    this.summerOffDay = 0,
    this.summerPeekDay = 0,
    this.nonsummerOffDay = 0,
    this.nonsummerPeekDay = 0,
    this.summerKwh = 0,
    this.nonsummerKwh = 0,
  });
}
