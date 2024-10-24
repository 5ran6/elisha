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

import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/chapter.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/providers/bible_books_provider.dart';
import 'package:elisha/src/providers/bible_chapters_provider.dart';
import 'package:elisha/src/providers/last_translation_book_chapter_provider.dart';

class BibleRepository {
  BibleRepository();

  final _mapOfBibleBooks = <int, String>{
    1: 'Genesis',
    2: 'Exodus',
    3: 'Leviticus',
    4: 'Numbers',
    5: 'Deuteronomy',
    6: 'Joshua',
    7: 'Judges',
    8: 'Ruth',
    9: '1 Samuel',
    10: '2 Samuel',
    11: '1 Kings',
    12: '2 Kings',
    13: '1 Chronicles',
    14: '2 Chronicles',
    15: 'Ezra',
    16: 'Nehemiah',
    17: 'Esther',
    18: 'Job',
    19: 'Psalms',
    20: 'Proverbs',
    21: 'Ecclesiastes',
    22: 'Song of Solomon',
    23: 'Isaiah',
    24: 'Jeremiah',
    25: 'Lamentations',
    26: 'Ezekiel',
    27: 'Daniel',
    28: 'Hosea',
    29: 'Joel',
    30: 'Amos',
    31: 'Obadiah',
    32: 'Jonah',
    33: 'Micah',
    34: 'Nahum',
    35: 'Habakkuk',
    36: 'Zephaniah',
    37: 'Haggai',
    38: 'Zechariah',
    39: 'Malachi',
    40: 'Matthew',
    41: 'Mark',
    42: 'Luke',
    43: 'John',
    44: 'Acts',
    45: 'Romans',
    46: '1 Corinthians',
    47: '2 Corinthians',
    48: 'Galatians',
    49: 'Ephesians',
    50: 'Philippians',
    51: 'Colossians',
    52: '1 Thessalonians',
    53: '2 Thessalonians',
    54: '1 Timothy',
    55: '2 Timothy',
    56: 'Titus',
    57: 'Philemon',
    58: 'Hebrews',
    59: 'James',
    60: '1 Peter',
    61: '2 Peter',
    62: '1 John',
    63: '2 John',
    64: '3 John',
    65: 'Jude',
    66: 'Revelation',
  };

  final Map<int, int> _mapOfBibleChaptersAndBooks = {
    0: 1,
    1: 50,
    2: 40,
    3: 27,
    4: 36,
    5: 34,
    6: 24,
    7: 21,
    8: 4,
    9: 31,
    10: 24,
    11: 22,
    12: 25,
    13: 29,
    14: 36,
    15: 10,
    16: 13,
    17: 10,
    18: 42,
    19: 150,
    20: 31,
    21: 12,
    22: 8,
    23: 66,
    24: 52,
    25: 5,
    26: 48,
    27: 12,
    28: 14,
    29: 3,
    30: 9,
    31: 1,
    32: 4,
    33: 7,
    34: 3,
    35: 3,
    36: 3,
    37: 2,
    38: 14,
    39: 4,
    40: 28,
    41: 16,
    42: 24,
    43: 21,
    44: 28,
    45: 16,
    46: 16,
    47: 13,
    48: 6,
    49: 6,
    50: 4,
    51: 4,
    52: 5,
    53: 3,
    54: 6,
    55: 4,
    56: 3,
    57: 1,
    58: 13,
    59: 5,
    60: 5,
    61: 3,
    62: 5,
    63: 1,
    64: 1,
    65: 1,
    66: 22,
    67: 22,
  };

  Map<int, int> get mapOfBibleChaptersAndBooks => _mapOfBibleChaptersAndBooks;

  List<Book> getBooks() {
    var books = <Book>[];

    for (var item in _mapOfBibleBooks.entries.toList()) {
      var newMap = _mapOfBibleChaptersAndBooks;

      newMap.remove(0);
      newMap.remove(67);

      String testament() {
        if (item.key < 40) return 'Old';
        return 'New';
      }

      final chapters = List<ChapterId>.generate(newMap[item.key]!, (i) => ChapterId(id: i + 1));

      final book = Book(id: item.key, chapters: chapters, name: item.value, testament: testament());

      books.add(book);
    }

    return books;
  }

