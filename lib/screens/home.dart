import 'dart:async';
import 'dart:io';

import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tep_flutter/main.dart';
import 'package:tep_flutter/providers/theme_provider.dart';
import 'package:tep_flutter/services/home_service.dart';
import 'package:tep_flutter/widgets/show_now_info.dart';
import 'package:tep_flutter/widgets/style.dart';
import 'package:tep_flutter/widgets/tools.dart';
import 'package:provider/provider.dart';
import 'package:tep_flutter/models/now_info.dart';
import 'package:tep_flutter/providers/home_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TODO::Google Admod
  static const _insets = 12.0;
  BannerAd? _inlineAdaptiveAd;
  AdSize? _adSize;
  late Orientation _currentOrientation;
  bool _isLoaded = false;
  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);
  final GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //TODO::Admob
    _loadAd();
  }

  @override
  void didChangeDependencies() {
    _currentOrientation = MediaQuery.of(context).orientation;
    context.read<HomeProvider>().updateNowInfo();
    //TODO::Admob
    _loadAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _inlineAdaptiveAd?.dispose();
    super.dispose();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });
    // Get an inline adaptive size for the current orientation.
    // AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
    //     _adWidth.truncate());

    AdSize size = AdSize.banner;

    _inlineAdaptiveAd = BannerAd(
      //TODO: chang id when release
      adUnitId: AdUnitId.testBannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          // debugPrint('Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            debugPrint(
                'Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // debugPrint('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  //TODO::Admob
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAdaptiveAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
              child: SizedBox(
            width: _adWidth,
            height: _adSize!.height.toDouble(),
            child: AdWidget(
              ad: _inlineAdaptiveAd!,
            ),
          ));
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: Platform.isAndroid
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 32)
            : const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                showBarModalBottomSheet(
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (context) => SizedBox.fromSize(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                            '${DateTime.now().year}電價日曆',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: Text(
                            '電價說明',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: Text(
                            '電價試算',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
            _isLoaded
                ? TextButton(
                    child: Icon(
                      context.watch<ThemeChanger>().getTheme == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      context.read<ThemeChanger>().toggleTheme();
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      drawer: Material(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView(
                shrinkWrap: true,
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: Text(
                      '${DateTime.now().year}電價日曆',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      '電價說明',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      '電價試算',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  const Divider(),

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     // style: ElevatedButton.styleFrom(
                  //     //   // primary: Color(0xFF1877F2),
                  //     //   shape: RoundedRectangleBorder(
                  //     //       borderRadius: BorderRadius.all(Radius.circular(10))),
                  //     // ),
                  //     child: const Text('Logout'),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const Expanded(child: ShowNowInfo()),
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: 50, child: _getAdWidget())),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
