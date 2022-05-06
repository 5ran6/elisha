

import 'package:dio/dio.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:intl/intl.dart';

class RemoteAPI {

 static Future<List<Devotional>> getDevotionalsForMonth(String monthYearName) async {
    var dio = Dio();
    final response = await dio.get('https://secret-place.herokuapp.com/api/devotionals?month=${monthYearName}', options: Options(responseType: ResponseType.json));

    var json = response.data;
    return devotionsFromJson(json);
  }

}