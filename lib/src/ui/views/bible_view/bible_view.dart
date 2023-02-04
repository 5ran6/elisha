/*
Elisha iOS & Android App
Copyright (C) 2021 Elisha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/config/exceptions.dart';
import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/chapter.dart';
import 'package:elisha/src/models/translation.dart';
import 'package:elisha/src/providers/bible_books_provider.dart';
import 'package:elisha/src/services/bible_service.dart';
import 'package:elisha/src/providers/bible_chapters_provider.dart';
import 'package:elisha/src/providers/bible_repository_provider.dart';
import 'package:elisha/src/providers/bible_translations_provider.dart';
import 'package:elisha/src/providers/bookmarked_chapters_provider.dart';
import 'package:elisha/src/providers/last_translation_book_chapter_provider.dart';
import 'package:elisha/src/ui/components/error_body.dart';
import 'package:elisha/src/ui/components/unexpected_error.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class BibleView extends StatefulWidget {
  final String? biblePassage;

  const BibleView({this.biblePassage});

  @override
  _BibleViewState createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  //var passage = "Ephesians 6:11-17";
  bool isBookmarked = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.biblePassage != null) {
      context.read(bibleRepositoryProvider).changeChapter(
          context,
          BibleService.getBookIdFromPassageString(widget.biblePassage),
          BibleService.getChapterIdFromPassageString(widget.biblePassage));
    }
    return Consumer(
      builder: (context, watch, child) {
        final translationRepo = watch(bibleTranslationsProvider);
        final booksRepo = watch(bibleBooksProvider);
        final chaptersRepo = watch(bibleChaptersProvider);

        return translationRepo.when(
          error: (e, s) {
            FirebaseCrashlytics.instance.recordError(e, null);
            if (e is Exceptions) {
              return ErrorBody(e.message, bibleTranslationsProvider);
            }
            return UnexpectedError(bibleTranslationsProvider);
          },
          loading: () => Container(),
          data: (translations) {
            return booksRepo.when(
              error: (e, s) {
                FirebaseCrashlytics.instance.recordError(e, null);
                if (e is Exceptions) {
                  return ErrorBody(e.message, bibleBooksProvider);
                }
                return UnexpectedError(bibleBooksProvider);
              },
              loading: () => Container(),
              data: (books) {
                return chaptersRepo.when(
                  error: (e, s) {
                    FirebaseCrashlytics.instance.recordError(e, null);
                    if (e is Exceptions) {
                      return ErrorBody(e.message, bibleChaptersProvider);
                    }
                    return UnexpectedError(bibleChaptersProvider);
                  },
                  loading: () => Container(),
                  data: (chapter) {
                    isBookmarked = context
                        .read(bookmarkedChaptersProvider)
                        .contains(chapter);
                    return _content(
                      context,
                      translations,
                      books,
                      chapter,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _content(BuildContext context, List<Translation> translations,
      List<Book> books, Chapter chapter) {
    List<Widget> children = [const SizedBox(height: 10)];
    List<InlineSpan> spans = [];
    children.add(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Text.rich(
          TextSpan(
            children: spans,
          ),
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 21,
                height: 1.97,
              ),
        ),
      ),
    );
    for (int i = 0; i < chapter.verses!.length; i++) {
      var item = chapter.verses![i];

      spans.add(
        TextSpan(
          text: item.verseId.toString() + ' ',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
        ),
      );

      spans.add(TextSpan(text: item.text));

      if (!(i == chapter.verses!.length - 1)) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    children.add(const SizedBox(height: 40));

    Widget reader() {
      return SliverToBoxAdapter(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            HapticFeedback.lightImpact();

            setState(() {
              bool dir = details.delta.dx < 0 ? false : true;
              context
                  .read(bibleRepositoryProvider)
                  .goToNextPreviousChapter(context, dir);
            });
          },
          child: Column(children: children),
        ),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [_header(context, translations, books, chapter), reader()],
      ),
    );
  }

  Widget _header(BuildContext context, List<Translation> translations,
      List<Book> books, Chapter chapter) {
    // ignore: unused_element
    Widget _quickChapterNavigationControls(BuildContext context) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();

              context
                  .read(bibleRepositoryProvider)
                  .goToNextPreviousChapter(context, true);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.arrow_left_2,
                size: 20,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
          ),
          const SizedBox(width: 7),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();

              context
                  .read(bibleRepositoryProvider)
                  .goToNextPreviousChapter(context, false);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.arrow_right_3,
                size: 20,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
          ),
        ],
      );
    }

    Widget _previousChapterButton(BuildContext context) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          context
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(context, true);
        },
        child: Icon(
          FeatherIcons.chevronLeft,
          size: 27,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
      );
    }

    Widget _nextChapterButton(BuildContext context) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          context
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(context, false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Icon(
            FeatherIcons.chevronRight,
            size: 27,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
        ),
      );
    }

    Widget _chapterVerseTranslationControls(
      BuildContext context,
      List<Translation> translations,
      List<Book> books,
      Chapter chapter,
    ) {
      var bookChapterTitle =
          chapter.verses![0].book.name! + ' ' + chapter.number!;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // _readerSettingsButton(context),
          const SizedBox(width: 40),
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();

              await _showBookAndChapterBottomSheet();
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ShapeDecoration(
                shape: const SquircleBorder(
                  radius: BorderRadius.horizontal(left: Radius.circular(20)),
                ),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                bookChapterTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            // onTap: () async {
            //   HapticFeedback.lightImpact();
            //
            //   await _showTranslationsBottomSheet(translations);
            // },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ShapeDecoration(
                shape: const SquircleBorder(
                  radius: BorderRadius.horizontal(right: Radius.circular(20)),
                ),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                translations
                    .where((element) =>
                        element.abbreviation.toLowerCase() ==
                        translationID.toLowerCase())
                    .first
                    .abbreviation,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 40),
          _bookmarkButton(context, chapter),
        ],
      );
    }

    return SliverAppBar(
      centerTitle: true,
      floating: true,
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      title: _chapterVerseTranslationControls(
          context, translations, books, chapter),
      leading: _previousChapterButton(context),
      actions: [
        _nextChapterButton(context),
      ],
    );
  }

  Widget _bookmarkButton(BuildContext context, Chapter chapter) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();

        if (isBookmarked == false) {
          context
              .read(bookmarkedChaptersProvider.notifier)
              .bookmarkChapter(chapter);
        } else {
          context
              .read(bookmarkedChaptersProvider.notifier)
              .removeChapter(chapter);
        }

        setState(() {
          isBookmarked = !isBookmarked;
        });
      },
      child: Container(
        color: CantonMethods.alternateCanvasColor(context),
        child: Icon(
          isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
          size: 24,
          color: isBookmarked
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.secondaryVariant,
        ),
      ),
    );
  }

  Widget _readerSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        color: CantonMethods.alternateCanvasColor(context),
        child: Icon(
          FeatherIcons.settings,
          size: 24,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
      ),
    );
  }

  Future<void> _showBookAndChapterBottomSheet() async {
    List<Book> books = await BibleService().getBooks('');

    Widget _bookCard(Book book) {
      Widget _chapterCard(ChapterId chapter) {
        return GestureDetector(
          onTap: () {
            context
                .read(bibleRepositoryProvider)
                .changeChapter(context, book.id!, chapter.id!);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: SquircleBorder(
                radius: BorderRadius.circular(20),
                side: BorderSide(
                  width: 1.5,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            child: Center(
              child: Text(
                chapter.id.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        );
      }

      return CantonExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(horizontal: 17),
        title: Text(book.name!, style: Theme.of(context).textTheme.headline6),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: book.chapters!.length,
              itemBuilder: (context, index) =>
                  _chapterCard(book.chapters![index]),
            ),
          ),
        ],
      );
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15, left: 27, right: 27),
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 27),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                      ),
                    ),
                    const Spacer(flex: 6),
                    Text(
                      'Books',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Spacer(flex: 9),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _bookCard(books[index]),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showTranslationsBottomSheet(
      List<Translation> translations) async {
    Widget _translationCard(Translation translation, int index) {
      Future<bool> _bibleTranslationHasBeenDownloaded(
          Translation translation) async {
        var _path = (await getExternalStorageDirectory())!.path;
        String _localPath = '$_path/${translation.abbreviation}.json';
        final savedJSON = File(_localPath);
        return await savedJSON.exists();
      }

      Future<void> _downloadBibleTranslation(
          Translation translation, Function callback) async {
        print(
            "started downloading bible translation " + translation.toString());

        var _path = (await getExternalStorageDirectory())!.path;
        var file = await File('$_path/${translation.abbreviation}.json')
            .create(recursive: true);
        print("file TO BE CREATED ");
        print(file);
        var options = DownloaderUtils(
          progressCallback: (current, total) {
            final progress = (current / total) * 100;
            print('Downloading: $progress');
          },
          file: file,
          progress: ProgressImplementation(),
          onDone: () {
            print('COMPLETE');
            callback();
          },
          deleteOnCancel: true,
        );
        print("about to call dwnload");
        print(translation);
        final core = await Flowder.download(translation.downloadUrl!, options);
        core.resume();
      }

      return GestureDetector(
        onTap: () async {
          var bibleTranslationHasBeenDownloaded =
              await _bibleTranslationHasBeenDownloaded(translation);
          if (!bibleTranslationHasBeenDownloaded) {
            //setDownloadState true
            await _downloadBibleTranslation(translation, () {
              setState(() {
                context
                    .read(localRepositoryProvider.notifier)
                    .changeBibleTranslation(
                      index - 1,
                      translation.abbreviation,
                    );

                context.refresh(bibleChaptersProvider);
              });

              Navigator.of(context, rootNavigator: true).pop();
            });
            //setDownloadState false
          } else {
            setState(() {
              context
                  .read(localRepositoryProvider.notifier)
                  .changeBibleTranslation(
                    index - 1,
                    translation.abbreviation,
                  );

              context.refresh(bibleChaptersProvider);
            });

            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 17),
          title: Text(
            translation.name!,
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: Text(
            translation.language!,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
          ),
        ),
      );
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15, left: 27, right: 27),
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 27),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                      ),
                    ),
                    const Spacer(flex: 6),
                    Text(
                      'Versions',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Spacer(flex: 9),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: ListView.builder(
                  itemCount: translations.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (index == 0) const Divider(),
                        _translationCard(translations[index], index + 1),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
