import 'package:canton_design_system/canton_design_system.dart';

class FullTopicMemoryVerseVersePage extends StatelessWidget {
  final String title;
  final String memoryVerse;
  final String memoryVersePassage;

  const FullTopicMemoryVerseVersePage({required this.title, required this.memoryVerse, required this.memoryVersePassage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('Topic for today:',
                    style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(title, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Memory Verse:',
                    style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(memoryVerse + ' ' + memoryVersePassage, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
