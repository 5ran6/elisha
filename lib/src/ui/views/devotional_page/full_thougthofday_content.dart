import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FullThoughtOfTheDayPage extends StatelessWidget {
  final String thoughtOfTheDay;
  final String thoughtOfTheDayImage;

  const FullThoughtOfTheDayPage({required this.thoughtOfTheDay, required this.thoughtOfTheDayImage});

  Future saveAndShareImage(String thoughtOfTheDayImageUrl, String linkToPlayStore, String linkToAppleStore) async {

    //final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      var response = await get(Uri.parse(thoughtOfTheDayImageUrl));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(['$documentDirectory/flutter.png'],
        subject: 'Secret Place',
        text: 'Get Secret Place, PlayStore: $linkToPlayStore, AppleStore: $linkToAppleStore',
      );
    } else {
      //Share.share(verseOfDay);
      var response = await get(Uri.parse(thoughtOfTheDayImageUrl));
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
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >= const Duration(seconds: 2)) {
          const snack = SnackBar(
            content: Text('Press back button again to exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false;
        } else {
          return true;
        }
        //Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionalPage()));
        //return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('Thought Of The Day',
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

                      // await Share.share(
                      //     "$thoughtOfTheDay\n\nGet Secret Place App:\nPlayStore: $playStoreUrl\n AppleStore: $appleStoreUrl");

                      saveAndShareImage(thoughtOfTheDayImage, playStoreUrl, appleStoreUrl);
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(thoughtOfTheDay,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
