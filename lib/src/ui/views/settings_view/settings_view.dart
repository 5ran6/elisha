import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/noty_services/notify_service.dart';
import 'package:elisha/src/ui/views/settings_view/settings_header_view.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Done");
    NotificationService().showNotification(1, "title", "body");
    return Future.value(true);
  });
}

class _SettingsPageState extends State<SettingsPage> {
  //late TimeOfDay time = TimeOfDay.now();

  bool reminderValue = true;
  bool disturbValue = false;
  int radioValue = 0;
  List themeList = ["System Default", "Light", "Dark"];
  late Future<TimeOfDay?> selectedTime;
  String tme = "6:00";
  //String current

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          Text(themeList[radioValue],
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
                                  style: Theme.of(context).textTheme.headline6),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Do not disturb',
                                  style: Theme.of(context).textTheme.headline6),
                              Text(disturbValue ? "On" : "Off",
                                  style: TextStyle(color: Colors.grey[600]))
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
                                value: disturbValue,
                                onChanged: (value) {
                                  setState(() {
                                    disturbValue = value;
                                  });
                                }),
                          ),
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

  void submit() {
    Navigator.of(context).pop(radioValue);
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
        tme = (((value.hour < 10)
                ? ("0" + value.hour.toString())
                : value.hour.toString()) +
            " : " +
            ((value.minute < 10)
                ? ("0" + value.minute.toString())
                : value.minute.toString()));
        print((value.hour - DateTime.now().hour)%24);
        print((value.minute - DateTime.now().minute)%60);

        //NotificationService().showNotification(1, "title", "body");
        Workmanager().cancelAll();
        print("Cancelled");
        Workmanager().registerOneOffTask("uniqueName", "taskName");
      });
      reminderValue = true;
    }, onError: (error) {
      print(error);
    });
  }

  void scheduleTime() {
    DateTime now = DateTime.now();
    //currentTime =
    Workmanager().registerPeriodicTask("uniqueName2", "taskName", frequency: const Duration(minutes: 15));
}
}

//Card(
//color: CantonMethods.alternateCanvasColorType2(context),
//shape: CantonSmoothBorder.defaultBorder(),
