import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/note_view/note_header_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/note.dart';
import '../notes_list_view/notes_list_view.dart';

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
    DateTime now = DateTime.now();
    String todayDt = DateFormat('dd.MM.yyyy').format(now);
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
                    child: Text('Note', style: Theme.of(context).textTheme.headline3),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            CantonMethods.viewTransition(context, const NotesListView());
                          },
                          icon: Icon(Icons.notes)))
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
                          todayDt,
                          style: Theme.of(context).textTheme.headline4?.copyWith(
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
                          .headline4
                          ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino", fontSize: 21),
                      onChanged: (String str) async {
                        final _prefs = await SharedPreferences.getInstance();

                        await _prefs.setString('titleKey', str);
                      },
                      controller: noteTitleWidget,
                      textCapitalization: TextCapitalization.sentences,
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
                    child: Stack(
                      children: [
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino", fontSize: 17),
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
                        Align(
                            alignment: Alignment.topRight,
                            child:
                                IconButton(onPressed: _listen, icon: Icon(_islistening ? Icons.mic_off : Icons.mic))),
                      ],
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
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.headline4?.copyWith(
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
}
