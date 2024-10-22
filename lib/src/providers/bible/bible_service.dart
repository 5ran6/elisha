import 'dart:convert';
import 'package:elisha/src/models/bible/models.dart';
import 'package:elisha/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BibleService extends GetxController {
  RxBool isloading = false.obs;
  final _data = {}.obs;
  Version selectedVersion = versions[0];
  RxBool isChanged = false.obs;
  late BibleReference reference;
  RxList searchResult = [].obs;

  void loadBible() async {
    isloading.value = true;
    final String response = await rootBundle.loadString('assets/bible.json');
    _data.value = await json.decode(response);
    reference = getChapter(book: const Book(id: 1), chapter: 1);
    isloading.value = false;
  }

  void changeVersion(Version version) {
    selectedVersion = version;
    reference = getChapter(book: reference.book, chapter: reference.chapter);
    update();
  }

  void search(String value) {
    Map dt = _data[selectedVersion.dbName];
    searchResult.value = [];
    if (value.isNotEmpty) {
      dt.forEach(
        (book, chapterData) {
          chapterData.forEach(
            (chapter, verseData) {
              verseData.forEach((verseId, verse) {
                if (verse.contains(value)) {
                  searchResult.add(
                    BibleReference(
                      book: Book(id: int.parse(book)),
                      chapter: int.parse(chapter),
                      verses: [Verse(id: int.parse(verseId), text: verse)],
                    ),
                  );
                }
              });
            },
          );
        },
      );
    }
  }

  Map getBooks() {
    Map books = {};
    Map bookData = _data[selectedVersion.dbName];
    for (String book in bookData.keys) {
      List chapters = _data[selectedVersion.dbName][book].keys.toList();
      books[bibleBooks[int.parse(book) - 1]] = chapters;
    }
    isChanged.value = true;
    return books;
  }

  Verse getVerse({
    required Book book,
    required int chapter,
    required int verse,
  }) {
    isloading.value = true;

    String verseText =
        _data[selectedVersion.dbName]['${book.id}']['$chapter']['$verse'];

    isloading.value = false;
    isChanged.value = true;
    return Verse(id: verse, text: verseText);
  }

  BibleReference getChapter({
    required Book book,
    required int chapter,
  }) {
    List<Verse> verses = [];
    Map chapterData = _data[selectedVersion.dbName]['${book.id}']['$chapter'];

    chapterData.forEach(
      (id, text) => verses.add(
        Verse(id: int.parse(id), text: text),
      ),
    );
    isloading.value = false;
    isChanged.value = true;
    update();
    return BibleReference(
      version: versions[0],
      book: Book(id: book.id),
      chapter: chapter,
      startVerse: 1,
      endVerse: chapterData.length + 1,
      verses: verses,
    );
  }
}
