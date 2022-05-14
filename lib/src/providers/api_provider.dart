

import 'package:dio/dio.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/models/youTube_video.dart';
import 'package:intl/intl.dart';

class RemoteAPI {

 static Future<List<Devotional>> getDevotionalsForMonth(monthYearName) async {
    var dio = Dio();
    final response = await dio.get('https://secret-place.herokuapp.com/api/devotionals?month=${monthYearName}',
        options: Options(responseType: ResponseType.json,
        followRedirects: false,
        validateStatus: (status) => true,));

    print(response.data);
    print(monthYearName);
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

}