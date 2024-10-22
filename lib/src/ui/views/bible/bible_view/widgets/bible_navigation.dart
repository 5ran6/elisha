import 'package:elisha/src/providers/bible/controllers.dart';
import 'widgets.dart';

class BibleNavigation extends StatelessWidget {
  const BibleNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<BibleService>(builder: (_) {
          BibleService controller = Get.find();
          return ReferenceButton(
            reference: controller.isloading.value
                ? "Please wait"
                : "${controller.reference.book.name()} ${controller.reference.chapter}",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return const ReferenceTray();
                },
              );
            },
          );
        }),
        const SizedBox(width: 2),
        GetBuilder<BibleService>(builder: (_) {
          BibleService controller = Get.find();
          return TranslationButton(
            translation: controller.selectedVersion.abbrv,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return const TranslationTray();
                },
              );
            },
          );
        })
      ],
    );
  }
}
