import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tep_flutter/firebase_options.dart';
import 'package:tep_flutter/providers/home_provider.dart';
import 'package:tep_flutter/providers/theme_provider.dart';
import 'package:tep_flutter/screens/home.dart';
import 'package:tep_flutter/services/home_service.dart';
import 'package:tep_flutter/widgets/style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'tabs_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Map<String, dynamic>> initData() => HomeService().initData();

  @override
  void initState() {
    super.initState();
    initThemeMode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initThemeMode() async {
    await context.read<ThemeChanger>().initThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1), () {});
    ThemeMode themeMode = context.watch<ThemeChanger>().getTheme;
    const spinkit = SpinKitChasingDots(
      // color: Color(0xFF1C1C1E),
      color: blueGrey2,
    );
    return MaterialApp(
      title: '時間電價',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans'), // generic simplified Chinese 'zh_Hans'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN'), // 'zh_Hans_CN'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK'), // 'zh_Hant_HK'
      ],

      theme: FlexColorScheme.light(
        scheme: FlexScheme.rosewood,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      )
          .copyWith(
            scaffoldBackground: whiteBackground,
            background: whiteBackground,
            textTheme: const TextTheme(
              headline6: TextStyle(
                  // color: whiteSmoke,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          )
          .toTheme,
      // The Mandy red, dark theme.
      darkTheme: FlexColorScheme.dark(
        scheme: FlexScheme.rosewood,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      )
          .copyWith(
            scaffoldBackground: backGroundBlack,
            background: Colors.black,
            textTheme: const TextTheme(
              headline6: TextStyle(
                  // color: backGroundBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          )
          .toTheme,
      themeMode: themeMode,
      navigatorObservers: <NavigatorObserver>[MyApp.observer],
      builder: EasyLoading.init(),
      home: NeumorphicTheme(
        themeMode: themeMode, //or dark / system
        darkTheme: const NeumorphicThemeData(
          baseColor: backGroundBlack,
          defaultTextColor: whiteSmoke,
        ),
        theme: const NeumorphicThemeData(
          baseColor: whiteBackground,
          defaultTextColor: backGroundBlack,
        ),
        child: Scaffold(
          body: FutureBuilder(
            future: initData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return spinkit;
                default:
                  if (snapshot.hasData) {
                    context
                        .read<HomeProvider>()
                        .initNowInfo((snapshot.data! as Map)['nowInfo']);
                    context
                        .read<HomeProvider>()
                        .initDayInfo((snapshot.data! as Map)['dayInfo']);
                    // context
                    //     .read<ThemeChanger>()
                    //     .setTheme((snapshot.data! as Map)['themeMode']);
                    return Home();
                  } else if (snapshot.hasError) {
                    debugPrint('snapshot.hasError');
                    return spinkit;
                  } else {
                    debugPrint('snapshot.unKnow');
                    return spinkit;
                  }
              }
            },
          ),
        ),
      ),
      // home: MyHomePage(
      //   title: 'Firebase Analytics Demo',
      //   analytics: analytics,
      //   observer: observer,
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
        'items': [itemCreator()]
      },
    );
    setMessage('logEvent succeeded');
  }

  Future<void> _testSetUserId() async {
    await widget.analytics.setUserId(id: 'some-user');
    setMessage('setUserId succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await widget.analytics.setAnalyticsCollectionEnabled(false);
    await widget.analytics.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await widget.analytics
        .setSessionTimeoutDuration(const Duration(milliseconds: 20000));
    setMessage('setSessionTimeoutDuration succeeded');
  }

  Future<void> _testSetUserProperty() async {
    await widget.analytics.setUserProperty(name: 'regular', value: 'indeed');
    setMessage('setUserProperty succeeded');
  }

  AnalyticsEventItem itemCreator() {
    return AnalyticsEventItem(
      affiliation: 'affil',
      coupon: 'coup',
      creativeName: 'creativeName',
      creativeSlot: 'creativeSlot',
      discount: 2.22,
      index: 3,
      itemBrand: 'itemBrand',
      itemCategory: 'itemCategory',
      itemCategory2: 'itemCategory2',
      itemCategory3: 'itemCategory3',
      itemCategory4: 'itemCategory4',
      itemCategory5: 'itemCategory5',
      itemId: 'itemId',
      itemListId: 'itemListId',
      itemListName: 'itemListName',
      itemName: 'itemName',
      itemVariant: 'itemVariant',
      locationId: 'locationId',
      price: 9.99,
      currency: 'USD',
      promotionId: 'promotionId',
      promotionName: 'promotionName',
      quantity: 1,
    );
  }

  Future<void> _testAllEventTypes() async {
    await widget.analytics.logAddPaymentInfo();
    await widget.analytics.logAddToCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logAddToWishlist();
    await widget.analytics.logAppOpen();
    await widget.analytics.logBeginCheckout(
      value: 123,
      currency: 'USD',
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logCampaignDetails(
      source: 'source',
      medium: 'medium',
      campaign: 'campaign',
      term: 'term',
      content: 'content',
      aclid: 'aclid',
      cp1: 'cp1',
    );
    await widget.analytics.logEarnVirtualCurrency(
      virtualCurrencyName: 'bitcoin',
      value: 345.66,
    );

    await widget.analytics.logGenerateLead(
      currency: 'USD',
      value: 123.45,
    );
    await widget.analytics.logJoinGroup(
      groupId: 'test group id',
    );
    await widget.analytics.logLevelUp(
      level: 5,
      character: 'witch doctor',
    );
    await widget.analytics.logLogin(loginMethod: 'login');
    await widget.analytics.logPostScore(
      score: 1000000,
      level: 70,
      character: 'tiefling cleric',
    );
    await widget.analytics
        .logPurchase(currency: 'USD', transactionId: 'transaction-id');
    await widget.analytics.logSearch(
      searchTerm: 'hotel',
      numberOfNights: 2,
      numberOfRooms: 1,
      numberOfPassengers: 3,
      origin: 'test origin',
      destination: 'test destination',
      startDate: '2015-09-14',
      endDate: '2015-09-16',
      travelClass: 'test travel class',
    );
    await widget.analytics.logSelectContent(
      contentType: 'test content type',
      itemId: 'test item id',
    );
    await widget.analytics.logSelectPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
    );
    await widget.analytics.logSelectItem(
      items: [itemCreator(), itemCreator()],
      itemListName: 't-shirt',
      itemListId: '1234',
    );
    await widget.analytics.logScreenView(
      screenName: 'tabs-page',
    );
    await widget.analytics.logViewCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logShare(
      contentType: 'test content type',
      itemId: 'test item id',
      method: 'facebook',
    );
    await widget.analytics.logSignUp(
      signUpMethod: 'test sign up method',
    );
    await widget.analytics.logSpendVirtualCurrency(
      itemName: 'test item name',
      virtualCurrencyName: 'bitcoin',
      value: 34,
    );
    await widget.analytics.logViewPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
      promotionId: '1234',
      promotionName: 'big sale',
    );
    await widget.analytics.logRefund(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logTutorialBegin();
    await widget.analytics.logTutorialComplete();
    await widget.analytics.logUnlockAchievement(id: 'all Firebase API covered');
    await widget.analytics.logViewItem(
      currency: 'usd',
      value: 1000,
      items: [itemCreator()],
    );
    await widget.analytics.logViewItemList(
      itemListId: 't-shirt-4321',
      itemListName: 'green t-shirt',
      items: [itemCreator()],
    );
    await widget.analytics.logViewSearchResults(
      searchTerm: 'test search term',
    );
    setMessage('All standard events logged successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: _sendAnalyticsEvent,
            child: const Text('Test logEvent'),
          ),
          MaterialButton(
            onPressed: _testAllEventTypes,
            child: const Text('Test standard event types'),
          ),
          MaterialButton(
            onPressed: _testSetUserId,
            child: const Text('Test setUserId'),
          ),
          MaterialButton(
            onPressed: _testSetCurrentScreen,
            child: const Text('Test setCurrentScreen'),
          ),
          MaterialButton(
            onPressed: _testSetAnalyticsCollectionEnabled,
            child: const Text('Test setAnalyticsCollectionEnabled'),
          ),
          MaterialButton(
            onPressed: _testSetSessionTimeoutDuration,
            child: const Text('Test setSessionTimeoutDuration'),
          ),
          MaterialButton(
            onPressed: _testSetUserProperty,
            child: const Text('Test setUserProperty'),
          ),
          Text(
            _message,
            style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<TabsPage>(
              settings: const RouteSettings(name: TabsPage.routeName),
              builder: (BuildContext context) {
                return TabsPage(widget.observer);
              },
            ),
          );
        },
        child: const Icon(Icons.tab),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
