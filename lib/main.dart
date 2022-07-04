/*
Elisha iOS & Android App
Copyright (C) 2021 Elisha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:intl/intl.dart';

import 'package:dio/dio.dart';
import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/verse.dart';
import 'package:elisha/src/ui/views/about_us_view/about_us_page.dart';
import 'package:elisha/src/ui/views/bibestudy_series_view/biblestudy_series_view.dart';
import 'package:elisha/src/ui/views/account_view/account_view.dart';
import 'package:elisha/src/ui/views/bible_view/bible_view.dart';
import 'package:elisha/src/ui/views/bookmarked_chapter_view/bookmarked_chapter_view.dart';
import 'package:elisha/src/ui/views/bookmarked_chapters_view/bookmarked_chapters_view.dart';
import 'package:elisha/src/ui/views/current_view.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page.dart';
import 'package:elisha/src/ui/views/home_view/components/study_plans_listview.dart';
import 'package:elisha/src/ui/views/home_view/home_view.dart';
import 'package:elisha/src/ui/views/list_of_notes_view/list_of_notes_view.dart';
import 'package:elisha/src/ui/views/note_view/note_view.dart';
import 'package:elisha/src/ui/views/opened_studyplan_view/opened_studyplan_view.dart';
import 'package:elisha/src/ui/views/profile_view/profile_view.dart';
import 'package:elisha/src/ui/views/settings_view/settings_view.dart';
import 'package:elisha/src/ui/views/splash_view/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:elisha/src/config/constants.dart';
import 'package:elisha/src/services/noty_services/notify_service.dart';
import 'package:elisha/src/services/authentication_services/authentication_wrapper.dart';
import 'dart:convert';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? hello = preferences.getInt("alarmHour");
    NotificationService().showNotification(1, "Secret place", "Hey, you scheduled a time with Jesus now ${hello}");

    // if (service is AndroidServiceInstance) {
    //   service.setForegroundNotificationInfo(
    //     title: "My App Service",
    //     content: "Updated at ${DateTime.now()}",
    //   );
    // }
  });
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().initNotification();
    await initializeService();
    await MobileAds.instance.initialize();
    await Firebase.initializeApp();
    await Hive.initFlutter();
    await Hive.openBox('elisha');

    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    /// Lock screen orientation to vertical
    await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        .then((_) {
      runApp(const ProviderScope(child: MyApp()));
    });
  }, (error, stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void receiveData() async {
    DateTime now = DateTime.now();

    String formattedMYNameAPI = DateFormat('MMMMyyyy').format(now);
    String formattedMYNameDB = DateFormat('MM.yyyy').format(now);

    List<Devotional> lsdv = await DevotionalDBHelper.instance
        .getDevotionalsDBForMonth(formattedMYNameDB);
    print(lsdv);
    if (lsdv.isEmpty) {
      List<Devotional> listOfDevs =
          await RemoteAPI.getDevotionalsForMonth(formattedMYNameAPI);
      DevotionalDBHelper.instance.insertDevotionalList(listOfDevs);
    }
  }

  @override
  Widget build(BuildContext context) {
    receiveData();

    Map setTheme(theme) {
      var light = cantonLightTheme().copyWith(
          primaryColor: const Color(0xFFB97D3C),
          colorScheme: cantonLightTheme()
              .colorScheme
              .copyWith(primaryVariant: const Color(0xFFB97D3C)));
      var dark = cantonLightTheme().copyWith(
          primaryColor: const Color(0xFFB97D3C),
          colorScheme: cantonLightTheme()
              .colorScheme
              .copyWith(primaryVariant: const Color(0xFFB97D3C)));
      print(theme);
      if (theme == "Light") {
        return {'light': light, 'dark': light};
      } else if (theme == "Dark") {
        return {'light': dark, 'dark': dark};
      } else {
        return {'light': light, 'dark': dark};
      }
    }

    // return ScreenUtilInit(
    //   designSize: Size(360, 690),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   builder: () => MaterialApp(
    //     //... other code
    //     builder: (context, widget) {
    //       //add this line
    //       ScreenUtil.setContext(context);
    //       return MediaQuery(
    //         //Setting font does not change with system font size
    //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    //         child: widget!,
    //       );
    //     },
    //     theme: ThemeData(
    //       textTheme: TextTheme(
    //           //To support the following, you need to use the first initialization method
    //           button: TextStyle(fontSize: 45.sp)),
    //     ),
    //   ),
    // );

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => CantonApp(
          title: kAppTitle,
          primaryLightColor: const Color(0xFFB97D3C),
          primaryLightVariantColor: const Color(0xFFB97D3C),
          primaryDarkColor: const Color(0xFFB97D3C),
          primaryDarkVariantColor: const Color(0xFFB97D3C),
          lightTheme: setTheme("Dark")['light'],
          darkTheme: setTheme("Dark")['dark'],
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          ],
          home: SettingsPage()),
    );
  }
}
