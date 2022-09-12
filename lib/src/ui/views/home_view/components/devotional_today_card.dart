import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../devotional_page/devotional_page.dart';

class DevotionalTodayCard extends StatefulWidget {
  final String title;
  final String mainWriteUp;
  final String image;
  final bool internetInfo;
  final String biblePassage;
  final String memoryVerse;
  final String memoryVersePassage;
  final String prayer;
  final String thought;
  final String bibleInAYear;
  late bool isBookmarked;

  DevotionalTodayCard(
      {Key? key,
      required this.title,
      required this.mainWriteUp,
      required this.image,
      required this.internetInfo,
      required this.biblePassage,
      required this.prayer,
      required this.thought,
      required this.isBookmarked,
      required this.memoryVerse,
      required this.memoryVersePassage,
      required this.bibleInAYear})
      : super(key: key);

  @override
  State<DevotionalTodayCard> createState() => _DevotionalTodayCardState();
}

class _DevotionalTodayCardState extends State<DevotionalTodayCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    checkIfDevotionalIsBookmarked(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyy').format(now);

    return Card(
      color: CantonMethods.alternateCanvasColorType2(context),
      shape: CantonSmoothBorder.defaultBorder(),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DevotionalPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                //trailing: Icon(Icons.share),
                title: Text(widget.title,
                    style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                subtitle: Text(
                  widget.mainWriteUp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino"),
                ),
              ),
              //const SizedBox(height: 5),
              Card(
                elevation: 0.0,
                shape: CantonSmoothBorder.defaultBorder(),
                margin: const EdgeInsets.all(5.0),
                child: widget.internetInfo == true
                    ? CachedNetworkImage(
                        imageUrl: widget.image,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : Image.asset('assets/images/light.jpg'),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  isBookmarked
                      ? IconButton(
                          icon: const Icon(Icons.bookmark),
                          onPressed: () {
                            // setState(() {
                            //   widget.isBookmarked = false;
                            // });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () async {
                            setState(() {
                              isBookmarked = true;
                            });

                            String todayDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

                            Devotional dev = Devotional(
                                date: todayDate,
                                title: widget.title,
                                translation: "",
                                memoryVerse: widget.memoryVerse,
                                memoryVersePassage: widget.memoryVersePassage,
                                fullPassage: widget.biblePassage,
                                fullText: widget.mainWriteUp,
                                bibleInAYear: widget.bibleInAYear,
                                image: widget.image,
                                prayerBurden: widget.prayer,
                                thoughtOfTheDay: widget.thought);

                            await DevotionalDBHelper.instance.insertBookMarkedDevotional(dev);
                            List bms = await DevotionalDBHelper.instance.getBookMarkedDevotionalsFromDB();
                          },
                        ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      const playStoreUrl =
                          'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';
                      const appleStoreUrl =
                          'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';

                      await Share.share(
                          "Secret Place Devotional\n$formattedDate\nTopic: ${widget.title}\n\nScripture: ${widget.biblePassage}\n\nMemory Verse: ${widget.memoryVerse}\n${widget.memoryVersePassage}\n\n${widget.mainWriteUp}\n\nPrayer: ${widget.prayer}\n\n Thought: ${widget.thought}\n\nGet Secret Place App:\nPlayStore: $playStoreUrl\n AppleStore: $appleStoreUrl");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  checkIfDevotionalIsBookmarked(String date) async {
    List<Devotional> bmDevotionals = await DevotionalDBHelper.instance.getBookMarkedDevotionalsFromDB();
    for (int i = 0; i < bmDevotionals.length; i++) {
      if (bmDevotionals[i].date == date) {
        setState(() {
          isBookmarked = true;
        });
      } else {
        setState(() {
          isBookmarked = false;
        });
      }
    }
  }
}
