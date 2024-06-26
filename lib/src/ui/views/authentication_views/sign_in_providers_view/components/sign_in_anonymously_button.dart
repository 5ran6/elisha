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

import 'package:flutter/services.dart';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:elisha/src/providers/authentication_providers/authentication_repository_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInAnonymouslyButton extends StatelessWidget {
  const SignInAnonymouslyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonPrimaryButton(
      borderRadius: CantonSmoothBorder.smallBorder().borderRadius,
      buttonText: 'Continue anonymously',
      alignment: MainAxisAlignment.spaceAround,
      prefixIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Icon(LineAwesomeIcons.user, color: Theme.of(context).colorScheme.secondaryContainer),
      ),
      textColor: Theme.of(context).colorScheme.secondaryContainer,
      color: Theme.of(context).colorScheme.onSecondary,
      border: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.5,
      ),
      onPressed: () async {
        final _prefs = await SharedPreferences.getInstance();

         await _prefs.setString('key', 'anonymous');
        HapticFeedback.lightImpact();
        await context.read(authenticationRepositoryProvider).signInAnonymously();
      },
    );
  }
}
