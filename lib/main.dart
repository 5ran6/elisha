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
import 'dart:io';
import 'dart:ui';
import 'package:elisha/src/providers/theme_manager_provider.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:provider/provider.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:intl/intl.dart';

import 'package:elisha/src/ui/views/settings_view/settings_view.dart';
import 'package:elisha/src/ui/views/splash_view/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elisha/utils/constants.dart';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:elisha/src/config/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded<Future<void>>(() async {
    await PrefManager.init();
    await Hive.initFlutter();
    await Hive.openBox('secret_place');
    if (Platform.isIOS) {
      await initializeService();
    }

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
    if (lsdv.isEmpty) {
      List<Devotional> listOfDevs =
          await RemoteAPI.getDevotionalsForMonth(formattedMYNameAPI);
      DevotionalDBHelper.instance.insertDevotionalList(listOfDevs);
    }
  }

  @override
  void initState() {
    super.initState();
    receiveData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final themeWatcher = watch(themeRepositoryProvider);
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => CantonApp(
            title: kAppTitle,
            primaryLightColor: const Color(0xFF030C5A),
            primaryLightVariantColor: const Color(0xFF030C5A),
            primaryDarkColor: const Color(0xFF0B83B3),
            primaryDarkVariantColor: const Color(0xFF0B83B3),
            lightTheme: themeWatcher.currentTheme == "Dark" ? darkSetting : lightSetting,
            darkTheme: themeWatcher.currentTheme == "Light" ? lightSetting : darkSetting,
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
            home: const SplashScreen()),
      );
    });
  }
}
