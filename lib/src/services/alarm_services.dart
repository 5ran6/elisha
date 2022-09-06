import 'dart:async';
import 'dart:ui';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/noty_services/notify_service.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
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

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
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

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 20), (timer) async {
    await NotificationService().initNotification();
    // SharedPreferences pref = await SharedPreferences.getInstance();
    NotificationService().showNotification(1, "title", "body");
    // print(pref.getString('alarmTime'));
    print(PrefManager.getTime());
  });
}