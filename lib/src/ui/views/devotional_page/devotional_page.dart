import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/devotional_page/full_prayer_content.dart';
import 'package:elisha/src/ui/views/devotional_page/full_thougthofday_content.dart';
import 'package:elisha/src/ui/views/devotional_page/full_topic_memoryverse_page.dart';
import 'package:elisha/src/ui/views/devotional_page/full_word_content.dart';
import 'package:intl/intl.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../../../../utils/dev_functions.dart';

class DevotionalPage extends StatefulWidget {
  const DevotionalPage({Key? key}) : super(key: key);

  @override
  _DevotionalPageState createState() => _DevotionalPageState();
}

class _DevotionalPageState extends State<DevotionalPage> {
  var _title='';
  var _memoryVerse='';
  var _memoryVersePassage='';
  var _mainWriteUp='';
  var _prayerBurden='';
  var _thoughtOfTheDay='';


  @override
  void initState() {
    getTodayTitleAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getVersePassageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getVerseAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayMainWriteUpAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayPrayerAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayThoughtOfTheDayAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));


  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> devotionalCards = [
      Expanded(
        child: Card(
          color: CantonMethods.alternateCanvasColorType2(context),
          shape: CantonSmoothBorder.defaultBorder(),
          child: Column(
            children: [
              ListTile(
                title: Text('Topic for today:',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(_title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal))),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Memory Verse:',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(_memoryVerse + " " + _memoryVersePassage,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal))),
              ),
            ],
          ),
        ),
      ),
      // Expanded(
      //   child: Card(
      //   color: CantonMethods.alternateCanvasColorType2(context),
      //   shape: CantonSmoothBorder.defaultBorder(),
      //   child: Column(
      //     children: [
      //       ListTile(
      //         title: Text('Memory Verse',
      //             style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
      //       ),
      //       Text('Memory verse for today', style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.normal))
      //     ],
      //   ),
      // ),
      // ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: Column(
          children: [
            ListTile(
              title: Text('Word',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(fontWeight: FontWeight.bold)),
              trailing: Text(
                'More',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(_mainWriteUp,
                  maxLines: 12,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.normal)),
            )
          ],
        ),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: Column(
          children: [
            ListTile(
              title: Text('Prayer',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            Text(_prayerBurden,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontWeight: FontWeight.normal))
          ],
        ),
      ),
      Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: Column(
          children: [
            ListTile(
              title: Text('Thought for The Day',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(_thoughtOfTheDay,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontWeight: FontWeight.normal)),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: VerticalCardPager(
                  images: devotionalCards,
                  titles: const ['', '', '', ''],
                  onPageChanged: (page) {},
                  onSelectedItem: (index) {
                    switch (index) {
                      case 0:
                        Navigator.of(context).push(PageTransition(
                            child: FullTopicMemoryVerseVersePage(title: _title, memoryVerse: _memoryVerse, memoryVersePassage: _memoryVersePassage),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)
                        ));
                        break;
                      case 1:
                        Navigator.of(context).push(PageTransition(
                            child: FullWordContentPage(mainWriteUp: _mainWriteUp),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                        duration: const Duration(milliseconds: 600)
                        ));
                        break;
                      case 2:
                        Navigator.of(context).push(PageTransition(
                            child: FullPrayerPage(prayer: _prayerBurden),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)
                        ));
                        break;
                      case 3:
                        Navigator.of(context).push(PageTransition(
                            child: FullThoughtOfTheDayPage(thoughtOfTheDay: _thoughtOfTheDay),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)
                        ));
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

  getTodayTitleAsString(String dt) async {
    var title =   await DevotionalItemsRetrieveClass.getTodayTitle(dt);
    setState(() {
      _title = title;
    });
  }
  getVerseAsString(String dt) async {
    var verse =   await DevotionalItemsRetrieveClass.getTodayVerse(dt);
    //print(verse);
    setState(() {
      _memoryVerse = verse;
    });
  }

  getVersePassageAsString(String dt) async {
    var versePassage =   await DevotionalItemsRetrieveClass.getTodayVersePassage(dt);
    setState(() {
      _memoryVersePassage = versePassage;
    });
  }

  getTodayMainWriteUpAsString(String dt) async {
    var mainWriteUp =   await DevotionalItemsRetrieveClass.getTodayMainWriteUp(dt);
    setState(() {
      _mainWriteUp = mainWriteUp;
    });
  }

  getTodayPrayerAsString(String dt) async {
    var prayerBurden =   await DevotionalItemsRetrieveClass.getTodayPrayer(dt);
    setState(() {
      _prayerBurden = prayerBurden;
      print('mmmmmmmmmmmmmmmmmmmmmm');
      print(prayerBurden);
    });
  }

  getTodayThoughtOfTheDayAsString(String dt) async {
    var thoughtOfTheDay =   await DevotionalItemsRetrieveClass.getTodayThoughtOfTheDay(dt);
    setState(() {
      _thoughtOfTheDay = thoughtOfTheDay;
      print('mmmmmmmmmmmmmmmmmmmmmm');
      print(thoughtOfTheDay);
    });
  }

}
