import 'package:elisha/src/providers/bible/controllers.dart';
import 'package:elisha/utils/text.dart';
import 'package:elisha/utils/versions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationTray extends StatefulWidget {
  const TranslationTray({Key? key}) : super(key: key);

  @override
  State<TranslationTray> createState() => _TranslationTrayState();
}

class _TranslationTrayState extends State<TranslationTray> {
  int selectedVersion = 0;
  @override
  Widget build(BuildContext context) {
    BibleService controller = Get.find();
    if (controller.isloading.value) {
      return const CircularProgressIndicator();
    } else {
      int selectedVersion = versions.indexOf(controller.selectedVersion);
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
                      "Select translation",
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
                  child: ListView.builder(
                    itemCount: versions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.changeVersion(versions[index]);
                          Navigator.of(context).pop();
                          if (versions[index].abbrv.endsWith("s")) {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Warning",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    content: const Text(
                                      Texts.STRONGS_NOT_DONE,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text("OKAY"),
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: index == selectedVersion ? Colors.grey[300] : null,
                            border: index != versions.length - 1
                                ? const Border(bottom: BorderSide(color: Colors.grey))
                                : null,
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                versions[index].fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "(${versions[index].abbrv})",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
