import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';

import '../../../services/devotionalDB_helper.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  void initState() {
    getDevotionalList();
    super.initState();
  }

  void getDevotionalList() async {
    List<Devotional> devotionalList= await DevotionalDBHelper.instance.getDevotionalsDBForMonth(
        "${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}.${DateTime.now().year}");
    print("${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}.${DateTime.now().year}");
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
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onPrimary: Colors.white,
              primary: Theme.of(context).primaryColor,
              onSurface: PrefManager.getTheme() == "Light" ? Colors.black : Colors.white,
            ),
          ),
          child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.parse(
                  "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-01"),
              lastDate: DateTime.parse(
                  "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-30"),
              onDateChanged: (date) {
                print(date);
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Expanded(
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "The Believer's Authority",
                        style: TextStyle(fontSize: 16),
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
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1 John 4:5",
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
