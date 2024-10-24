import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/verse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/devotional.dart';
import '../../services/devotionalDB_helper.dart';

class VerseOfTheDayCard extends StatelessWidget {
  final String verse;
  final String versePassage;
  final String memoryVerseImageUrl;
  const VerseOfTheDayCard({required this.verse, required this.versePassage, required this.memoryVerseImageUrl});

  Future saveAndShareImage(
      String memoryVerseImage, String linkToPlayStore, String linkToAppleStore, String verseOfDay) async {
    //final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      var response = await get(Uri.parse(memoryVerseImage));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(
        ['$documentDirectory/flutter.png'],
        subject: 'Secret Place',
        text: 'Get Secret Place, Playstore: $linkToPlayStore, AppleStore: $linkToAppleStore',
      );
    } else {
      //Share.share(verseOfDay);
      var response = await get(Uri.parse(memoryVerseImage));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(
        ['$documentDirectory/flutter.png'],
        subject: 'Secret Place',
        text: 'Get Secret Place, Playstore: $linkToPlayStore, AppleStore: $linkToAppleStore',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor() {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return CantonDarkColors.gray[300]!;
      }
      return CantonColors.gray[300]!;
    }

    return GestureDetector(
      onTap: () {},
      child: Card(
        color: CantonMethods.alternateCanvasColorType2(context),
        shape: CantonSmoothBorder.defaultBorder(),
        child: Container(
          padding: const EdgeInsets.all(17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context, bgColor()),
                    const SizedBox(height: 15),
                    _body(context, bgColor()),
                    const SizedBox(height: 15),
                    _bookChapterVerse(context),
                  ],
                ),
              ),
              _favoriteButton(context, bgColor()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, Color bgColor) {
    return Text(
      'Verse of the Day',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino"),
    );
  }

  Widget _favoriteButton(BuildContext context, Color bgColor) {
    Color heartColor() {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Theme.of(context).primaryColor;
      }
      return Theme.of(context).primaryColor;
    }

    return GestureDetector(
      onTap: () async {
        const playStoreUrl = 'https://cpaisecretplacedevotional.page.link/app';
        const appleStoreUrl = 'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';
        String verseOfDay =
            "$verse\n$versePassage\n\nGet Secret Place App:\nPlayStore: $playStoreUrl\n AppleStore: $appleStoreUrl";

        await Share.share("$verse\n$versePassage\n\nGet Secret Place App:\nPlay/Apple Store: $playStoreUrl");

        //saveAndShareImage(memoryVerseImageUrl, playStoreUrl, appleStoreUrl, verseOfDay);
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.share,
            size: 19,
            color: heartColor(),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, Color bgColor) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Text(
              verse,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontFamily: "Palatino"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookChapterVerse(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    return Text(
      versePassage,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontFamily: "Palatino"),
    );
  }
}
