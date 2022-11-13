import 'package:dio/dio.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/models/youTube_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

import '../models/note.dart';
import '../services/devotionalDB_helper.dart';

class RemoteAPI {
  static String baseurl = 'https://api.cpai-secretplace.com/api';

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

  static Future<List<Note>> getUsersNotesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user?.getIdToken();

    var dio = Dio();
    final response = await dio.get('https://api.cpai-secretplace.com/api-secured/users/notes',
        options: Options(responseType: ResponseType.json,
          followRedirects: false,
          headers: {"Authorization": "Bearer $idToken"},
          validateStatus: (status) => true,));
    var json = response.data;
    return noteFromJson(json);
  }
  final getUsersNotes =
  FutureProvider.autoDispose<List<Note>?>((ref) => getUsersNotesFromFirebase());


  static Future<List<Devotional>> getDevotionalsForMonth(monthYearName) async {
    var dio = Dio();
    final response = await dio.get('$baseurl/devotionals?month=$monthYearName',
        options: Options(responseType: ResponseType.json,
        followRedirects: false,
        validateStatus: (status) => true,));
    var json = response.data;
    return devotionsFromJson(json);
  }

 static Future<List<YouTubeVideoModel>> getYouTubeVideos() async {
   var dio1 = Dio();
   final response1 = await dio1.get('$baseurl/videos',
     options: Options(responseType: ResponseType.json, followRedirects: false, validateStatus: (status) => true));

   var json = response1.data;
   return youTubeVideoFromJson(json);
 }

 static Future<List<DevotionalPlan>> getDevotionalPlans() async {
   try {
     var dio2 = Dio();
     final response2 = await dio2.get(
         '$baseurl/study-plans',
         options: Options(responseType: ResponseType.json,
             followRedirects: false,
             validateStatus: (status) => true));

     var json = response2.data;
     return devotionalPlansFromJson(json);
   } catch (e) {
     return [];
   }
 }

 static Future<DevotionalPlan> getDevotionalPlanWithID(studyPlanID) async {
   var dio3 = Dio();
   final response3 = await dio3.get('$baseurl/study-plans/$studyPlanID',
     options: Options(responseType: ResponseType.json, followRedirects: false, validateStatus: (status) => true));

   var json = response3.data;
   return devotionalPlanWithIDFromJson(json);
 }


}