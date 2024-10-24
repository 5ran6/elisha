import 'package:canton_design_system/canton_design_system.dart';

class ChurchViewHeader extends StatelessWidget {
  const ChurchViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(children: [Text('Message Clips', style: Theme.of(context).textTheme.displayMedium)]),
    );
  }
}
