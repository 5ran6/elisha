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

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:elisha/src/config/authentication_exceptions.dart';

import '../../models/note.dart';
import '../devotionalDB_helper.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<String> handleAppleSignIn(FirebaseAuth firebaseAuth) async {
  try {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    await firebaseAuth.signInWithCredential(oauthCredential);

    sendNoteGetRequestAndSaveNotesToDB();

    print("signed in with apple successfully");
    return 'success';
  } catch (e) {
    await FirebaseCrashlytics.instance.recordError(e, null);
    print("sign in firebase error");

    if (e is FirebaseAuthException) {
      return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
    } else if (e is RangeError) {
      return '';
    }
    print("sign in with apple unsuccessful");
    return 'failed';
  }
}

void sendNoteGetRequestAndSaveNotesToDB() async {
  final user = FirebaseAuth.instance.currentUser;

  final idToken = await user?.getIdToken();
  var dio1 = Dio();
  final response = await dio1.get('https://cpai.guidetryb.com/api-secured/users/notes',
      options: Options(
          responseType: ResponseType.json,
          headers: {"Authorization": "Bearer $idToken"},
          followRedirects: false,
          validateStatus: (status) => true));

  var json = response.data;
  List<Note> notesFromServer = noteFromJson(json);
  DevotionalDBHelper.instance.insertNoteListFromApiIntoDB(notesFromServer);
}
