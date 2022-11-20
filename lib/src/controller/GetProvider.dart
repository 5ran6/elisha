import 'package:elisha/src/models/note.dart';
import 'package:get/get_connect/connect.dart';

import '../services/devotionalDB_helper.dart';

class GetProvider extends GetConnect{

  Future<List<Note>> fetchNotes() async {
    List<Note> noteInLocalDatabase = await DevotionalDBHelper.instance.getNotesFromDB();

    return noteInLocalDatabase;
  }

}