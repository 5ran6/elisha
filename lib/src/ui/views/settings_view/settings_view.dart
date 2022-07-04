import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/main.dart';
import 'package:elisha/src/ui/views/settings_view/settings_header_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/noty_services/notify_service.dart';

SharedPreferences? pref;
String? time;

void runAlarm() async {
  await NotificationService().initNotification();
  final DateTime now = DateTime.now();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  time = preferences.getString("alarmTime");
  NotificationService().showNotification(1, "Secret place",
      "Hey, you scheduled a time with Jesus");
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool reminderValue = true;
  int radioValue = 0;
  List themeList = ["System", "Light", "Dark"];
  String themeVal = "";
  late Future<TimeOfDay?> selectedTime;
  String tme = "";

  @override
  void initState(){
    super.initState();
    if (time == null){
      tme = "Off";
      reminderValue = false;
    } else{
      tme = time!.split(" ")[1];
    }
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
                            Text(themeVal,
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
                                Text(tme,
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
                                      if (reminderValue == false) {
                                        AndroidAlarmManager.cancel(1);
                                      } else {
                                        AndroidAlarmManager.periodic(
                                            const Duration(hours: 1),
                                            1,
                                            runAlarm,
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
                    onTap: () {
                      print("back started");
                    },
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
            title: Text("Choose theme"),
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
                            print(radioValue);
                          });
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    Text("System Default")
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
                            print(radioValue);
                          });
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Light")
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
                            print(radioValue);
                          });
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Dark")
                  ],
                ),
              ],
            ),
            //Use submit to close dialog
          ));

  void submit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      Navigator.of(context).pop(radioValue);
      preferences.setString("themeMode", themeList[radioValue]);
      theme = preferences.getString("themeMode");
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
        // tme = (((value.hour < 10)
        //         ? ("0" + value.hour.toString())
        //         : value.hour.toString()) +
        //     " : " +
        //     ((value.minute < 10)
        //         ? ("0" + value.minute.toString())
        //         : value.minute.toString()));
        preferences.setString("alarmTime",
            "${DateTime.now().year}${(((DateTime.now().month < 10) ? ("0" + DateTime.now().month.toString()) : DateTime.now().month.toString()) + ((DateTime.now().day < 10) ? ("0" + DateTime.now().day.toString()) : DateTime.now().day.toString()))} ${((value.hour < 10) ? ("0" + value.hour.toString()) : value.hour.toString())}:${((value.minute < 10) ? ("0" + value.minute.toString()) : value.minute.toString())}:00");
        time = preferences.getString("alarmTime");
        tme = time!.split(" ")[1];
        print("time = " + time!);
        AndroidAlarmManager.cancel(1);
        AndroidAlarmManager.periodic(const Duration(hours: 1), 1, runAlarm,
            allowWhileIdle: true,
            rescheduleOnReboot: true,
            exact: true,
            wakeup: true,
            startAt: DateTime.tryParse(time!));
      });
      reminderValue = true;
    }, onError: (error) {
      print(error);
    });
  }
}
