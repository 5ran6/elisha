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

import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/note_view/note_view.dart';
import 'package:elisha/src/ui/views/notes_list_view/notes_list_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/config/bottom_navigation_bar.dart';
import 'package:elisha/src/providers/bookmarked_chapters_provider.dart';
import 'package:elisha/src/providers/last_translation_book_chapter_provider.dart';
import 'package:elisha/src/providers/local_user_repository_provider.dart';
import 'package:elisha/src/providers/streaks_repository_provider.dart';
import 'package:elisha/src/ui/views/bible_view/bible_view.dart';
import 'package:elisha/src/ui/views/church_view/church_view.dart';
import 'package:elisha/src/ui/views/home_view/home_view.dart';
import 'package:elisha/src/ui/views/profile_view/profile_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _bibleNavigatorKey = GlobalKey<NavigatorState>();
final _noteNavigatorKey = GlobalKey<NavigatorState>();
final _churchNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

class CurrentView extends StatefulWidget {
  const CurrentView({Key? key}) : super(key: key);

  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) return;

    final isBackground = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;

    if (isBackground) {
      setDoNotDisturbOffWIthAppOnBackground();
    } else if (isClosed) {
      setDoNotDisturbOffWIthAppOnBackground();
    } else {
      setDoNotDisturbOnWIthAppOnForeground();
    }
  }

  void _onTabTapped(int index) {
    if (index == 3) {
      saveMessageClipViewLocationToSharedPref();
    } else {
      setDNDForTab();
    }
    // if (index == 2) {
    //   saveTodayDateToSharedPref();
    // }
    if (index == _currentIndex &&
        _currentIndex == 0 &&
        _homeNavigatorKey.currentState!.canPop()) {
      _homeNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex &&
        _currentIndex == 1 &&
        _bibleNavigatorKey.currentState!.canPop()) {
      _bibleNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex &&
        _currentIndex == 2 &&
        _noteNavigatorKey.currentState!.canPop()) {
      _noteNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex &&
        _currentIndex == 3 &&
        _churchNavigatorKey.currentState!.canPop()) {
      _churchNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex &&
        _currentIndex == 4 &&
        _profileNavigatorKey.currentState!.canPop()) {
      _profileNavigatorKey.currentState!.pop();
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _loadData() async {
    if (Platform.isAndroid) {
      setDoNotDisturbState();
    }
    await context.read(streaksRepositoryProvider).updateStreaks();
    context
        .read(localRepositoryProvider.notifier)
        .loadLastChapterAndTranslation();
    context.read(bookmarkedChaptersProvider.notifier).loadData();
    //  context.read(localUserRepositoryProvider.notifier).loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final _views = <Widget>[
      const HomeView(),
      const BibleView(),
      const NotesListView(),
      const ChurchView(),
      const ProfileView(),
    ];

    return WillPopScope(
      onWillPop: () => _handleBackButtonPress(context),
      child: CantonScaffold(
        safeArea: false,
        bottomNavBar: BottomNavBar(_currentIndex, _onTabTapped),
        padding: EdgeInsets.zero,
        backgroundColor: CantonMethods.alternateCanvasColorType2(
          context,
          index: _currentIndex,
          targetIndexes: [1],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            Navigator(
              key: _homeNavigatorKey,
              observers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  fullscreenDialog: true,
                  builder: (context) => SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: _views[_currentIndex],
                    ),
                  ),
                );
              },
            ),
            Navigator(
              key: _bibleNavigatorKey,
              observers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  fullscreenDialog: true,
                  builder: (context) => SafeArea(child: _views[_currentIndex]),
                );
              },
            ),
            Navigator(
              key: _noteNavigatorKey,
              observers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  fullscreenDialog: true,
                  builder: (context) => SafeArea(child: _views[_currentIndex]),
                );
              },
            ),
            Navigator(
              key: _churchNavigatorKey,
              observers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  fullscreenDialog: true,
                  builder: (context) => SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: _views[_currentIndex],
                    ),
                  ),
                );
              },
            ),
            Navigator(
              key: _profileNavigatorKey,
              observers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  fullscreenDialog: true,
                  builder: (context) => SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: _views[_currentIndex],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTodayDateToSharedPref() async {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('dd.MM.yyyy').format(now);

    final _prefs = await SharedPreferences.getInstance();

    await _prefs.setString('dateNavBarKey', todayDate);
  }

  Future<void> saveMessageClipViewLocationToSharedPref() async {
    final _prefs = await SharedPreferences.getInstance();

    await _prefs.setString('messageClipkey', "iAmInMessageClipPage");
  }

  Future<void> setDoNotDisturbState() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dndStatus = prefs.getBool('sharedPrefStatus') ?? false;

    if (Platform.isAndroid) {
      if (dndStatus) {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_NONE);
      } else {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_ALL);
      }
    }
  }

  Future<void> setDoNotDisturbOffWIthAppOnBackground() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dndStatus = prefs.getBool('sharedPrefStatus') ?? false;
    if (Platform.isAndroid) {
      if (dndStatus) {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_ALL);
      }
    }
  }

  Future<void> setDoNotDisturbOnWIthAppOnForeground() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dndStatus = prefs.getBool('sharedPrefStatus') ?? false;

    if (Platform.isAndroid) {
      if (dndStatus) {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_NONE);
      }
    }
  }

  Future<void> setDNDForTab() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dndStatus = prefs.getBool('sharedPrefStatus') ?? false;
    if (Platform.isAndroid) {
      if (dndStatus) {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_NONE);
      } else {
        await FlutterDnd.setInterruptionFilter(
            FlutterDnd.INTERRUPTION_FILTER_ALL);
      }
    }
  }

  _handleBackButtonPress(BuildContext context) {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      return Future<bool>.value(true);
    }
  }
}
