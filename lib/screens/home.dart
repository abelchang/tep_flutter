// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:tep_flutter/providers/theme_provider.dart';
import 'package:tep_flutter/widgets/admob.dart';
import 'package:tep_flutter/widgets/calendar.dart';
import 'package:tep_flutter/widgets/caltep.dart';
import 'package:tep_flutter/widgets/show_now_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  Timer? _timer;
  late double _progress;

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CalTep()));
                // showBarModalBottomSheet(
                //   expand: true,
                //   context: context,
                //   backgroundColor: Colors.transparent,
                //   builder: (context) => const CalTep(),
                // );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.info_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () async {
                _progress = 0;
                _timer?.cancel();
                _timer = Timer.periodic(const Duration(milliseconds: 100),
                    (Timer timer) {
                  EasyLoading.showProgress(_progress,
                      status:
                          '${(_progress * 100).toStringAsFixed(0)}%\n\n電價說明以台電官方公告為準\n稍後將會開啟台電電價表');
                  _progress += 0.05;
                  if (_progress >= 1) {
                    _timer?.cancel();
                    EasyLoading.dismiss();
                    if (Platform.isIOS) {
                      launch(
                          'https://www.taipower.com.tw/upload/238/2021101315451523922.pdf',
                          forceSafariVC: false);
                    } else {
                      showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SfPdfViewer.asset(
                            'assets/files/2021101315451523922.pdf',
                            scrollDirection: PdfScrollDirection.horizontal),
                      );
                    }
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
