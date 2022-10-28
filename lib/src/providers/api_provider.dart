

import 'package:dio/dio.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/models/youTube_video.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

class RemoteAPI {
  static Future<List<Note>> getUsersNotesFromFirebase() async {
    var dio = Dio();
    final response = await dio.get('https://secret-place.herokuapp.com/api-secured/users/notes',
        options: Options(responseType: ResponseType.json,
          followRedirects: false,
          validateStatus: (status) => true,));
    var json = response.data;
    return noteFromJson(json);

  }

 static Future<List<Devotional>> getDevotionalsForMonth(monthYearName) async {
    var dio = Dio();
    final response = await dio.get('https://secret-place.herokuapp.com//api/devotionals?month=${monthYearName}',
        options: Options(responseType: ResponseType.json,
        followRedirects: false,
        validateStatus: (status) => true,));
    var json = response.data;
    return devotionsFromJson(json);
  }

 static Future<List<YouTubeVideoModel>> getYouTubeVideos() async {
   var dio1 = Dio();
   final response1 = await dio1.get('https://secret-place.herokuapp.com/api/videos',
     options: Options(responseType: ResponseType.json, followRedirects: false, validateStatus: (status) => true));

   var json = response1.data;
   return youTubeVideoFromJson(json);
 }

 static Future<List<DevotionalPlan>> getDevotionalPlans() async {
   try {
     var dio2 = Dio();
     final response2 = await dio2.get(
         'https://secret-place.herokuapp.com/api/study-plans',
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
   final response3 = await dio3.get('https://secret-place.herokuapp.com/api/study-plans/${studyPlanID}',
       options: Options(responseType: ResponseType.json, followRedirects: false, validateStatus: (status) => true));

   var json = response3.data;
   return devotionalPlanWithIDFromJson(json);
 }


}