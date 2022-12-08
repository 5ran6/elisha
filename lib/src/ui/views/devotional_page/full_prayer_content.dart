import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FullPrayerPage extends StatelessWidget {
  final String prayer;
  final String prayerBurdenImage;
  const FullPrayerPage({required this.prayer, required this.prayerBurdenImage});

  Future saveAndShareImage(String prayerBurdenImageUrl, String linkToPlayStore, String linkToAppleStore) async {

    //final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      var response = await get(Uri.parse(prayerBurdenImageUrl));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(['$documentDirectory/flutter.png'],
        subject: 'Secret Place',
        text: 'Get Secret Place, PlayStore: $linkToPlayStore, AppleStore: $linkToAppleStore',
      );
    } else {
      //Share.share(verseOfDay);
      var response = await get(Uri.parse(prayerBurdenImageUrl));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(['$documentDirectory/flutter.png'],
        subject: 'Secret Place',
        text: 'Get Secret Place, Playstore: $linkToPlayStore, AppleStore: $linkToAppleStore',
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Prayer',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () async {
                    const playStoreUrl =
                        'https://cpaisecretplacedevotional.page.link/app';
                    const appleStoreUrl =
                        'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';

                    await Share.share(
                        "$prayer\n\nGet Secret Place App:\nPlay/Apple Store: $playStoreUrl");

                    //saveAndShareImage(prayerBurdenImage, playStoreUrl, appleStoreUrl);
                  },
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(prayer,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
