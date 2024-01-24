import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/providers/api_provider.dart';

import 'package:elisha/src/ui/views/note_view/note_view.dart';
import 'package:flutter/foundation.dart';

import '../../../models/note.dart';
import '../../../services/devotionalDB_helper.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> with WidgetsBindingObserver {
  final controller = TextEditingController();

  var _noteList = List<Note>.empty();
  var _searchList = List<Note>.empty();

  void fetchAndUpdateListOfNotes() async {
    List<Note> noteInLocalDatabase = await DevotionalDBHelper.instance.getNotesFromDB();
    setState(() {
      _noteList = List.from(noteInLocalDatabase.reversed);
      _searchList = _noteList;
    });
  }

  @override
  void initState() {
    if (kDebugMode) {
      print("initState");
    }
    fetchAndUpdateListOfNotes();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("AppLifecycleState");
    }
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print("Resumed");
      }
      fetchAndUpdateListOfNotes();
    }
  }

  void searchNote(String query) {
    final noteSuggestions = query.isNotEmpty
        ? _searchList.where((note) {
            final noteTitle = note.title.toLowerCase();
            final input = query.toLowerCase();

            return noteTitle.contains(input);
          }).toList()
        : _searchList;

    setState(() {
      _noteList = noteSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).brightness == Brightness.light ? CantonColors.white : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DevotionalNotePage()));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_header(), _searchBar(), _buildNoteList(context)],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
      child: const ViewHeaderTwo(
        title: 'Notes',
        backButton: false,
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Note title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            )),
        onChanged: searchNote,
      ),
    );
  }

  Widget _buildNoteList(BuildContext context) {
    return Column(
      children: [
        _noteList.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _noteList[index].title,
                      style: Theme.of(context).brightness == Brightness.light
                          ? TextStyle(color: CantonColors.textPrimary)
                          : null,
                    ),
                    trailing: Text(_noteList[index].date),
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Delete"),
                        content: Text("Delete '${_noteList[index].title}'?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              try {
                                RemoteAPI.deleteNoteWithID(_noteList[index].id);
                                DevotionalDBHelper.instance.deleteSelectedNote(_noteList[index]);
                                setState(
                                  () {
                                    fetchAndUpdateListOfNotes();
                                    Navigator.of(context).pop();
                                  },
                                );
                              } on SocketException catch (e) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text("No internet!"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DevotionalNotePage(noteId: _noteList[index].id)));
                    },
                  );
                })
            : Text(
                'No Notes Saved',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
      ],
    );
  }
}
