/*
Elisha iOS & Android App
Copyright (C) 2021 Elisha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/verse.dart';
import 'package:elisha/src/ui/components/verse_of_the_day_card.dart';
import 'package:elisha/src/ui/views/home_view/components/bible_in_a_year_card.dart';
import 'package:elisha/src/ui/views/home_view/components/devotional_today_card.dart';
import 'package:elisha/src/ui/views/home_view/components/selected_study_plans_listview.dart';
import 'package:elisha/src/ui/views/home_view/components/streaks_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/ui/views/home_view/components/home_view_header.dart';
import 'package:intl/intl.dart';

import '../../../../utils/dev_functions.dart';
import '../../../models/devotional.dart';
import '../../../services/devotional_helper.dart';
import 'components/study_plans_listview.dart';

class HomeView extends StatefulWidget {


 const HomeView({ Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _verse='';
  var _versePassage='';
  var _title='';
  var _mainWriteUp='';

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }


  @override
  void initState() {

  getVerseAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
  getVersePassageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
  getTodayTitleAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
  getTodayMainWriteUpAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HomeViewHeader(),
              _body(context),
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const StreaksCard(),
        const SizedBox(height: 15),
        VerseOfTheDayCard(verse: _verse, versePassage: _versePassage),
        const SizedBox(height: 15),
        DevotionalTodayCard(title: _title, mainWriteUp: _mainWriteUp),
        const SizedBox(height: 15),
        BibleInAYearCard(),
        const SizedBox(height: 15),
        SelectedStudyPlansListview(),
        const SizedBox(height: 15),
        StudyPlansListView()
      ],
    );
  }

  //final String vs;
  getVerseAsString(String dt) async {
    var verse =   await DevotionalItemsRetrieveClass.getTodayVerse(dt);
    //print(verse);
    setState(() {
      _verse = verse;
    });
  }

  getVersePassageAsString(String dt) async {
    var versePassage =   await DevotionalItemsRetrieveClass.getTodayVersePassage(dt);
    setState(() {
      _versePassage = versePassage;
    });
  }

  getTodayTitleAsString(String dt) async {
    var title =   await DevotionalItemsRetrieveClass.getTodayTitle(dt);
    setState(() {
      _title = title;
    });
  }

  getTodayMainWriteUpAsString(String dt) async {
    var mainWriteUp =   await DevotionalItemsRetrieveClass.getTodayMainWriteUp(dt);
    setState(() {
      _mainWriteUp = mainWriteUp;
    });
  }


}
