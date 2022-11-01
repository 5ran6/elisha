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

import 'package:dio/dio.dart';
import 'package:elisha/src/models/note.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:elisha/src/config/authentication_exceptions.dart';
import 'package:http/http.dart' as http;

Future<String> handleGoogleSignIn(FirebaseAuth firebaseAuth) async {
  try {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return '';

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await firebaseAuth.signInWithCredential(credential);

    sendNoteGetRequestAndSaveNotesToDB();

    return 'success';
  } catch (e) {
    await FirebaseCrashlytics.instance.recordError(e, null);

    if (e is FirebaseAuthException) {
      return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
    } else if (e is RangeError) {
      return '';
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
  print('josn..................');
  print(json);
  print(response.statusCode);
  List<Note> notesFromServer = noteFromJson(json);
  DevotionalDBHelper.instance.insertNoteListFromApiIntoDB(notesFromServer);

  print(notesFromServer);

}
