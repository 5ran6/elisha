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
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:elisha/src/models/daily_reading.dart';
import 'package:elisha/src/models/reading.dart';

class DailyReadingsView extends StatelessWidget {
  const DailyReadingsView(this.dailyReading, {Key? key}) : super(key: key);

  final DailyReading dailyReading;

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return ListView(
      children: [
        _header(context),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._body(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderTwo(
      backButton: true,
      title: 'Daily Readings',
      buttonTwo: CantonActionButton(
        icon: RotatedBox(
          quarterTurns: 2,
          child: Icon(
            Iconsax.info_circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          _showInfoBottomSheet(context);
        },
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    List<Widget> children = [
      Text(
        dailyReading.name!,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 5),
      Text(
        'Lectionary: ' + dailyReading.lectionary!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
      ),
      const SizedBox(height: 30),
    ];

    for (int i = 0; i < dailyReading.readings!.length; i++) {
      children.add(
        _readingCard(
          context,
          dailyReading.readings![i],
        ),
      );
      if (i != dailyReading.readings!.length - 1) {
        children.add(const SizedBox(height: 30));
      }
    }

    return children;
  }

  Widget _readingCard(BuildContext context, Reading reading) {
    return Column(
      children: [
        Row(
          children: [
            Text(reading.name!, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reading.snippetAddress!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
              ),
            ),
          ],
        ),
        const Divider(height: 20),
        Text(
          reading.text!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                height: 1.65,
              ),
        ),
      ],
    );
  }

  Future<void> _showInfoBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 15),
          child: FractionallySizedBox(
            heightFactor: 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 27, right: 27),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                              ),
                        ),
                      ),
                      const Spacer(flex: 7),
                      Text(
                        'Info',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(flex: 10),
                    ],
                  ),
                ),
                const Divider(height: 30),
                Container(
                  padding: const EdgeInsets.only(top: 15, left: 27, right: 27),
                  child: Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text:
                        'Daily Readings is courtesy of the United States Conference of Catholic Bishops © 2021. Their Website is located at https://bible.usccb.org',
                    style: Theme.of(context).textTheme.titleLarge,
                    linkStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
