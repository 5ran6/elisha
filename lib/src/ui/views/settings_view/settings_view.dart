import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/alarm_services.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:elisha/src/ui/views/settings_view/settings_header_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:elisha/src/providers/theme_manager_provider.dart';

import '../../../services/noty_services/notify_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List themeList = ["System", "Light", "Dark"];
  late Future<TimeOfDay?> selectedTime;
  bool reminderValue = false;
  int radioValue = 0;
  String themeText = "";
  String timeText = "";
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

  @override
  void initState() {
    super.initState();
    checkAndSetDNDInitState();
    themeText = PrefManager.getTheme() ?? "System";

    //Get alarm data for the UI
    timeText = PrefManager.getTime() ?? "Off";
    reminderValue = !(timeText == "Off");
  }

  @override
  Widget build(BuildContext context) {
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
                            Text('Theme',
                                style: Theme.of(context).textTheme.headline6),
                            Text(themeText,
                                style: TextStyle(color: Colors.grey[600])),
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
                      if (Platform.isAndroid){
                        timeText  == "Off" ? showDialogPicker(context) : FlutterAlarmClock.showAlarms();
                      }
                      else if (Platform.isIOS){
                        showDialogPicker(context);
                      }
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Daily Remainder',
                                style: Theme.of(context).textTheme.headline6),
                            Text(timeText,
                                style: TextStyle(
                                    color: reminderValue
                                        ? Colors.grey[600]
                                        : Colors.grey[800])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      var isNotificationPolicyAccessGranted =
                          (await FlutterDnd.isNotificationPolicyAccessGranted);
                      if ((isNotificationPolicyAccessGranted) != null &&
                          isNotificationPolicyAccessGranted) {
                        setState(() {
                          isDNDPolicyAccessGranted = true;
                        });
                        if (isDoNotDisturbFunctionOn == true) {
                          await FlutterDnd.setInterruptionFilter(
                              FlutterDnd.INTERRUPTION_FILTER_ALL);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('dndInit', 'off');

                          setState(() {
                            isDoNotDisturbFunctionOn = false;
                          });
                          saveDoNotDisturbStatusToSharedPref();
                        } else {
                          await FlutterDnd.setInterruptionFilter(
                              FlutterDnd.INTERRUPTION_FILTER_NONE);
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Do not disturb(Tap me)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Text(
                                        isDoNotDisturbFunctionOn ? "On" : "Off",
                                        style:
                                            TextStyle(color: Colors.grey[600]))
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Switch.adaptive(
                                      activeColor: Colors.blueGrey,
                                      activeTrackColor:
                                          Colors.blueGrey.withOpacity(0.4),
                                      inactiveThumbColor: Colors.black87,
                                      inactiveTrackColor: Colors.black12,
                                      splashRadius: 50,
                                      value: isDoNotDisturbFunctionOn,
                                      onChanged:
                                          isDNDPolicyAccessGranted == false
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    isDoNotDisturbFunctionOn =
                                                        value;
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
                RadioListTile(
                    title: const Text("System default"),
                    value: 0,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = 0;
                        submit();
                      });
                    }),
                RadioListTile(
                    title: const Text("Light"),
                    value: 1,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = 1;
                        submit();
                      });
                    }),
                RadioListTile(
                    title: const Text("Dark"),
                    value: 2,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = 2;
                        submit();
                      });
                    }),
              ],
            ),
            //Use submit to close dialog
          ));

  void submit() {
    Navigator.of(context).pop(radioValue);
    setState(() {
      themeText = themeList[radioValue];
      Provider.of<ThemeManager>(context, listen: false).changeTheme(themeText);
    });
  }

  void showDialogPicker(BuildContext context) {
    //Stop running service before starting new service
    if (timeText != "Off"){
      FlutterBackgroundService().on("stopService");
    }
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
        timeText = (value.hour < 10
                ? "0" + value.hour.toString()
                : value.hour.toString()) +
            ":" +
            (value.minute < 10
                ? "0" + value.minute.toString()
                : value.minute.toString());

        PrefManager.setTime(timeText);
        if (Platform.isAndroid){
          FlutterAlarmClock.createAlarm(value.hour, value.minute, title: "Secret place - Reminder");
        }else if (Platform.isIOS){
          //TODO: Test Plan A or B
          //------------------------------------------------------------------------------------------------Plan A------------------------------------------------------------------------------------------------------
          initializeService();

          //------------------------------------------------------------------------------------------------Plan B------------------------------------------------------------------------------------------------------
          //NotificationService().showNotification(1, "Secret Place Reminder", "You scheduled a time with Jesus now", timeText);
        }
        reminderValue = true;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(Error());
      }
    });
  }
}
