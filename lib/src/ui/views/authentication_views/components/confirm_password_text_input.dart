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

class ConfirmPasswordTextInput extends StatelessWidget {
  const ConfirmPasswordTextInput({Key? key, required this.confirmPasswordController}) : super(key: key);

  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: CantonTextInput(
        labelText: 'Confirm Password',
        hintText: '',
        isTextFormField: true,
        obscureText: true,
        controller: confirmPasswordController,
        textInputType: TextInputType.visiblePassword,
      ),
    );
  }
}
