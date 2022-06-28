import 'package:canton_design_system/canton_design_system.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../../../../utils/dev_functions.dart';
import 'full_prayer_content.dart';
import 'full_thougthofday_content.dart';
import 'full_topic_memoryverse_page.dart';
import 'full_word_content.dart';

class DevotionalPageFromBookmark extends StatefulWidget {
  final String bookmarkedDevotionalDate;
  const DevotionalPageFromBookmark({Key? key, required this.bookmarkedDevotionalDate}) : super(key: key);

  @override
  _DevotionalPageFromBookmarkState createState() => _DevotionalPageFromBookmarkState();
}

class _DevotionalPageFromBookmarkState extends State<DevotionalPageFromBookmark> {

  var _title = '';
  var _memoryVerse = '';
  var _memoryVersePassage = '';
  var _mainWriteUp = '';
  var _prayerBurden = '';
  var _thoughtOfTheDay = '';
  var _fullPassage='';
  var _bibleInAYear='';

  @override
  void initState() {
    getTodayTitleAsString(widget.bookmarkedDevotionalDate);
    getVersePassageAsString(widget.bookmarkedDevotionalDate);
    getVerseAsString(widget.bookmarkedDevotionalDate);
    getTodayMainWriteUpAsString(widget.bookmarkedDevotionalDate);
    getTodayPrayerAsString(widget.bookmarkedDevotionalDate);
    getTodayThoughtOfTheDayAsString(widget.bookmarkedDevotionalDate);
    getTodayFullPassageAsString(widget.bookmarkedDevotionalDate);
    getBibleInYearAsString(widget.bookmarkedDevotionalDate);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'More',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.w100),
                    ),
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
                  const SizedBox(height: 15),
                  ListTile(
                    title: Text('Bible passage:',
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
                        child: Text(_fullPassage,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontWeight: FontWeight.normal))),
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
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'More',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_mainWriteUp,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal)),
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
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'More',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(_prayerBurden,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontWeight: FontWeight.normal)),
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
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'More',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.w100),
                    ),
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
              )
            ],
          ),
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
                  onPageChanged: (page) {
                  },
                  onSelectedItem: (index) {
                    switch (index) {
                      case 0:
                        Navigator.of(context).push(PageTransition(
                            child: FullTopicMemoryVerseVersePage(
                              title: _title,
                              memoryVerse: _memoryVerse,
                              memoryVersePassage: _memoryVersePassage,
                              fullPassage: _mainWriteUp,),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 1:
                        Navigator.of(context).push(PageTransition(
                            child:
                            FullWordContentPage(mainWriteUp: _mainWriteUp),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 2:
                        Navigator.of(context).push(PageTransition(
                            child: FullPrayerPage(prayer: _prayerBurden),
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600)));
                        break;
                      case 3:
                        Navigator.of(context).push(PageTransition(
                            child: FullThoughtOfTheDayPage(
                                thoughtOfTheDay: _thoughtOfTheDay),
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

  getTodayTitleAsString(String dt) async {
    var title = await DevotionalItemsRetrieveClass.getTodayTitle(dt);
    setState(() {
      _title = title!;
    });
  }

  getTodayFullPassageAsString(String dt) async {
    var fullPassage = await DevotionalItemsRetrieveClass.getTodayFullPassage(dt);
    setState(() {
      _fullPassage = fullPassage!;
    });
  }

  getBibleInYearAsString(String dt) async {
    var bibleInYearString =   await DevotionalItemsRetrieveClass.getBibleInYear(dt);
    setState(() {
      _bibleInAYear = bibleInYearString!;
    });
  }

  getVerseAsString(String dt) async {
    var verse = await DevotionalItemsRetrieveClass.getTodayVerse(dt);
    //print(verse);
    setState(() {
      _memoryVerse = verse!;
    });
  }

  getVersePassageAsString(String dt) async {
    var versePassage =
    await DevotionalItemsRetrieveClass.getTodayVersePassage(dt);
    setState(() {
      _memoryVersePassage = versePassage!;
    });
  }

  getTodayMainWriteUpAsString(String dt) async {
    var mainWriteUp =
    await DevotionalItemsRetrieveClass.getTodayMainWriteUp(dt);
    setState(() {
      _mainWriteUp = mainWriteUp!;
    });
  }

  getTodayPrayerAsString(String dt) async {
    var prayerBurden = await DevotionalItemsRetrieveClass.getTodayPrayer(dt);
    setState(() {
      _prayerBurden = prayerBurden!;
    });
  }

  getTodayThoughtOfTheDayAsString(String dt) async {
    var thoughtOfTheDay =
    await DevotionalItemsRetrieveClass.getTodayThoughtOfTheDay(dt);
    setState(() {
      _thoughtOfTheDay = thoughtOfTheDay!;
    });
  }
}
