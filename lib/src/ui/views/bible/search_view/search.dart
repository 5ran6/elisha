import 'package:elisha/src/models/models.dart';
import 'package:elisha/src/providers/bible/bible_service.dart';
import 'widgets/widgets.dart';

class SearchView extends GetView<BibleService> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBox(),
            const SizedBox(height: 32),
            Obx(
              () => controller.searchResult.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No search result"),
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        itemCount: controller.searchResult.length,
                        itemBuilder: (_, index) {
                          BibleReference ref = controller.searchResult[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                controller.reference = controller.getChapter(
                                  book: ref.book,
                                  chapter: ref.chapter,
                                );
                                Navigator.of(context).pop();
                              },
                              child: VerseWidget(ref: ref),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
