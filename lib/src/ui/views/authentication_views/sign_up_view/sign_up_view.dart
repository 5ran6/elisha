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

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/providers/authentication_providers/authentication_repository_provider.dart';
import 'package:elisha/src/ui/views/authentication_views/components/email_text_input.dart';
import 'package:elisha/src/ui/views/authentication_views/components/password_text_input.dart';
import 'package:elisha/src/ui/views/authentication_views/components/confirm_password_text_input.dart';
import 'package:elisha/src/ui/views/authentication_views/sign_up_view/components/first_name_input.dart';
import 'package:elisha/src/ui/views/authentication_views/sign_up_view/components/last_name_input.dart';
import 'package:elisha/src/ui/views/authentication_views/sign_up_view/components/sign_up_view_header.dart';

//enum to declare 3 state of button
enum ButtonState { init, requesting, completed }

class SignUpView extends StatefulWidget {
  const SignUpView(this.toggleView, {Key? key}) : super(key: key);

  final void Function() toggleView;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var _errorMessage = '';
  var _hasError = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool isAnimating = true;

  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.symmetric(horizontal: 27),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final isInit = isAnimating || state == ButtonState.init;
    final isDone = state == ButtonState.completed;

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            //TODO: not sure why it does not go back
            Row(
              children: [
                CantonBackButton(isClear: true, onPressed: widget.toggleView),
              ],
            ),
            const SignUpViewHeader(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FirstNameInput(firstNameController: _firstNameController),
                LastNameInput(lastNameController: _lastNameController),
              ],
            ),
            EmailTextInput(emailController: _emailController),
            PasswordTextInput(passwordController: _passwordController),
            ConfirmPasswordTextInput(confirmPasswordController: _passwordConfirmationController),
            _hasError ? const SizedBox(height: 15) : Container(),
            _hasError ? _errorText(context, _errorMessage) : Container(),
            isInit ? _signUpButton(context) : circularContainer(isDone),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Or Sign In',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    //SignInView(widget.toggleView!());
                    widget.toggleView();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Here',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            //const TermsAndPrivacyPolicyText(),
          ],
        ),
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
      child: CantonPrimaryButton(
        buttonText: 'Sign Up',
        textColor: CantonColors.white,
        color: Theme.of(context).primaryColor,
        containerWidth: 120,
        containerHeight: 40,
        padding: EdgeInsets.zero,
        borderRadius: CantonSmoothBorder.smallBorder().borderRadius,
        onPressed: () async {
          HapticFeedback.lightImpact();
          setState(() {
            state = ButtonState.requesting;
            isAnimating = !isAnimating;
          });
          if ([
            _emailController.text,
            _passwordController.text,
            _firstNameController.text,
            _lastNameController.text,
          ].contains('')) {
            setState(() {
              state = ButtonState.completed;
              isAnimating = !isAnimating;
              _hasError = true;
              _errorMessage = 'Missing fields';
            });
          } else if (_passwordController.text != _passwordConfirmationController.text) {
            setState(() {
              state = ButtonState.completed;
              isAnimating = !isAnimating;
              _hasError = true;
              _errorMessage = 'Password Mismatch';
            });
          } else {
            var res = await context.read(authenticationRepositoryProvider).signUp(
                  context: context,
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                );
            setState(() {
              state = ButtonState.completed;
              isAnimating = !isAnimating;
            });
            if (res != 'success') {
              setState(() {
                _hasError = true;
                _errorMessage = res;
              });
            }
          }
        },
      ),
    );
  }

  Widget circularContainer(bool done) {
    final color = done ? Colors.green : Colors.blue;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _errorText(BuildContext context, String error) {
    return Text(
      error,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.red,
          ),
    );
  }

// Future<void> _showBirthDatePicker() async {
//   final initialDate = DateTime.now();
//   final maximumYear = DateTime.now().year;
//   final firstDate = DateTime(1900);
//   final lastDate = DateTime.now();

//   return showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     elevation: 0,
//     useRootNavigator: true,
//     builder: (context) {
//       return FractionallySizedBox(
//         heightFactor: 0.40,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(top: 15, left: 27, right: 27),
//               child: Container(
//                 height: 5,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 27),
//               child: Text(
//                 'Select Your Birthday',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ),
//             const Divider(),
//             SizedBox(
//               height: 200,
//               child: Platform.isIOS
//                   ? CupertinoTheme(
//                       data: CupertinoThemeData(
//                         brightness: MediaQuery.of(context).platformBrightness,
//                       ),
//                       child: CupertinoDatePicker(
//                         mode: CupertinoDatePickerMode.date,
//                         initialDateTime: initialDate,
//                         minimumDate: firstDate,
//                         minimumYear: firstDate.year,
//                         maximumDate: initialDate,
//                         maximumYear: maximumYear,
//                         onDateTimeChanged: (date) {
//                           _birthDateController = date;
//                           setState(() {
//                             birthDateText = DateFormat.yMMMd().format(date);
//                           });
//                         },
//                       ),
//                     )
//                   : DatePickerDialog(
//                       initialDate: initialDate,
//                       firstDate: firstDate,
//                       lastDate: lastDate,
//                       initialCalendarMode: DatePickerMode.day,
//                       selectableDayPredicate: (date) {
//                         _birthDateController = date;
//                         setState(() {
//                           birthDateText = DateFormat.yMMMd().format(date);
//                         });
//                         return true;
//                       },
//                     ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Center(
//                 child: Text(
//                   'Save',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         color: Theme.of(context).primaryColor,
//                       ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
}
