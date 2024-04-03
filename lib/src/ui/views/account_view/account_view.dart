import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/authentication_views/auth_selection_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/providers/authentication_providers/authentication_repository_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        _header(context),
        user != null ? _userDetails(context) : Container(),
        _signOutButton(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return const ViewHeaderTwo(
      title: 'Account',
      backButton: true,
    );
  }

  Widget _userDetails(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? name = user?.displayName;
    String? email = user?.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        name != null
            ? CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
              )
            : Container(),
        const SizedBox(height: 8),
        name != null
            ? Text(
                name,
                style: Theme.of(context).textTheme.headline5,
              )
            : Container(),
        const SizedBox(height: 8),
        email != null
            ? Text(
                email,
                style: Theme.of(context).textTheme.headline5,
              )
            : Container(),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _signOutButton(BuildContext context) {
    return CantonPrimaryButton(
      buttonText: 'Sign Out',
      color: Theme.of(context).colorScheme.onError,
      textColor: Theme.of(context).colorScheme.error,
      borderRadius: CantonSmoothBorder.smallBorder().borderRadius,
      containerWidth: MediaQuery.of(context).size.width / 2 - 34,
      onPressed: () async {
        String response = await context.read(authenticationRepositoryProvider).signOut();
        if (response == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthenticationSelectionScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Failed signing out. Try again");
        }
      },
    );
  }
}
