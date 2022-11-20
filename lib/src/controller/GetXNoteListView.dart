import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/controller/NoteController.dart';
import 'package:get/get.dart';

import '../models/note.dart';
import '../ui/views/note_view/note_view.dart';

class GetXNoteList extends GetView<NoteController> {
  const GetXNoteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  void searchNote(String query) {
    final noteSuggestions = controller.value?.where((note) {
      final noteTitle = note.title.toLowerCase();
      final input = query.toLowerCase();

      return noteTitle.contains(input);
    }).toList();

    List<Note>? notes = controller.value;

     notes = noteSuggestions;

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
        backButton: false,
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        //controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Note title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              //borderSide: BorderSide(color: Theme.of(context).primaryColor),
            )),
        onChanged: searchNote,
      ),
    );
  }
  Widget _buildNoteList(BuildContext context) {
    return controller.obx((data) => ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: data!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index].title),
            trailing: Text(data[index].date),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DevotionalNotePage(noteId: data[index].id)));
            },
          );
        })
    );
  }

}