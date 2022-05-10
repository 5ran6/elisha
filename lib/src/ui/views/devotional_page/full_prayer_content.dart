import 'package:canton_design_system/canton_design_system.dart';

class FullPrayerPage extends StatelessWidget {
  final String prayer;
  const FullPrayerPage({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              ),
              const SizedBox(height: 5),
              Text(prayer, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))
            ],
          ),
        ),
      ),
    );
  }
}
