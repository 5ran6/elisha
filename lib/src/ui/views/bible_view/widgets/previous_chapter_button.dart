import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/providers/bible_repository_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviousChapterButton extends StatelessWidget {
  const PreviousChapterButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();

        context.read(bibleRepositoryProvider).goToNextPreviousChapter(context, true);
      },
      child: Icon(
        FeatherIcons.chevronLeft,
        size: 27,
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}
