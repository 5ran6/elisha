import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/authentication_views/sign_in_providers_view/sign_in_providers_view.dart';
import 'package:elisha/src/ui/views/authentication_views/sign_up_view/sign_up_view.dart';
import 'package:elisha/src/ui/views/current_view.dart';
import 'package:elisha/src/ui/views/home_view/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationSelectionScreen extends StatefulWidget {
  const AuthenticationSelectionScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationSelectionScreenState createState() => _AuthenticationSelectionScreenState();
}

class _AuthenticationSelectionScreenState extends State<AuthenticationSelectionScreen> {
  bool showSignIn = true;
  bool isAnonymousUser = false;

  Future<void> isUserAnonymous() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedValue = prefs.getString('key');
    if (storedValue != null) {
      setState(() {
        isAnonymousUser == true;
      });
    }
  }

  void _toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  void initState() {
    isUserAnonymous();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData || isAnonymousUser) {
            return CurrentView();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else {
            if (showSignIn) {
              return SignInProvidersView(_toggleView);
            } else {
              return SignUpView(_toggleView);
            }
          }
        });
  }
}
