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

import 'dart:convert';
import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/models/verse.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/ui/components/verse_of_the_day_card.dart';
import 'package:elisha/src/ui/views/home_view/components/bible_in_a_year_card.dart';
import 'package:elisha/src/ui/views/home_view/components/devotional_today_card.dart';
import 'package:elisha/src/ui/views/home_view/components/selected_study_plans_listview.dart';
import 'package:elisha/src/ui/views/home_view/components/streaks_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/ui/views/home_view/components/home_view_header.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/dev_functions.dart';
import '../../../models/devotional.dart';
import '../../../services/devotionalDB_helper.dart';
import '../authentication_views/sign_in_providers_view/sign_in_providers_view.dart';
import 'components/study_plans_listview.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _verse = '';
  var _versePassage = '';
  var _title = '';
  var _mainWriteUp = '';
  var _image = '';
  var _fullpassage = '';
  var _prayerBurden = '';
  var _thoughtOfTheDay = '';
  var _bibleInAYear = '';
  var _memoryVerseImageToShare = '';
  var _thoughtOfTheDayImageToShare = '';
  var _prayerBurdenImageToShare = '';
  bool _isBookmarked = false;

  var _devPlansList = List<DevotionalPlan>.empty();

  //var _devPlansListCache = List<DevotionalPlan>.empty();

  bool isAnonymousUser = false;

  var _devPlansListFromDB = List<DevotionalPlan>.empty();

  bool _isConnectionSuccessful = false;

  bool showSignIn = true;

  // Future<void> isUserAnonymous() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final String? storedValue = prefs.getString('key');
  //   if (storedValue != null) {
  //     setState(() {
  //       isAnonymousUser == true;
  //     });
  //   }
  // }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }
  bool isLoading = false;

  void _toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  @override
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    _tryConnection();
    //isUserAnonymous();
    checkIfDevotionalIsBookmarked(
        DateFormat('dd.MM.yyyy').format(DateTime.now()));

    getVerseAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getVersePassageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayTitleAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayMainWriteUpAsString(
        DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayFullPassageAsString(
        DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayPrayerAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getTodayThoughtAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getImageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getBibleInYearAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getMemoryVerseImageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getThoughtOfTheDayImageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));
    getPrayerBurdenImageAsString(DateFormat('dd.MM.yyyy').format(DateTime.now()));

    cacheStudyPlans();
    getStudyPlansFromDB();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff

      getStudyPlansFromDB();
    }
  }

  Widget _content(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HomeViewHeader(),
         isLoading ? buildSkeleton() :_body(context) ,
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const StreaksCard(),
        const SizedBox(height: 15),
        VerseOfTheDayCard(verse: _verse, versePassage: _versePassage, memoryVerseImageUrl: _memoryVerseImageToShare),
        const SizedBox(height: 15),
        DevotionalTodayCard(
            title: _title,
            mainWriteUp: _mainWriteUp,
            image: _image,
            internetInfo: _isConnectionSuccessful,
            biblePassage: _fullpassage,
            prayer: _prayerBurden,
            thought: _thoughtOfTheDay,
            isBookmarked: _isBookmarked,
            memoryVersePassage: _versePassage,
            memoryVerse: _verse,
            bibleInAYear: _bibleInAYear,
          memoryVerseImage: _memoryVerseImageToShare,
          thoughtOfTheDayImage: _thoughtOfTheDayImageToShare,
          prayerBurdenImage: _prayerBurdenImageToShare,
        ),
        const SizedBox(height: 15),
        SelectedStudyPlansListview(devPlansFromDB: _devPlansListFromDB),
        const SizedBox(height: 5),
        DevotionalPlansHomePageListView(devPlans: _devPlansList)
      ],
    );
  }

  //final String vs;
  getVerseAsString(String dt) async {
    var verse = await DevotionalItemsRetrieveClass.getTodayVerse(dt);
    //print(verse);
    setState(() {
      _verse = verse!;
    });
  }

  getVersePassageAsString(String dt) async {
    var versePassage =
        await DevotionalItemsRetrieveClass.getTodayVersePassage(dt);
    setState(() {
      _versePassage = versePassage!;
    });
  }

  getTodayTitleAsString(String dt) async {
    var title = await DevotionalItemsRetrieveClass.getTodayTitle(dt);
    setState(() {
      _title = title!;
    });
  }

  getTodayMainWriteUpAsString(String dt) async {
    var mainWriteUp =
        await DevotionalItemsRetrieveClass.getTodayMainWriteUp(dt);
    setState(() {
      _mainWriteUp = mainWriteUp!;
    });
  }

  getTodayPrayerAsString(String dt) async {
    var prayerBurden = await DevotionalItemsRetrieveClass.getTodayPrayer(dt);
    setState(() {
      _prayerBurden = prayerBurden!;
    });
  }

  getTodayThoughtAsString(String dt) async {
    var thought =
        await DevotionalItemsRetrieveClass.getTodayThoughtOfTheDay(dt);
    setState(() {
      _thoughtOfTheDay = thought!;
    });
  }

  getTodayFullPassageAsString(String dt) async {
    var fullPassage =
        await DevotionalItemsRetrieveClass.getTodayFullPassage(dt);
    setState(() {
      _fullpassage = fullPassage!;
    });
  }

  getImageAsString(String dt) async {
    var image = await DevotionalItemsRetrieveClass.getImage(dt);
    setState(() {
      _image = image!;
    });
  }

  getMemoryVerseImageAsString(String dt) async {
    var memoryVerseImageToShare = await DevotionalItemsRetrieveClass.getMemoryVerseImage(dt);
    setState(() {
      _memoryVerseImageToShare = memoryVerseImageToShare!;
    });
  }
  getThoughtOfTheDayImageAsString(String dt) async {
    var thoughtOfTheDayImageToShare = await DevotionalItemsRetrieveClass.getThoughtOfTheDayImage(dt);
    setState(() {
      _thoughtOfTheDayImageToShare = thoughtOfTheDayImageToShare!;
    });
  }
  getPrayerBurdenImageAsString(String dt) async {
    var prayerBurdenImageToShare = await DevotionalItemsRetrieveClass.getPrayerBurdenImage(dt);
    setState(() {
      _prayerBurdenImageToShare = prayerBurdenImageToShare!;
    });
  }

  getBibleInYearAsString(String dt) async {
    var bibleInYearString =
        await DevotionalItemsRetrieveClass.getBibleInYear(dt);
    setState(() {
      _bibleInAYear = bibleInYearString!;
    });
  }

  cacheStudyPlans() async {
    List<DevotionalPlan> devPlans = await RemoteAPI.getDevotionalPlans();
    if (devPlans.isNotEmpty) {
      await DevotionalDBHelper.instance.deleteDevotionalPlansForCache();
      await DevotionalDBHelper.instance
          .insertDevotionalPLanListForCache(devPlans);
    }

    List<DevotionalPlan> devPlansCacheFromDB =
        await DevotionalDBHelper.instance.getDevotionalPlanForCacheDB();
    try {
      if (devPlansCacheFromDB.isNotEmpty) {
        setState(() {
          _devPlansList = devPlansCacheFromDB;
        });
      }
    } catch (e){
      if (kDebugMode) {
        print('Something bad happened: $e');
      }
    }
  }

  getStudyPlansFromDB() async {
    List<DevotionalPlan> devPlansFromDB =
        await DevotionalDBHelper.instance.getDevotionalPlansFromDB();

    setState(() {
      _devPlansListFromDB = devPlansFromDB;
    });
  }

  checkIfDevotionalIsBookmarked(String date) async {
    List<Devotional> bmDevotionals =
        await DevotionalDBHelper.instance.getBookMarkedDevotionalsFromDB();
    for (int i = 0; i < bmDevotionals.length; i++) {
      if (bmDevotionals[i].date == date) {
        setState(() {
          _isBookmarked = true;
        });
      } else {
        setState(() {
          _isBookmarked = false;
        });
      }
    }
  }



}

Widget buildSkeleton() {
  return Column(
    children: [
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Expanded(child: ClipCardSkeleton(height: 60, width: 60)),
            Expanded(child: ClipCardSkeleton(height: 60, width: 60)),
            Expanded(child: ClipCardSkeleton(height: 60, width: 60)),
          ],
        ),
      ),
      const SizedBox(height: 15),
      const ClipCardSkeleton(height: 150, width: 420),
      const SizedBox(height: 15),
      const ClipCardSkeleton(height: 250, width: 420),
      const SizedBox(height: 10),
      Center(child: const ClipCardSkeleton(height: 20, width: 150)),
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          ClipCardSkeleton(height: 20, width: 70),
          ClipCardSkeleton(height: 15, width: 50),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          ClipCardSkeleton(height: 100, width: 120),
          ClipCardSkeleton(height: 100, width: 120),
          ClipCardSkeleton(height: 100, width: 120),
        ],
      ),
      const SizedBox(height: 7),
    ],
  );
}

class ClipCardSkeleton extends StatelessWidget {
  const ClipCardSkeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
