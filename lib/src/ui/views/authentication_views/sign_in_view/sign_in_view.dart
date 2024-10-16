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

import 'package:elisha/src/providers/authentication_providers/authentication_repository_provider.dart';
import 'package:elisha/src/ui/components/terms_and_privacy_policy_text.dart';
import 'package:elisha/src/ui/views/authentication_views/components/dont_have_an_account_text.dart';
import 'package:elisha/src/ui/views/authentication_views/components/email_text_input.dart';
import 'package:elisha/src/ui/views/authentication_views/components/password_text_input.dart';
import 'package:elisha/src/ui/views/authentication_views/components/sign_in_view_header.dart';

//enum to declare 3 state of button
enum ButtonState { init, requesting, completed }

class SignInView extends StatefulWidget {
  const SignInView(this.toggleView, this.toggleEmailSignIn, {Key? key}) : super(key: key);

  final void Function() toggleView;
  final void Function() toggleEmailSignIn;

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _errorMessage = '';
  bool _hasError = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
            //   const SizedBox(height: 20),
            Row(
              children: [
                CantonBackButton(isClear: true, onPressed: widget.toggleEmailSignIn),
              ],
            ),
            const SizedBox(height: 50),
            const SignInViewHeader(),
            EmailTextInput(emailController: _emailController),
            PasswordTextInput(passwordController: _passwordController),
            _hasError ? const SizedBox(height: 15) : Container(),
            _hasError ? _errorText(context, _errorMessage) : Container(),
            isInit ? _signInButton(context) : circularContainer(isDone),
            DontHaveAnAccountText(toggleView: widget.toggleView),
            const Expanded(child: Align(alignment: FractionalOffset.bottomCenter, child: TermsAndPrivacyPolicyText())),
          ],
        ),
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

  Widget _signInButton(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
      child: CantonPrimaryButton(
        containerWidth: 120,
        containerHeight: 40,
        borderRadius: const SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        buttonText: 'Sign In',
        textColor: CantonColors.white,
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          HapticFeedback.lightImpact();
          //loading state start

          setState(() {
            state = ButtonState.requesting;
            isAnimating = !isAnimating;
          });
          var value = await context.read(authenticationRepositoryProvider).signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

          //loading state stop
          setState(() {
            state = ButtonState.completed;
            isAnimating = !isAnimating;
          });
          if (value != 'success') {
            setState(() {
              _hasError = true;
              _errorMessage = value;
            });
          }
        },
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
}
