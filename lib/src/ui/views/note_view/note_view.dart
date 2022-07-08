import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/note_view/note_header_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/note.dart';

class DevotionalNotePage extends StatefulWidget {
  const DevotionalNotePage({Key? key}) : super(key: key);

  @override
  _DevotionalNotePageState createState() => _DevotionalNotePageState();
}

class _DevotionalNotePageState extends State<DevotionalNotePage> {
  late SpeechToText _speech;
  bool _islistening = false;
  double confidence = 1.0;
  var noteWidget = TextEditingController();
  var noteTitleWidget = TextEditingController();
  String newWords = "";

  Future<void> getNoteTileAndContent() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedTitle = prefs.getString('titleKey');
    final String? storedNote = prefs.getString('noteKey');
    final String? storedClear = prefs.getString('clearKey');
    final String? storedDateNavBar = prefs.getString('dateNavBarKey');
    final String? storedDateSave = prefs.getString('dateSaveKey');

    if (storedTitle != null || storedDateNavBar == storedDateSave) {
      setState(() {
        noteTitleWidget.text = storedTitle!;
      });
    } else {
      noteTitleWidget.clear();
    }
    if (storedNote != null || storedDateNavBar == storedDateSave) {
      setState(() {
        noteWidget.text = storedNote!;
      });
    } else {
      noteWidget.clear();
    }
  }

  @override
  void initState() {
    getNoteTileAndContent();
    super.initState();
    _speech = SpeechToText();
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Note', style: Theme.of(context).textTheme.headline3),
                  ),
                  Expanded(
                      child: Align(
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
                  )
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
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Topic | Date',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      onChanged: (String str) async {
                        final _prefs = await SharedPreferences.getInstance();

                        await _prefs.setString('titleKey', str);
                      },
                      controller: noteTitleWidget,
                      keyboardType: TextInputType.text,
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
                      onChanged: (String str) async {
                        final _prefs = await SharedPreferences.getInstance();

                        await _prefs.setString('noteKey', str);
                      },
                      minLines: 30,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      controller: noteWidget,
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
                    String todayDt = DateFormat('dd.MM.yyyy').format(now);

                    final _prefs = await SharedPreferences.getInstance();
                    await _prefs.setString('clearKey', 'clearNoteTitleAndReview');
                    await _prefs.setString('dateSaveKey', todayDt);

                    Note note = Note(title: noteTitleWidget.text, writeUp: noteWidget.text, date: todayDt);

                    List<Note> notes = await DevotionalDBHelper.instance.getNotewithDate(todayDt);
                    if (notes.isNotEmpty) {
                      DevotionalDBHelper.instance.updateNote(note);
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
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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

  void _listen() async {
    if (!_islistening) {
      bool available = await _speech.initialize(
          onStatus: (val) => setState(() {
                if (val == 'listening') {
                  _islistening = true;
                  Fluttertoast.showToast(
                      msg: "Mic started", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                } else if (val == 'done') {
                  noteWidget.text = noteWidget.text == "" ? newWords : noteWidget.text + newWords;
                } else {
                  _islistening = false;
                  Fluttertoast.showToast(
                      msg: "Tap microphone to speak again",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM);
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
}
