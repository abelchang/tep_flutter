import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tep_flutter/providers/theme_provider.dart';
import 'package:tep_flutter/widgets/admob.dart';
import 'package:tep_flutter/widgets/calendar.dart';
import 'package:tep_flutter/widgets/caltep.dart';
import 'package:tep_flutter/widgets/show_now_info.dart';
import 'package:provider/provider.dart';
import 'package:tep_flutter/widgets/tools.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  Timer? _timer;
  late double _progress;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  //TODO:: Admob
  Future<void> _createInterstitialAd() async {
    InterstitialAd.load(
        //TODO: chang id when release
        adUnitId: AdUnitId.testInterstitialId,
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
    _createInterstitialAd();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: Platform.isAndroid
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 32)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.date_range,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const Calendar(),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.calculate_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                _showInterstitialAd();
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CalTep(),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.info_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                _progress = 0;
                _timer?.cancel();
                _timer = Timer.periodic(const Duration(milliseconds: 200),
                    (Timer timer) {
                  EasyLoading.showProgress(_progress,
                      status:
                          '${(_progress * 100).toStringAsFixed(0)}%\n\n電價說明以台電官方公告為準\n稍後將會開啟台電電價表');
                  _progress += 0.03;
                  if (_progress >= 1) {
                    _timer?.cancel();
                    EasyLoading.dismiss();
                    launch(
                        'https://www.taipower.com.tw/upload/238/2021111716354461653.pdf',
                        forceSafariVC: false);
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                context.watch<ThemeChanger>().getTheme == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                context.read<ThemeChanger>().toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: const [
          SizedBox(
            height: 32,
          ),
          Expanded(child: ShowNowInfo()),
          SizedBox(
            height: 16,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: 50, child: GoogleBannerAd())),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
