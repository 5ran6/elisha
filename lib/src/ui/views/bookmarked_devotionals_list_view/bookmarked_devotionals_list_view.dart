import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page_from_boomark.dart';

import '../../../models/devotional.dart';

class BookMarkedDevotionalView extends StatefulWidget {
  const BookMarkedDevotionalView({Key? key}) : super(key: key);

  @override
  _BookMarkedDevotionalViewState createState() => _BookMarkedDevotionalViewState();
}

class _BookMarkedDevotionalViewState extends State<BookMarkedDevotionalView> {
  final controller = TextEditingController();

  var _devBookmarkedList = List<Devotional>.empty();
  var _searchList = List<Devotional>.empty();

  void fetchAndUpdateListOfBookmarkedDevotionals() async {
    List<Devotional> bookmarkedDevsInDatabase = await DevotionalDBHelper.instance.getBookMarkedDevotionalsFromDB();
    setState(() {
      _devBookmarkedList = bookmarkedDevsInDatabase;
      _searchList = _devBookmarkedList;
    });
  }

  @override
  void initState() {
    fetchAndUpdateListOfBookmarkedDevotionals();
    super.initState();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _header(),
          _searchBar(),
          _devBookmarkedList.isNotEmpty
              ? _buildBookmarkedDevotionalList()
              : Text(
                  'No Bookmarked Devotional',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
        ],
      ),
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
          ),
        ),
        onChanged: searchBookmark,
      ),
    );
  }

  void searchBookmark(String query) {
    final bookmarkSuggestions = query.isNotEmpty
        ? _searchList.where((bookmark) {
            final bookmarkTitle = bookmark.title.toLowerCase();
            final input = query.toLowerCase();

            return bookmarkTitle.contains(input);
          }).toList()
        : _searchList;

    setState(() {
      _devBookmarkedList = bookmarkSuggestions;
    });
  }

  Widget _buildBookmarkedDevotionalList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _devBookmarkedList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DevotionalPageFromBookmark(bookmarkedDevotionalDate: _devBookmarkedList[index].date)));
            },
            child: Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Column(
                  children: <Widget>[
                    Card(
                        margin: EdgeInsets.all(5.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        //clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: _devBookmarkedList[index].image,
                          imageBuilder: (context, imageProvider) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Text(
                          _devBookmarkedList[index].title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(_devBookmarkedList[index].date,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    Container(height: 10),
                    Text(
                      _devBookmarkedList[index].fullText,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(height: 10),
                    const Divider(height: 0),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
