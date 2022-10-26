import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/note_view/note_view.dart';
import 'package:elisha/src/ui/views/note_view/note_view_fromDB.dart';

import '../../../models/note.dart';
import '../../../providers/api_provider.dart';
import '../../../services/devotionalDB_helper.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  final controller = TextEditingController();

  var _noteList = List<Note>.empty();


  void fetchAndUpdateListOfNotes() async {
    List<Note> noteInLocalDatabase = await DevotionalDBHelper.instance.getNotesFromDB();
    setState(() {
      _noteList = noteInLocalDatabase;
    });
  }

  @override
  void initState() {
    fetchAndUpdateListOfNotes();
    super.initState();
  }

  void searchNote(String query) {
    final noteSuggestions = _noteList.where((note) {
      final noteTitle = note.title.toLowerCase();
      final input = query.toLowerCase();

      return noteTitle.contains(input);
    }).toList();

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
        child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const DevotionalNotePage()));
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
        backButton: true,
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
                separatorBuilder: (BuildContext context, int index) => Divider(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_noteList[index].title),
                    trailing: Text(_noteList[index].date),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DevotionalNotePage(noteId: _noteList[index].id)));
                    },
                  );
                })
            : Text(
                'No Notes Saved',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
      ],
    );
  }
}