  bool _isLastChapterInBook(BuildContext context) {
    bool bookChapterBool(int book, int chapter) {
      return (context.read(localRepositoryProvider).chapter == chapter &&
          context.read(localRepositoryProvider).book == book);
    }

    if (bookChapterBool(1, 50) ||
        bookChapterBool(2, 40) ||
        bookChapterBool(3, 27) ||
        bookChapterBool(4, 36) ||
        bookChapterBool(5, 34) ||
        bookChapterBool(6, 24) ||
        bookChapterBool(7, 21) ||
        bookChapterBool(8, 4) ||
        bookChapterBool(9, 31) ||
        bookChapterBool(10, 24) ||
        bookChapterBool(11, 22) ||
        bookChapterBool(12, 25) ||
        bookChapterBool(13, 29) ||
        bookChapterBool(14, 36) ||
        bookChapterBool(15, 10) ||
        bookChapterBool(16, 13) ||
        bookChapterBool(17, 10) ||
        bookChapterBool(18, 42) ||
        bookChapterBool(19, 150) ||
        bookChapterBool(20, 31) ||
        bookChapterBool(21, 12) ||
        bookChapterBool(22, 8) ||
        bookChapterBool(23, 66) ||
        bookChapterBool(24, 52) ||
        bookChapterBool(25, 5) ||
        bookChapterBool(26, 48) ||
        bookChapterBool(27, 12) ||
        bookChapterBool(28, 14) ||
        bookChapterBool(29, 3) ||
        bookChapterBool(30, 9) ||
        bookChapterBool(31, 1) ||
        bookChapterBool(32, 4) ||
        bookChapterBool(33, 7) ||
        bookChapterBool(34, 3) ||
        bookChapterBool(35, 3) ||
        bookChapterBool(36, 3) ||
        bookChapterBool(37, 2) ||
        bookChapterBool(38, 14) ||
        bookChapterBool(39, 4) ||
        bookChapterBool(40, 28) ||
        bookChapterBool(41, 16) ||
        bookChapterBool(42, 24) ||
        bookChapterBool(43, 21) ||
        bookChapterBool(44, 28) ||
        bookChapterBool(45, 16) ||
        bookChapterBool(46, 16) ||
        bookChapterBool(47, 13) ||
        bookChapterBool(48, 6) ||
        bookChapterBool(49, 6) ||
        bookChapterBool(50, 4) ||
        bookChapterBool(51, 4) ||
        bookChapterBool(52, 5) ||
        bookChapterBool(53, 3) ||
        bookChapterBool(54, 6) ||
        bookChapterBool(55, 4) ||
        bookChapterBool(56, 3) ||
        bookChapterBool(57, 1) ||
        bookChapterBool(58, 13) ||
        bookChapterBool(59, 5) ||
        bookChapterBool(60, 5) ||
        bookChapterBool(61, 3) ||
        bookChapterBool(62, 5) ||
        bookChapterBool(63, 1) ||
        bookChapterBool(64, 1) ||
        bookChapterBool(65, 1) ||
        bookChapterBool(66, 22)) {
      return true;
    }

    return false;
  }

  Future<void> goToNextPreviousChapter(BuildContext context, bool isBackward) async {
    bool isFirstChapterInBook() {
      return context.read(localRepositoryProvider).chapter == 1;
    }

    bool isGenesisOne() {
      if (context.read(localRepositoryProvider).book == 1 && context.read(localRepositoryProvider).chapter == 1) {
        return true;
      }
      return false;
    }

    bool isRevelationTwentyTwo() {
      if (context.read(localRepositoryProvider).book == 66 && context.read(localRepositoryProvider).chapter == 22) {
        return true;
      }
      return false;
    }

    int newBibleChapter = 1;
    int newBibleBook = 1;

    if (isBackward) {
      if (!isGenesisOne()) {
        if (isFirstChapterInBook()) {
          newBibleBook = context.read(localRepositoryProvider).book! - 1;
          newBibleChapter = _mapOfBibleChaptersAndBooks[newBibleBook]!;
        } else {
          newBibleBook = context.read(localRepositoryProvider).book!;
          newBibleChapter = context.read(localRepositoryProvider).chapter! - 1;
        }

        bookID = newBibleBook.toString();
        chapterID = newBibleChapter.toString();

        context.read(localRepositoryProvider.notifier).changeBibleBook(newBibleBook);
        context.read(localRepositoryProvider.notifier).changeBibleChapter(newBibleChapter);

        context.refresh(bibleChaptersProvider);
      } else {
        DoNothingAction();
      }
    } else {
      if (!isRevelationTwentyTwo()) {
        if (_isLastChapterInBook(context)) {
          newBibleBook = context.read(localRepositoryProvider).book! + 1;
          newBibleChapter = 1;
        } else {
          newBibleBook = context.read(localRepositoryProvider).book!;
          newBibleChapter = context.read(localRepositoryProvider).chapter! + 1;
        }

        bookID = newBibleBook.toString();
        chapterID = newBibleChapter.toString();

        context.read(localRepositoryProvider.notifier).changeBibleBook(newBibleBook);
        context.read(localRepositoryProvider.notifier).changeBibleChapter(newBibleChapter);

        context.refresh(bibleChaptersProvider);
      } else {
        DoNothingAction();
      }
    }
  }

  Future<void> changeChapter(BuildContext context, int book, int chapter) async {
    if (context.read(localRepositoryProvider).book! == book &&
        context.read(localRepositoryProvider).chapter! == chapter) {
      DoNothingAction();
    } else {
      if (context.read(localRepositoryProvider).book! == book) {
        chapterID = chapter.toString();
        context.read(localRepositoryProvider.notifier).changeBibleChapter(chapter);
      } else {
        bookID = book.toString();
        chapterID = chapter.toString();

        context.read(localRepositoryProvider.notifier).changeBibleBook(book);
        context.read(localRepositoryProvider.notifier).changeBibleChapter(chapter);
      }

      context.refresh(bibleChaptersProvider);
    }
  }
}
