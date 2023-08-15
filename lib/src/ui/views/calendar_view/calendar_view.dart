import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:flutter/foundation.dart';

import '../../../services/devotionalDB_helper.dart';
import '../devotional_page/devotional_page.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String title = "";
  String bibleText = "";
  DateTime storedDate = DateTime.parse(
      "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-${DateTime.now().day < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day}");
  @override
  void initState() {
    getDevotionalList();
    super.initState();
  }

  void getDevotionalList() async {
    List<Devotional> devotionalList = await DevotionalDBHelper.instance.getDevotionalsDBForMonth(
        "${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}.${DateTime.now().year}");
    print(
        "${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}.${DateTime.now().year}");
    print(devotionalList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_header(context), _body(context)],
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: ViewHeaderTwo(
        title: 'Devotional',
        textColor: Theme.of(context).colorScheme.primary,
        backButton: false,
        buttonOne: const CantonHeaderButton(),
      ),
    );
  }

  Widget _body(BuildContext context) {
    print(MediaQuery.of(context).platformBrightness == Brightness.light);
    print(PrefManager.getTheme());
    DateTime _firstDayNextMonth = DateTime.parse("${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + (DateTime.now().month+1).toString() : DateTime.now().month+1}-01");
    DateTime _firstDayThisMonth = DateTime.parse("${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-01");
    int numOfDays = _firstDayNextMonth.difference(_firstDayThisMonth).inDays;
    DateTime _lastDayThisMonth = DateTime.parse("${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-$numOfDays");
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onPrimary: Colors.white,
              primary: Theme.of(context).primaryColor,
              onSurface: PrefManager.getTheme() == "Light"  || ((PrefManager.getTheme() == "System" || PrefManager.getTheme() == null) && MediaQuery.of(context).platformBrightness == Brightness.light) ? Colors.black : Colors.white,
            ),
          ),
          child: CalendarDatePicker(
              initialDate: DateTime.parse(
                  "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-${DateTime.now().day < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day}"),
              firstDate: _firstDayThisMonth,
              lastDate: _lastDayThisMonth,
              onDateChanged: (date) {
                if (kDebugMode) {
                  print(date);
                }
                checkDoubleClick(date);
                setState(() {
                  // Preview title and bible text
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Topic: ",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Text: ",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        bibleText,
                        style: const TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void checkDoubleClick(DateTime date) {
    if (date == storedDate) {
      print("Double clicked...devotional screen");
      Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DevotionalPage(devotionalDate: date),
            ),
          );
    } else {
      storedDate = date;
      print("Single click");
    }
  }
}
