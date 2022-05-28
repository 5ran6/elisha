import 'package:canton_design_system/canton_design_system.dart';

class BibleStudySeriesHeaderView extends StatelessWidget {
  const BibleStudySeriesHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Study Plans', style: Theme.of(context).textTheme.headline2),
         const Icon(Icons.search, size: 30)
      ]),
    );
  }
}
