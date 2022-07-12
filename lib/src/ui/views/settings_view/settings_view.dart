import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/main.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:elisha/src/ui/views/settings_view/settings_header_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  //Future<SharedPreferences> pref = SharedPreferences.getInstance();
  List themeList = ["System", "Light", "Dark"];
  late Future<TimeOfDay?> selectedTime;
  bool reminderValue = false;
  int radioValue = 0;
  String themeText = "";
  String timeText = "";

  @override
  void initState() {
    super.initState();
    //Get theme data for the UI
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
                                Text('Daily Remainder',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Text(timeText,
                                    style: TextStyle(
                                        color: reminderValue
                                            ? Colors.grey[600]
                                            : Colors.grey[800]))
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
                                  value: reminderValue,
                                  onChanged: (value) {
                                    setState(() {
                                      reminderValue = value;
                                      //Logic for alarm
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
                    onTap: () {},
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Do not disturb',
                                style: Theme.of(context).textTheme.headline6),
                            Text("On",
                                style: TextStyle(color: Colors.grey[600]))
                          ],
                        ),
                      ),
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
        PrefManager.setTheme(themeText);
    });
  }

  void showDialogPicker(BuildContext context) {
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
      });
      reminderValue = true;
    }, onError: (error) {
      if (kDebugMode) {
        print(Error());
      }
    });
  }
}
