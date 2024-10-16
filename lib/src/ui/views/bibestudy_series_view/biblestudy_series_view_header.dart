import 'package:canton_design_system/canton_design_system.dart';

class BibleStudySeriesHeaderView extends StatelessWidget {
  const BibleStudySeriesHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(children: [
        Text('Study Plans', style: Theme.of(context).textTheme.displayMedium),
      ]),
    );
  }
}
