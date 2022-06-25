import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';

class BookMarkedDevotionalView extends StatefulWidget {
  const BookMarkedDevotionalView({Key? key}) : super(key: key);

  @override
  _BookMarkedDevotionalViewState createState() => _BookMarkedDevotionalViewState();
}


class _BookMarkedDevotionalViewState extends State<BookMarkedDevotionalView> {
  final controller = TextEditingController();
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
      ],
    );
  }
  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
      child: const ViewHeaderTwo(
        title: 'Bookmarked Devotional',
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
            hintText: 'Devotional title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            )
        ),
        //onChanged: searchStudyPlan,
      ),
    );
  }
  Widget _buildBookmarkedDevotionalList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Column(
                  children: <Widget>[
                    Card(
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8),),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fitWidth,
                                ),
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                    ),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Text('Topic'),
                        Spacer(),
                        Text('Date'),
                      ],
                    ),
                    Container(height: 10),
                    Text('Brief write-up'),
                    Container(height: 10),
                    Divider(height: 0),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
