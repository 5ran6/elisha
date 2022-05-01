

class RemoteAPI {

  Future<List<DevotionalModel>?> getDevotionals() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    var dio = Dio();
    final response = await dio.get('https://secret-place.herokuapp.com/api/devotionals?month=April2022');

    var json = response.data;
    return devotionalFromJson(json);
  }

}