import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';

import '../bible_view/bible_view.dart';

class FullBibleInAYearPage extends StatelessWidget {
  final String bibleInAYear;
  const FullBibleInAYearPage({required this.bibleInAYear});

  List getItems() {
    var bibleInAYearList = json.decode(bibleInAYear);
    return bibleInAYearList;
  }

  final bool _isChecked = true;

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
                title: Text('Scriptures For Today',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 21, fontFamily: "Palatino")),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 40),
              ListView(
                shrinkWrap: true,
                children: [
                  ...getItems().map((e) => CheckboxListTile(
                        value: _isChecked,
                        onChanged: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BibleView(biblePassage: e),
                            ),
                          );
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        title: Text(e,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(fontWeight: FontWeight.normal, fontSize: 25, fontFamily: "Palatino")),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
