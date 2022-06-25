import 'package:canton_design_system/canton_design_system.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  final controller = TextEditingController();
  List notes = [];

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }
  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(),
       _searchBar(),
        _buildNoteList(context)
      ],
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
            )
        ),
        //onChanged: searchStudyPlan,
      ),
    );
  }
  Widget _buildNoteList(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
        itemBuilder: (context, index){
        return notes.length > 0 ? ListTile(
          title: Text('Note Title'),
          trailing: Text('Date'),
          onTap: () {},
        ) : Center(child: Text('No Notes Saved'));

        });
  }
}
