import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/about_us_view/about_us_view_header.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
            const AboutUsHeaderView(),
            const SizedBox(height: 10),
            ToggleButtons(
              children: [
                Text(
                  'A',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 17),
                ),
                Text(
                  'A',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                ),
                Text(
                  'A',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
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
            const SizedBox(height: 5),
            Card(
              color: CantonMethods.alternateCanvasColorType2(context),
              shape: CantonSmoothBorder.defaultBorder(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'CPAI(CACAF Professional Advancement Initiative) is a project-based learning initiative to equip the CACAF(Calvary Arrows College Alumni Family) with the relevant skills and exposure necessary to thrive in our ever-changing digital age.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Secret Place attempts to create a virtual digital private environment for young people to have their morning devotions undisturbed and thus build a vibrant relationship with God',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: fontSize),
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
