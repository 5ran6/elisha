import 'package:canton_design_system/canton_design_system.dart';

class FullThoughtOfTheDayPage extends StatelessWidget {
  final String thoughtOfTheDay;

  const FullThoughtOfTheDayPage({required this.thoughtOfTheDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Text(thoughtOfTheDay, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))
            ],
          ),
        ),
      ),
    );
  }
}
