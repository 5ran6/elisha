import 'package:elisha/src/providers/bible/bible_service.dart';
import 'widgets.dart';

class ReaderView extends GetView<BibleService> {
  const ReaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isloading.value) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(),
                ),
                Text("Please wait...")
              ],
            ),
          ),
        );
      } else {
        return GetBuilder<BibleService>(builder: (context) {
          return SliverPadding(
            padding: const EdgeInsetsDirectional.only(top: 10.0, bottom: 40, start: 10.0, end: 10.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return VerseWidget(verse: controller.reference.verses[index]);
                },
                childCount: controller.reference.verses.length,
              ),
            ),
          );
        });
      }
    });
  }
}
