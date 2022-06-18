import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Scriptures For Today',
                    style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 15),
              ListView(
                shrinkWrap: true,
                children: [
                  ...getItems().map((e) => CheckboxListTile(
                      value: _isChecked,
                      onChanged: (value) {},
                      controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                      title: Text(e, style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.normal)),
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
