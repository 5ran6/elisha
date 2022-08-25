import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/bible_view/bible_view.dart';

class FullTopicMemoryVerseVersePage extends StatefulWidget {
  final String title;
  final String memoryVerse;
  final String memoryVersePassage;
  final String fullPassage;

  const FullTopicMemoryVerseVersePage(
      {required this.title, required this.memoryVerse, required this.memoryVersePassage, required this.fullPassage});

  @override
  State<FullTopicMemoryVerseVersePage> createState() => _FullTopicMemoryVerseVersePageState();
}

class _FullTopicMemoryVerseVersePageState extends State<FullTopicMemoryVerseVersePage> {
  List<bool> isSelected = [];
  double fontSize = 21;

  double getFontSize(int index) {
    if (index == 0) {
      return 17.0;
    } else if (index == 1) {
      return 21.0;
    } else {
      return 25.0;
    }
  }

  @override
  void initState() {
    isSelected = [false, true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 5),
              ToggleButtons(
                children: [
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 17),
                  ),
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                  ),
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 25),
                  )
                ],
                isSelected: isSelected,
                onPressed: (index) {
                  for (int i = 0; i < isSelected.length; i++) {
                    if (index == i) {
                      isSelected[i] = true;
                    } else {
                      isSelected[i] = false;
                    }
                  }
                  fontSize = getFontSize(index);
                  setState(() {});
                },
              ),
              const SizedBox(height: 5),
              ListTile(
                title: Text('Topic for today:',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize, fontFamily: 'Palatino')),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal, fontSize: fontSize, fontFamily: 'Palatino'))),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Memory Verse:',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize, fontFamily: 'Palatino')),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.memoryVerse + ' ' + widget.memoryVersePassage,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.normal, fontSize: fontSize, fontFamily: 'Palatino'))),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Bible Passage:',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize, fontFamily: 'Palatino')),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BibleView(biblePassage: widget.fullPassage),
                    ),
                  );
                  print(widget.fullPassage);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(widget.fullPassage,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.normal, fontSize: fontSize, fontFamily: 'Palatino'))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
