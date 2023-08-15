import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

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
    return Align(
      alignment: Alignment.center,
      child: Theme(
        data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        onPrimary: Colors.white,
        primary: Theme.of(context).primaryColor,
        onSurface: PrefManager.getTheme() == "Light" ?  Colors.black : Colors.white,
      ),
    ),
        child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.parse(
                "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-01"),
            lastDate: DateTime.parse(
                "${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month}-30"),
            onDateChanged: (date) {print(date);}),
      ),
    );
  }
}
