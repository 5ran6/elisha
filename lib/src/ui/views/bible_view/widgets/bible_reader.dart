import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/chapter.dart';
import 'package:flutter/foundation.dart';

class BibleReader extends StatelessWidget {
  const BibleReader({Key? key, required this.chapter}) : super(key: key);

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsetsDirectional.only(top: 10.0, bottom: 40, start: 10.0, end: 10.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var verse = chapter.verses![index];
            return GestureDetector(
              onTap: () {
                //TODO: Add highlight feature
                if (kDebugMode) {
                  print("Highlight");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 21,
                          height: 1.97,
                        ),
                    children: [
                      TextSpan(
                        text: ' ${verse.verseId.toString()} ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                            ),
                      ),
                      TextSpan(text: verse.text),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: chapter.verses!.length,
        ),
      ),
    );
  }
}
