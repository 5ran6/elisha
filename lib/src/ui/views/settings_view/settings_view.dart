import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/main.dart';
import 'package:elisha/src/ui/views/settings_view/settings_header_view.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:provider/provider.dart';
import 'package:elisha/src/providers/theme_manager_provider.dart';

import '../../../services/noty_services/notify_service.dart';

//TODO: call the "set state of the provider" function for String? theme in the main from void submit
//getPref gets Shared pref data for the UI
//Alarm manager is called in void showDialogPicker

String? time;

void runAlarm() async {
  await NotificationService().initNotification();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  time = preferences.getString("alarmTime");
  NotificationService().showNotification(1, "Secret place", "Hey, you scheduled a time with Jesus");
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List themeList = ["System", "Light", "Dark"];
  late Future<TimeOfDay?> selectedTime;
  bool reminderValue = true;
  int radioValue = 0;
  late String themeVal = ""; //for UI use to update the theme card subtext
  late String tme = ""; //for UI use to update the alarm card subtext

  bool isDoNotDisturbFunctionOn = false;
  bool isDNDPolicyAccessGranted = false;

  void saveDoNotDisturbStatusToSharedPref() async {
    final _prefs = await SharedPreferences.getInstance();

    await _prefs.setBool('sharedPrefStatus', isDoNotDisturbFunctionOn);
  }

  void checkAndSetDNDInitState() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? storedDNDInitState = sharedPrefs.getString('dndInit');
    if (storedDNDInitState == 'off') {
      setState(() {
        isDoNotDisturbFunctionOn = false;
      });
    } else if (storedDNDInitState == 'on') {
      setState(() {
        isDoNotDisturbFunctionOn = true;
      });
    }
  }

  void getPrefData() async {
    await SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey("themeMode") == false) {
        preferences.setString("themeMode", "System");
      }
      themeVal = preferences.getString("themeMode")!;
      if (preferences.containsKey("alarmTime") == false) {
        tme = "Off";
        reminderValue = false;
      } else {
        tme = preferences.getString("alarmTime")!.split(" ")[1].substring(0, 5);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefData();
    checkAndSetDNDInitState();
  }

  @override
  Widget build(BuildContext context) {
    getPrefData();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: SettingsHeaderView(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      openDialog();
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Theme', style: Theme.of(context).textTheme.headline6),
                            Text(themeVal, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogPicker(context);
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Daily Remainder', style: Theme.of(context).textTheme.headline6),
                                Text(tme, style: TextStyle(color: reminderValue ? Colors.grey[600] : Colors.grey[800]))
                              ],
                            ),
                            Transform.scale(
                              scale: 1.2,
                              child: Switch.adaptive(
                                  activeColor: Theme.of(context).primaryColor,
                                  activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.4),
                                  inactiveThumbColor: Colors.blueGrey,
                                  inactiveTrackColor: Colors.blueGrey,
                                  splashRadius: 50,
                                  value: reminderValue,
                                  onChanged: (value) {
                                    setState(() {
                                      reminderValue = value;
                                      if (reminderValue == false) {
                                        AndroidAlarmManager.cancel(1);
                                      } else {
                                        AndroidAlarmManager.periodic(const Duration(hours: 1), 1, runAlarm,
                                            allowWhileIdle: true,
                                            rescheduleOnReboot: true,
                                            exact: true,
                                            wakeup: true,
                                            startAt: DateTime.tryParse(time!));
                                      }
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      var isNotificationPolicyAccessGranted = (await FlutterDnd.isNotificationPolicyAccessGranted);
                      if ((isNotificationPolicyAccessGranted) != null && isNotificationPolicyAccessGranted) {
                        setState(() {
                          isDNDPolicyAccessGranted = true;
                        });
                        if (isDoNotDisturbFunctionOn == true) {
                          await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('dndInit', 'off');

                          setState(() {
                            isDoNotDisturbFunctionOn = false;
                          });
                          saveDoNotDisturbStatusToSharedPref();
                        } else {
                          await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('dndInit', 'on');

                          setState(() {
                            isDoNotDisturbFunctionOn = true;
                          });
                          saveDoNotDisturbStatusToSharedPref();
                        }
                      } else {
                        FlutterDnd.gotoPolicySettings();
                        setState(() {
                          isDNDPolicyAccessGranted = false;
                        });
                      }
                    },
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.centerLeft,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Do not disturb(Tap me)', style: Theme.of(context).textTheme.headline6),
                                Text(isDoNotDisturbFunctionOn ? "On" : "Off", style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                            Transform.scale(
                              scale: 1.2,
                              child: Switch.adaptive(
                                  activeColor: Theme.of(context).primaryColor,
                                  activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.4),
                                  inactiveThumbColor: Colors.blueGrey,
                                  inactiveTrackColor: Colors.blueGrey,
                                  splashRadius: 50,
                                  value: isDoNotDisturbFunctionOn,
                                  onChanged: isDNDPolicyAccessGranted == false
                                      ? null
                                      : (value) {
                                          setState(() {
                                            isDoNotDisturbFunctionOn = value;
                                          });
                                          if (value == true) {
                                            setDNDon();
                                          } else {
                                            setDNDoff();
                                          }
                                        }),
                            ),
                          ])),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setDNDon() async {
    await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
  }

  Future<void> setDNDoff() async {
    await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Choose theme"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Radio(
                        value: 0,
                        groupValue: radioValue,
                        onChanged: (value) {
                          setState(() {
                            radioValue = 0;
                            submit();
                          });
                        }),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text("System Default")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: radioValue,
                        onChanged: (value) {
                          setState(() {
                            radioValue = 1;
                            submit();
                          });
                        }),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text("Light")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: 2,
                        groupValue: radioValue,
                        onChanged: (value) {
                          setState(() {
                            radioValue = 2;
                            submit();
                          });
                        }),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text("Dark")
                  ],
                ),
              ],
            ),
            //Use submit to close dialog
          ));

  void submit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      Navigator.of(context).pop(radioValue);
      preferences.setString("themeMode", themeList[radioValue]);
      theme = preferences.getString("themeMode");
      themeVal = preferences.getString("themeMode")!;
      Fluttertoast.showToast(
          msg: "Restart app to see changes", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    });
  }

  void showDialogPicker(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        preferences.setString("alarmTime",
            "${DateTime.now().year}${(((DateTime.now().month < 10) ? ("0" + DateTime.now().month.toString()) : DateTime.now().month.toString()) + ((DateTime.now().day < 10) ? ("0" + DateTime.now().day.toString()) : DateTime.now().day.toString()))} ${((value.hour < 10) ? ("0" + value.hour.toString()) : value.hour.toString())}:${((value.minute < 10) ? ("0" + value.minute.toString()) : value.minute.toString())}:00");
        time = preferences.getString("alarmTime");
        tme = time!.split(" ")[1].substring(0, 5);
        AndroidAlarmManager.cancel(1);
        //All the settings for the alarm manager
        AndroidAlarmManager.periodic(const Duration(days: 1), 1, runAlarm,
            allowWhileIdle: true,
            rescheduleOnReboot: true,
            exact: true,
            wakeup: true,
            startAt: DateTime.tryParse(time!));
      });
      reminderValue = true;
    }, onError: (error) {});
  }
}
