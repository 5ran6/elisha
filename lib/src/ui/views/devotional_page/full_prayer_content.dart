import 'package:canton_design_system/canton_design_system.dart';
import 'package:share_plus/share_plus.dart';

class FullPrayerPage extends StatelessWidget {
  final String prayer;
  const FullPrayerPage({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Prayer',
                    style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () async {
                    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';
                    const appleStoreUrl = 'https://play.google.com/store/apps/details?id=com.cpaii.secretplaceversiontwo';

                    await Share.share("$prayer\n\nGet Secret Place App:\nPlayStore: $playStoreUrl\n AppleStore: $appleStoreUrl");
                  },
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(prayer, style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.normal)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
