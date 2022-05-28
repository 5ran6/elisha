import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page.dart';

class FullThoughtOfTheDayPage extends StatelessWidget {
  final String thoughtOfTheDay;

  const FullThoughtOfTheDayPage({required this.thoughtOfTheDay});

  @override
  Widget build(BuildContext context) {
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        if(DateTime.now().difference(_lastExitTime) >= const Duration(seconds: 2)) {
          const snack = SnackBar(content: Text('Press back button again to exit'), duration: Duration(seconds: 2),);
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: Text('Thought Of The Day',
                      style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(thoughtOfTheDay, style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.normal)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
