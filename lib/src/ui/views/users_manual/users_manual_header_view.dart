import 'package:canton_design_system/canton_design_system.dart';

class UsersManualHeaderView extends StatelessWidget {
  const UsersManualHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
      child: Row(children: [Text('User Manual', style: Theme.of(context).textTheme.headline3)]),
    );
  }
}
