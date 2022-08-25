import 'package:canton_design_system/canton_design_system.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../../../models/devotional.dart';
import 'full_bibleInAYear_content.dart';
import 'full_prayer_content.dart';
import 'full_thougthofday_content.dart';
import 'full_topic_memoryverse_page.dart';
import 'full_word_content.dart';

class DevotionalPageFromPlans extends StatefulWidget {
  final Devotional devotionalFromPlan;

  const DevotionalPageFromPlans({required this.devotionalFromPlan});

  @override
  _DevotionalPageFromPlansState createState() => _DevotionalPageFromPlansState();
}

class _DevotionalPageFromPlansState extends State<DevotionalPageFromPlans> {
  @override
  Widget build(BuildContext context) {
    String title = widget.devotionalFromPlan.title;
    String memoryVerse = widget.devotionalFromPlan.memoryVerse;
    String memoryVersePassage = widget.devotionalFromPlan.memoryVersePassage;
    String fullText = widget.devotionalFromPlan.fullText;
    String fullPassage = widget.devotionalFromPlan.fullPassage;
    String prayerBurden = widget.devotionalFromPlan.prayerBurden;
    String thoughtOfTheDay = widget.devotionalFromPlan.thoughtOfTheDay;
    String bibleInAYear = widget.devotionalFromPlan.bibleInAYear;

    final List<Widget> devotionalCards = [
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Wrap(
              children: [
                Column(children: [
                  ListTile(
                    title: Text('Topic for today:',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(title,
                            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: Text('Memory Verse:',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(memoryVerse + " " + memoryVersePassage,
                            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: Text('Bible passage:',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(fullPassage,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino"))),
                  )
                ])
              ],
            )),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  ListTile(
                    title: Text('Word',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(fullText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  ListTile(
                    title: Text('Prayer',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(prayerBurden,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  ListTile(
                    title: Text('Thought for The Day',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(thoughtOfTheDay,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/bible_in_one_year.jpg',
              fit: BoxFit.cover,
            )),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: VerticalCardPager(
                  images: devotionalCards,
                  titles: const ['', '', '', '', ''],
                  onPageChanged: (page) {},
                  onSelectedItem: (index) {
                    switch (index) {
                      case 0:
                        Navigator.of(context).push(PageTransition(
                            child: FullTopicMemoryVerseVersePage(
                              title: title,
                              memoryVerse: memoryVerse,
                              memoryVersePassage: memoryVersePassage,
                              fullPassage: fullPassage,
                            ),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 1:
                        Navigator.of(context).push(PageTransition(
                            child: FullWordContentPage(mainWriteUp: fullText),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 2:
                        Navigator.of(context).push(PageTransition(
                            child: FullPrayerPage(prayer: prayerBurden),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 3:
                        Navigator.of(context).push(PageTransition(
                            child: FullThoughtOfTheDayPage(thoughtOfTheDay: thoughtOfTheDay),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 4:
                        Navigator.of(context).push(PageTransition(
                            child: FullBibleInAYearPage(bibleInAYear: bibleInAYear),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                    }
                  },
                  initialPage: 1,
                  // optional
                  align: ALIGN.CENTER),
            ),
          ],
        ),
      ),
    );
  }
}
