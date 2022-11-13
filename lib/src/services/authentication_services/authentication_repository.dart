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
import 'package:dio/dio.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:elisha/src/config/authentication_exceptions.dart';
import 'package:elisha/src/models/local_user.dart';
import 'package:elisha/src/repositories/local_user_repository.dart';
import 'package:elisha/src/services/authentication_handlers/apple_sign_in.dart';
import 'package:elisha/src/services/authentication_handlers/google_sign_in.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../models/note.dart';
import '../devotionalDB_helper.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  AuthenticationRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> _updateLocalUser(LocalUser user) async {
    await LocalUserRepository().updateUser(user);
  }

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      // final localUser = LocalUser(firstName: firstName, lastName: lastName, email: email, birthDate: birthDate);

      // await _updateLocalUser(localUser);
      sendNoteGetRequestAndSaveNotesToDB();

      return 'success';
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, null);

      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'failed';
    }
  }

  Future<String> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      sendNoteGetRequestAndSaveNotesToDB();

      return 'success';
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, null);

      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'failed';
    }
  }

  Future<String> signInWithApple() async {
    return await handleAppleSignIn(_firebaseAuth);
  }

  Future<String> signInWithGoogle() async {
    return handleGoogleSignIn(_firebaseAuth);
  }

  Future<String> signUp({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      //final user = FirebaseAuth.instance.currentUser;

      // if (user != null && !user.emailVerified) {
      //   CantonMethods.viewTransition(context, const VerifyEmailView());

      //   var actionCodeSettings = ActionCodeSettings(
      //     url: 'https://elishaapp.page.link/?email=${user.email}',
      //     dynamicLinkDomain: 'elishaapp.page.link',
      //     androidPackageName: 'com.elisha.app',
      //     androidInstallApp: true,
      //     androidMinimumVersion: '12',
      //     iOSBundleId: 'com.elisha.app',
      //     handleCodeInApp: true,
      //   );

      //   await user.sendEmailVerification(actionCodeSettings);
      // }

      // final localUser = LocalUser(firstName: firstName, lastName: lastName, email: email, birthDate: birthDate);

      // await _updateLocalUser(localUser);

      return 'success';
    } on FirebaseAuthException catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      return e.message!;
    }
  }

  Future<String> signOut() async {
    try {
      //you can refactor to use Future.wait([futures]). Look at https://medium.com/flutter-africa/how-to-wait-for-the-future-s-in-dart-flutter-227933e97270
      await _firebaseAuth
          .signOut()
          .then((value) async => await LocalUserRepository()
              .removeUser()) //delete user metadata from hive
          .then((value) => handleGoogleSignOut(_firebaseAuth));
      return 'success';
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, null);

      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'failed';
    }
  }

  void sendNoteGetRequestAndSaveNotesToDB() async {
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user?.getIdToken();
    var dio1 = Dio();
    final response = await dio1.get('https://api.cpai-secretplace.com/api-secured/users/notes',
        options: Options(
            responseType: ResponseType.json,
            headers: {"Authorization": "Bearer $idToken"},
            followRedirects: false,
            validateStatus: (status) => true));

    var json = response.data;
    List<Note> notesFromServer = noteFromJson(json);
    DevotionalDBHelper.instance.insertNoteListFromApiIntoDB(notesFromServer);

  }
}
