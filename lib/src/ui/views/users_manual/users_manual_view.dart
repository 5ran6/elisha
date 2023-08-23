import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/users_manual/users_manual_header_view.dart';

class UsersManualView extends StatefulWidget {
  const UsersManualView({Key? key}) : super(key: key);

  @override
  State<UsersManualView> createState() => _UsersManualViewState();
}

class _UsersManualViewState extends State<UsersManualView> {
  List<bool> isSelected = [];
  double fontSize = 21;

  double getFontSize(int index) {
    if (index == 0) {
      return 17.0;
    } else if (index == 1) {
      return 21.0;
    } else {
      return 25.0;
    }
  }

  @override
  void initState() {
    isSelected = [false, true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const UsersManualHeaderView(),
            const SizedBox(height: 10),
            Card(
              color: CantonMethods.alternateCanvasColorType2(context),
              shape: CantonSmoothBorder.defaultBorder(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ToggleButtons(
                      children: [
                        Text(
                          'A',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 17),
                        ),
                        Text(
                          'A',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                        ),
                        Text(
                          'A',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 25),
                        )
                      ],
                      isSelected: isSelected,
                      onPressed: (index) {
                        for (int i = 0; i < isSelected.length; i++) {
                          if (index == i) {
                            isSelected[i] = true;
                          } else {
                            isSelected[i] = false;
                          }
                        }
                        fontSize = getFontSize(index);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to Secret Place Devotional App. Here are a few tips that will make your use of the application smooth.\n\n Secret Place has an authentication system which you would have encountered when launcing the app for the first time. Choosing to sign in anonymously will deprive you the opportunity of saving your notes to the cloud hence I would advice you use any of the providers to log in. By signing in you can have access to your saved notes when you log in on any other device in the case of device theft or damage.',
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Secret Place makes provision for you to have access to all devotionals for the month without internet connectivity but you will have to download it on any day of the current month to have access. So whenever you want to use the app for the first time in a given month ensure that you have internet connectivity.',
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Secret Place has provision for you to bookmark daily devotionals and chapters of the bible read at will. You can use the bookmark icon to do so and check the Extras page for your bookmarked items.',
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You have the ability to ensure that when Secret Place in on the foreground your device switches the do-not-disturb mode. You can trigger this functionality on the settings page.',
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You have the ability to share the entire devotional for the day as well as certain content like prayer burden and thought of the day via any social media platform on your device.',
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    Text(
                      "If you missed any devotional or you want to go through previous devotionals, Secret place has a calendar view in the 'Monthly Devotionals' section in the profile page where you can read previous devotionals",
                      style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: "Palatino", fontSize: fontSize),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
