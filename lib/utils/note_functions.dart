import 'package:elisha/src/models/note.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';

class NoteItemsRetrieveClass {
  static Future<String?> getNoteTitleForThisDay(String date) async {
    List<Note> notes = await DevotionalDBHelper.instance.getNotesFromDB();
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].date == date) {
        return notes[i].title;
      }
    }
    return null;
  }

  static Future<String?> getNoteWriteUpForThisDay(String date) async {
    List<Note> notes = await DevotionalDBHelper.instance.getNotesFromDB();
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].date == date) {
        return notes[i].writeUp;
      }
    }
    return null;
  }
}
