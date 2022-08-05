import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, String time) async {
    tz.initializeTimeZones();
    final detroit = tz.getLocation('America/Detroit');
    //2022-06-24 08:45:58.985497-0400

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      (tz.TZDateTime.parse(detroit, "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} $time:00").difference(tz.TZDateTime.now(detroit))).isNegative ? tz.TZDateTime.parse(detroit, "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} $time:00").add(const Duration(days: 1)) : tz.TZDateTime.parse(detroit, "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} $time:00"),
      //tz.TZDateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute).add(Duration(seconds: 2)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'main_channel', 'Main Channel', 'Main channel notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@drawable/app_icon'),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
