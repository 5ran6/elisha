import 'package:canton_design_system/canton_design_system.dart';

class FullWordContentPage extends StatefulWidget {
  final String mainWriteUp;

  const FullWordContentPage({required this.mainWriteUp});

  @override
  State<FullWordContentPage> createState() => _FullWordContentPageState();
}

class _FullWordContentPageState extends State<FullWordContentPage> {
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                  title: Text('Word',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 24)),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(widget.mainWriteUp,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: fontSize)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
