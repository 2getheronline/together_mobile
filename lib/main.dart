import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/pages/EnterConfirm.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/pages/home/navigator.dart';
import 'package:together_online/pages/login/login.dart';
import 'package:together_online/pages/login/register.dart';
import 'package:together_online/pages/mission/mission.dart';
import 'package:together_online/pages/mission/webview.dart';
import 'package:together_online/pages/missions/missions.dart';
import 'package:together_online/pages/more/language.dart';
import 'package:together_online/pages/more/notifications.dart';
import 'package:together_online/pages/more/security.dart';
import 'package:together_online/pages/profile/profile.dart';
import 'package:together_online/pages/report/report.dart';
import 'package:together_online/pages/search/search_results_page.dart';
import 'package:together_online/pages/terms.dart';
import 'package:together_online/providers/AppGlobalData.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:localstorage/localstorage.dart' as ls;
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/localstorage.dart';
import 'package:together_online/providers/remoteconfig.dart';
import 'package:together_online/providers/server.dart';
import 'package:devicelocale/devicelocale.dart';
import 'dart:ui' as ui;

import 'app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await localStorage.ready;

  var token = await Auth.getToken();
  await server!.loadLanguages();

  var _binding = DataBindingBase.getInstance();
  AppGlobalData agd = AppGlobalData.getInstance();
  await agd.load();

  String? deviceLocale = await Devicelocale.currentLocale;
  String deviceLanguage = deviceLocale!.split('_')[0];
  if (deviceLanguage == "iw") {
    deviceLanguage = "he";
  }

  agd.deviceLanguage = deviceLanguage;
  var lang = await LocalStorageProvider.getLocale();
  if (lang != null) {
    agd.userLanguage = lang.language;
    _binding.selectedLanguage = lang;
  } else {
    _binding.languages.forEach((Language language) {
      if (language.language == deviceLanguage) {
        _binding.selectedLanguage = language;
        return;
      }
    });
  }

  if (token != null && token != "") {
    server!.addToken(token);
    await server!.loadUser();

    // if (agd.userLanguage == null &&
    //     _binding.session?.auth?.language !=
    //         _binding.selectedLanguage.language) {
    //   _binding.session?.auth?.language = _binding.selectedLanguage.language;
    //   await server!.editUser();
    // }

    if (_binding.session != null) {
      _binding.session!.auth?.language = _binding.selectedLanguage.language;
      await server!.editUser();
    }

  } else {
    if (agd.userLanguage == null &&
        _binding.session?.auth?.language !=
            _binding.selectedLanguage.language) {
      _binding.session?.auth?.language = _binding.selectedLanguage.language;
    }
  }
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var _binding = DataBindingBase.getInstance();
  var agd = AppGlobalData.getInstance();

  getLocale() async {
    AppLocalizations.delegate
        .load(Locale(_binding.selectedLanguage.language!))
        .then((value) {
      sleep(Duration(milliseconds: 1000));
      setState(() {});
    });
  }

  remoteConfig() async {
    try {
      // await RemoteConfigProvider.getConfigs();
    } catch (e) {
      print('Error on getting RemoteConfig $e');
    }
  }

  @override
  void initState() {
    remoteConfig();
    Server.getInstance()!.loadLanguages();

    // Get locale from device


    //WidgetsBinding.instance!.addPostFrameCallback((_) => getLocale());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    //Global();
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Remove the "Debug" banner - DE NADA
      title: 'Together Online',
      routes: {
        SearchResultsPage.routeName: (ctx) => SearchResultsPage(),
        SecurityPage.routeName: (ctx) => SecurityPage(),
        AddReport.routeName: (ctx) => AddReport(),
        UserPage.routeName: (ctx) => UserPage(),
        LanguagePage.routeName: (ctx) => LanguagePage(),
        NotificationsPage.routeName: (ctx) => NotificationsPage(),
        'login': (BuildContext context) => Login(),
        'register': (BuildContext context) => Register(),
        'missions': (BuildContext context) => Missions(),
        'mission': (BuildContext context) => Mission(),
        'home': (BuildContext context) => Home(),
        'home-navigator': (BuildContext context) => HomeNavigator(),
        'webview': (BuildContext context) => Webview(),
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ], // Returns a locale which will be used by the app
      /*localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },*/

//      supportedLocales: [
//        Locale('he'),
//        Locale('en'),
//        Locale('pt'),
//      ],
      locale: Locale('en'),
      theme: ThemeData(
        fontFamily:
            _binding.selectedLanguage.language != "he" ? 'Lato' : 'Assistant',
        primaryColor: Colors.white,
      ),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: agd.termsAgreed ? Home() : Terms(),
      //home: confirmed ? Home() : EnterConfirm(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
