import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/foundation.dart';

import '../../../services/shared_pref_manager/shared_pref_manager.dart';

class FullWordContentPage extends StatefulWidget {
  final String mainWriteUp;

  const FullWordContentPage({required this.mainWriteUp});

  @override
  State<FullWordContentPage> createState() => _FullWordContentPageState();
}

class _FullWordContentPageState extends State<FullWordContentPage> {
  List<bool> isSelected = [false, false, false];
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
    String? prefFont = PrefManager.getFont();
    if (prefFont == null) {
      PrefManager.setFont("1");
    } else {
      isSelected[int.parse(prefFont)] = true;
      if (kDebugMode) {
        print(isSelected);
      }
    }
    super.initState();
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
                  title: Text('Word',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 24)),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              const SizedBox(height: 5),
              ToggleButtons(
                children: [
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 17),
                  ),
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                  ),
                  Text(
                    'A',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
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
                  PrefManager.setFont(index.toString());
                  setState(() {});
                },
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(widget.mainWriteUp,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: fontSize)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
