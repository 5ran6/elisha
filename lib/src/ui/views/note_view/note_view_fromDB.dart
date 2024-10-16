import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/note.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/notes_list_view/notes_list_view.dart';
import 'package:elisha/utils/note_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class NoteViewFromDB extends StatefulWidget {
  final String dateNoteWasSaved;

  const NoteViewFromDB({Key? key, required this.dateNoteWasSaved}) : super(key: key);

  @override
  _NoteViewFromDBState createState() => _NoteViewFromDBState();
}

class _NoteViewFromDBState extends State<NoteViewFromDB> {
  String _title = "";
  String _writeUp = "";

  late SpeechToText _speech;
  bool _islistening = false;
  double confidence = 1.0;
  var noteWidget = TextEditingController();
  var noteTitleWidget = TextEditingController();
  String newWords = "";

  @override
  void initState() {
    _speech = SpeechToText();
    getTitleAsString(widget.dateNoteWasSaved);
    getWriteUpAsString(widget.dateNoteWasSaved);

    noteTitleWidget.text = _title;
    noteWidget.text = _writeUp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Note', style: Theme.of(context).textTheme.displaySmall),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          IconButton(onPressed: _listen, icon: Icon(_islistening ? Icons.mic_off : Icons.mic)),
                          IconButton(
                              onPressed: () {
                                CantonMethods.viewTransition(context, const NotesListView());
                              },
                              icon: Icon(Icons.notes)),
                        ],
                      ))
                ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 15,
                    color: Colors.black87,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.dateNoteWasSaved,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21, color: Colors.white),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                      //initialValue: _title;
                      controller: noteTitleWidget..text = _title,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true, labelText: 'Title', border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: 17),
                      minLines: 30,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      controller: noteWidget..text = _writeUp,
                      //initialValue: _writeUp,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true, labelText: 'Note', border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                  onTap: () async {
                    DateTime now = DateTime.now();
                    String todayDate = DateFormat('dd.MM.yyyy').format(now);
                    Note note =
                        Note(title: noteTitleWidget.text, writeUp: noteWidget.text, date: widget.dateNoteWasSaved);

                    List<Note> notes = await DevotionalDBHelper.instance.getNotewithDate(widget.dateNoteWasSaved);
                    if (notes.isNotEmpty) {
                      DevotionalDBHelper.instance.updateNote(note);
                      if (user != null) {
                        sendNotePutRequest(note);
                      }
                    } else {
                      DevotionalDBHelper.instance.insertNote(note);
                      if (user != null) {
                        sendNotePostRequest(note);
                      }
                    }
                    Fluttertoast.showToast(
                        msg: "Note Saved", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontFamily: "Palatino",
                                fontSize: 22,
                                color: Colors.white),
                          ))))
            ],
          ),
        ),
      ),
    );
  }

  void sendNotePostRequest(Note note) async {
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user?.getIdToken();
    final response = await http.post(Uri.parse("https://secret-place.herokuapp.com/api-secured/users/notes"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(note));
  }

  void sendNotePutRequest(Note note) async {
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user?.getIdToken();
    final response = await http.put(Uri.parse("https://secret-place.herokuapp.com/api-secured/users/notes"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(note));
  }

  void _listen() async {
    if (!_islistening) {
      bool available = await _speech.initialize(
          onStatus: (val) => setState(() {
                if (val == 'listening') {
                  _islistening = true;
                } else if (val == 'done') {
                  noteWidget.text = noteWidget.text == "" ? newWords : noteWidget.text + newWords;
                } else {
                  _islistening = false;
                }
              }),
          onError: (val) => print('onError: $val'));
      if (available) {
        setState(() => _islistening = true);
        _speech.listen(
          onResult: (val) => setState(() => newWords = val.recognizedWords),
        );
      }
    } else {
      setState(() => _islistening = false);
      _speech.stop();
    }
  }

  getTitleAsString(String dt) async {
    var title = await NoteItemsRetrieveClass.getNoteTitleForThisDay(dt);
    setState(() {
      _title = title!;
      //noteTitleWidget.text = title;
    });
  }

  getWriteUpAsString(String dt) async {
    var writeUp = await NoteItemsRetrieveClass.getNoteWriteUpForThisDay(dt);
    setState(() {
      _writeUp = writeUp!;
      //noteWidget.text = writeUp;
    });
  }
}
