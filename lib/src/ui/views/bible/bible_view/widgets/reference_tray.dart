import 'package:elisha/src/models/models.dart';
import 'package:elisha/src/providers/bible/controllers.dart';
import 'package:elisha/utils/bible_books.dart';
import 'widgets.dart';

class ReferenceTray extends StatefulWidget {
  const ReferenceTray({Key? key}) : super(key: key);

  @override
  State<ReferenceTray> createState() => _ReferenceTrayState();
}

class _ReferenceTrayState extends State<ReferenceTray> {
  BibleService controller = Get.find();
  int selectedBook = Get.find<BibleService>().reference.book.id - 1;

  @override
  Widget build(BuildContext context) {
    if (controller.isloading.value) {
      return const CircularProgressIndicator();
    } else {
      Map books = controller.getBooks();
      return BottomSheet(
        onClosing: () {},
        builder: (_) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select passage",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Scrollable(viewportBuilder: (context, pos) {
                          return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => setState(() {
                                  selectedBook = index;
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: index == selectedBook
                                        ? Colors.grey[300]
                                        : null,
                                    border: index != books.length - 1
                                        ? const Border(
                                            bottom:
                                                BorderSide(color: Colors.grey))
                                        : null,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    books.keys.toList()[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 36),
                      SizedBox(
                        width: 100,
                        child: ListView.builder(
                          itemCount: books[bibleBooks[selectedBook]].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.reference = controller.getChapter(
                                  book: Book(
                                    id: selectedBook + 1,
                                  ),
                                  chapter: index + 1,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      index == controller.reference.chapter - 1
                                          ? Colors.grey[300]
                                          : null,
                                  border: index != books.length - 1
                                      ? const Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))
                                      : null,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    books[bibleBooks[selectedBook]][index],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
