import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/devotional_page/full_bibleInAYear_content.dart';
import 'package:elisha/src/ui/views/devotional_page/full_prayer_content.dart';
import 'package:elisha/src/ui/views/devotional_page/full_thougthofday_content.dart';
import 'package:elisha/src/ui/views/devotional_page/full_topic_memoryverse_page.dart';
import 'package:elisha/src/ui/views/devotional_page/full_word_content.dart';
import 'package:intl/intl.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../../../../utils/dev_functions.dart';

class DevotionalPage extends StatefulWidget {
  const DevotionalPage({Key? key, this.devotionalDate}) : super(key: key);
  final DateTime? devotionalDate;
  @override
  _DevotionalPageState createState() => _DevotionalPageState();
}

class _DevotionalPageState extends State<DevotionalPage> {
  var _title = '';
  var _memoryVerse = '';
  var _memoryVersePassage = '';
  var _mainWriteUp = '';
  var _prayerBurden = '';
  var _thoughtOfTheDay = '';
  var _fullPassage = '';
  var _bibleInAYear = '';
  var _thoughtOfTheDayImageToShare = '';
  var _prayerBurdenImageToShare = '';

  @override
  void initState() {
    getTodayTitleAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getVersePassageAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getVerseAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getTodayMainWriteUpAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getTodayPrayerAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getTodayThoughtOfTheDayAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getTodayFullPassageAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getBibleInYearAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getThoughtOfTheDayImageAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
    getPrayerBurdenImageAsString(
        DateFormat('dd.MM.yyyy').format(widget.devotionalDate != null ? widget.devotionalDate! : DateTime.now()));
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
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w100),
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
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino"))),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: Text('Memory Verse:',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(_memoryVerse + " " + _memoryVersePassage,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino"))),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: Text('Bible passage:',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(_fullPassage,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
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
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w100),
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
                            .headlineSmall
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
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(_prayerBurden,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
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
                    title: Text('Thought For The Day',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                    trailing: Text(
                      'More',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(_thoughtOfTheDay,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
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

    return WillPopScope(
      onWillPop: () async {
        //Navigator.push(context, MaterialPageRoute(builder: context) => HomeView());
        return true;
      },
      child: Scaffold(
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
                                title: _title,
                                memoryVerse: _memoryVerse,
                                memoryVersePassage: _memoryVersePassage,
                                fullPassage: _fullPassage,
                              ),
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 600)));
                          break;
                        case 1:
                          Navigator.of(context).push(PageTransition(
                              child: FullWordContentPage(mainWriteUp: _mainWriteUp),
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 600)));
                          break;
                        case 2:
                          Navigator.of(context).push(PageTransition(
                              child:
                                  FullPrayerPage(prayer: _prayerBurden, prayerBurdenImage: _prayerBurdenImageToShare),
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 600)));
                          break;
                        case 3:
                          Navigator.of(context).push(PageTransition(
                              child: FullThoughtOfTheDayPage(
                                  thoughtOfTheDay: _thoughtOfTheDay,
                                  thoughtOfTheDayImage: _thoughtOfTheDayImageToShare),
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 600)));
                          break;
                        case 4:
                          Navigator.of(context).push(PageTransition(
                              child: FullBibleInAYearPage(bibleInAYear: _bibleInAYear),
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 600)));
                          break;
                      }
                    },
                    initialPage: 0,
                    // optional
                    align: ALIGN.CENTER),
              ),
            ],
          ),
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
    var bibleInYearString = await DevotionalItemsRetrieveClass.getBibleInYear(dt);
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
    var versePassage = await DevotionalItemsRetrieveClass.getTodayVersePassage(dt);
    setState(() {
      _memoryVersePassage = versePassage!;
    });
  }

  getTodayMainWriteUpAsString(String dt) async {
    var mainWriteUp = await DevotionalItemsRetrieveClass.getTodayMainWriteUp(dt);
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
    var thoughtOfTheDay = await DevotionalItemsRetrieveClass.getTodayThoughtOfTheDay(dt);
    setState(() {
      _thoughtOfTheDay = thoughtOfTheDay!;
    });
  }

  getThoughtOfTheDayImageAsString(String dt) async {
    var thoughtOfTheDayImageToShare = await DevotionalItemsRetrieveClass.getThoughtOfTheDayImage(dt);
    setState(() {
      _thoughtOfTheDayImageToShare = thoughtOfTheDayImageToShare!;
    });
  }

  getPrayerBurdenImageAsString(String dt) async {
    var prayerBurdenImageToShare = await DevotionalItemsRetrieveClass.getPrayerBurdenImage(dt);
    setState(() {
      _prayerBurdenImageToShare = prayerBurdenImageToShare!;
    });
  }
}
