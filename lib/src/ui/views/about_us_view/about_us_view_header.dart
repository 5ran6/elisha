import 'package:canton_design_system/canton_design_system.dart';

class AboutUsHeaderView extends StatelessWidget {
  const AboutUsHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
      child: Row(children: [Text('About Us', style: Theme.of(context).textTheme.displaySmall)]),
    );
  }
}
