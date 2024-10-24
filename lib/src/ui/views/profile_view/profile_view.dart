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
import 'package:elisha/src/providers/local_user_repository_provider.dart';
import 'package:elisha/src/ui/views/about_us_view/about_us_page.dart';
import 'package:elisha/src/ui/views/bookmarked_devotionals_list_view/bookmarked_devotionals_list_view.dart';
import 'package:elisha/src/ui/views/calendar_view/calendar_view.dart';
import 'package:elisha/src/ui/views/profile_view/feedback_dialog.dart';
import 'package:elisha/src/ui/views/settings_view/settings_view.dart';
import 'package:elisha/src/ui/views/users_manual/users_manual_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/ui/views/account_view/account_view.dart';
import 'package:elisha/src/ui/views/bookmarked_chapters_view/bookmarked_chapters_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [_header(context), _body(context)],
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: ViewHeaderTwo(
        title: 'Profile',
        textColor: Theme.of(context).colorScheme.primary,
        backButton: false,
        buttonOne: const CantonHeaderButton(),
      ),
    );
  }

  Widget _body(BuildContext context) {
    String? dbName = context.read(localUserRepositoryProvider).firstName;

    String name(String source) {
      if (source.length > 18) {
        return source.substring(0, 15) + '...';
      }
      return source;
    }

    return Column(
      children: [
        dbName != ''
            ? Text(name(dbName), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600))
            : Container(),
        const SizedBox(height: 10),
        // ..._statCards(context),
        const SizedBox(height: 10),
        ..._viewCards(context),
        const SizedBox(height: 10),
        ..._applicationCards(context),
      ],
    );
  }

  List<Widget> _viewCards(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const BookmarkedChaptersView());
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bookmarked Chapters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const BookMarkedDevotionalView());
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bookmarked Devotionals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _applicationCards(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const AccountView());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: SquircleBorder(
            radius: const BorderRadius.vertical(
              top: Radius.circular(37),
            ),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSecondary,
              width: 1.5,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, SettingsPage());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: Border(
            left: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            right: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      const Divider(),
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const CalendarView());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: Border(
            left: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            right: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              "Monthly Devotional",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      const Divider(),
      GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (_) => FeedbackDialog());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: Border(
            left: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            right: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Feedback',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      const Divider(),
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const AboutUsPage());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: Border(
            left: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            right: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'About us',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      const Divider(),
      GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, const UsersManualView());
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: Border(
            left: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            right: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'User Manual',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    ];
  }
}
