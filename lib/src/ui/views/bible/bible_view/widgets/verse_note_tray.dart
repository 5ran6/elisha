import 'package:elisha/src/models/models.dart';
import 'package:elisha/src/providers/bible/controllers.dart';
import 'widgets.dart';

class VerseNoteTray extends StatelessWidget {
  const VerseNoteTray({Key? key, required this.verse}) : super(key: key);
  final Verse verse;

  @override
  Widget build(BuildContext context) {
    BibleService controller = Get.find();
    TextEditingController noteController = TextEditingController();
    if (controller.isloading.value) {
      return const CircularProgressIndicator();
    } else {
      // prefController.getNote(ref: controller.reference);
      // noteController.text = prefController.note.value;
      return BottomSheet(
        onClosing: () {},
        builder: (_) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TrayHeader(title: "Note"),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 12,
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 4,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${controller.reference.book.name()} ${controller.reference.chapter}:${verse.id}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        verse.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      controller: noteController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        hintText: "Write a note on this verse",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // prefController.addNote(
                    //   ref: controller.reference,
                    //   note: noteController.text,
                    // );
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "SUBMIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
