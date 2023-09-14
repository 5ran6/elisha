import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import '../../../../utils/dev_functions.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../providers/api_provider.dart';
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
    title = (await DevotionalItemsRetrieveClass.getTodayTitle((DateFormat('dd.MM.yyyy').format(DateTime.now()))))!;
    bibleText =
        (await DevotionalItemsRetrieveClass.getTodayFullPassage((DateFormat('dd.MM.yyyy').format(DateTime.now()))))!;
    setState(() {});
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
    DateTime _firstDayNextMonth = DateTime.parse(
        "${DateTime.now().year}-${(DateTime.now().month+1 < 10 && DateTime.now().month != 12) ? '0' + (DateTime.now().month + 1).toString() : DateTime.now().month + 1}-01");
    DateTime _firstDayThisMonth = DateTime.parse(
        "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-01");
    int _lastDate = _firstDayNextMonth.difference(_firstDayThisMonth).inDays;
    DateTime _lastDayThisMonth = DateTime.parse(
        "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-${_lastDate < 10 ? '0' + _lastDate.toString() : _lastDate}");
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onPrimary: Colors.white,
              primary: Theme.of(context).primaryColor,
              onSurface: PrefManager.getTheme() == "Light" ||
                      ((PrefManager.getTheme() == "System" || PrefManager.getTheme() == null) &&
                          MediaQuery.of(context).platformBrightness == Brightness.light)
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          child: CalendarDatePicker(
              initialDate: DateTime.parse(
                  "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-${DateTime.now().day < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day}"),
              firstDate: _firstDayThisMonth.subtract(_firstDayNextMonth.difference(DateTime.parse(
                  "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + (DateTime.now().month - 6).toString() : DateTime.now().month - 6}-01"))),
              lastDate: _lastDayThisMonth,
              onDateChanged: (date) {
                checkDoubleClick(date);
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
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

  void checkDoubleClick(DateTime date) async {
    if (date == storedDate) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DevotionalPage(devotionalDate: date),
        ),
      );
    } else {
      if (storedDate.month != date.month) {
        try {
          List<Devotional> lsdv =
              await DevotionalDBHelper.instance.getDevotionalsDBForMonth(DateFormat('MM.yyyy').format(date));
          if (lsdv.isEmpty) {
            Fluttertoast.showToast(
                msg: "Loading ${DateFormat('MMMM').format(date)}'s devotionals",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
            List<Devotional> listOfDevs = await RemoteAPI.getDevotionalsForMonth(DateFormat('MMMMyyyy').format(date));
            DevotionalDBHelper.instance.insertDevotionalList(listOfDevs).then((value) {
              Fluttertoast.showToast(
                  msg: "Done loading ${DateFormat('MMMM').format(date)}'s devotional",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
            });
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Unable to download ${DateFormat('MMMM').format(date)}'s devotional",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        }
      }
      storedDate = date;
      try {
        title = (await DevotionalItemsRetrieveClass.getTodayTitle((DateFormat('dd.MM.yyyy').format(date))))!;
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Devotional is unavailable", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        title = '';
      }
      bibleText = title == ''
          ? ''
          : (await DevotionalItemsRetrieveClass.getTodayFullPassage((DateFormat('dd.MM.yyyy').format(date))))!;
      setState(() {
        Fluttertoast.showToast(
            msg: "Tap again to view full devotional", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    }
  }
}
