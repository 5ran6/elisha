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


import 'package:dio/dio.dart';
import 'package:elisha/src/providers/bible_translations_provider.dart';
import 'package:elisha/src/repositories/bible_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:reference_parser/reference_parser.dart'
as bible_reference_parser;

import 'package:elisha/src/config/exceptions.dart';
import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/chapter.dart';
import 'package:elisha/src/models/translation.dart';
import 'package:elisha/src/models/verse.dart';

class BibleService {
  BibleService(this._dio);

  final Dio _dio;
  final _rootUrl = 'https://secret-place.herokuapp.com/api';
  final _defaultBibleVersionPath = 'assets/bible_translations/esv.json';

  Future<String> getPathToBibleTranslation(String translationAbbr) async {
    var _path = (await getExternalStorageDirectory())!.path;
    return '$_path/$translationID.json';
  }

  Future<String> getBibleTranslationIfAvailableOrDefault(
      String translationAbbr) async {
    return await rootBundle.loadString(_defaultBibleVersionPath);
  }

  Future<List<Translation>> getTranslations() async {
    try {
      final response = await _dio.get(_rootUrl + '/bible-translations');
      final results = List<Map<String, dynamic>>.from(
        response.data,
      );
      final List<Translation> translations = results
          .map((translation) => Translation.fromMap(translation))
          .toList(growable: false);
      return translations;
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Book>> readJsonBibleBooks() async {
    final String response =
    await rootBundle.loadString(_defaultBibleVersionPath);
    final data = await json.decode(response) as List<dynamic>;
    return data.map((book) {
      return Book.fromJson(json.encode(book));
    }).toList();
  }

  Future<Map<String, dynamic>> readJsonBibleChapter(
      bookID, chapterID, translationAbbr) async {
    final String response =
    await getBibleTranslationIfAvailableOrDefault(translationAbbr);
    print("json bible response");
    print(response);
    final data = await json.decode(response) as List<dynamic>;
    final book = data[int.parse(bookID!) - 1] as Map<String, dynamic>;
    return book['chapters'][int.parse(chapterID!) - 1];
  }

  Future<List<Map<String, dynamic>>> readJsonBibleChapters(bookID) async {
    final String response =
    await rootBundle.loadString(_defaultBibleVersionPath);
    final data = await json.decode(response) as List<dynamic>;
    final book = data[int.parse(bookID!) - 1] as Map<String, dynamic>;
    return book['chapters'] as List<Map<String, dynamic>>;
  }

  Future<List<Book>> getBooks(String? bookID) async {
    try {
      if (!['', null].contains(bookID)) {
        final bible = await readJsonBibleBooks();

        final book = bible[int.parse(bookID!) - 1];
        return [book];
      } else {
        var trace = FirebasePerformance.instance
            .newTrace('book_chapter_bottom_sheet_open_time');
        trace.start();

        final books = BibleRepository().getBooks();

        trace.stop();

        return books;
      }
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<Chapter> getChapter(
      String bookID, String chapterID, String? translationAbbr) async {
    try {
      print("translationIDfdsafd");
      print(translationID);

      final chapterFromJSON =
      await readJsonBibleChapter(bookID, chapterID, translationAbbr);

      final versesList = chapterFromJSON['verses'] as List<dynamic>;

      final verses = versesList
          .map((verse) => Verse.fromMap(verse))
          .toList(growable: false);

      final chapter = Chapter(
        id: verses[0].book.id,
        number: verses[0].chapterId.toString(),
        translation: translationID,
        verses: verses,
      );
      print("chapter");
      print(chapter);
      return chapter;
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Chapter>> getChapters(String? bookID) async {
    try {
      // final response = await _dio.get(_rootUrl + '/books/$bookID/chapters');
      final results = await readJsonBibleChapters(bookID);

      // final results = List<Map<String, dynamic>>.from(
      //   response.data,
      // );

      final List<Chapter> chapters = results
          .map((chapter) => Chapter.fromMap(chapter))
          .toList(growable: false);
      return chapters;
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Verse>> getVerses(
      String? bookID, String? chapterID, String? verseID) async {
    try {
      if (!['', null].contains(verseID)) {
        // final response = await _dio
        //     .get(_rootUrl + '/books/$bookID/chapters/$chapterID/verseID');
        Chapter chapter = await getChapter(bookID!, chapterID!, null);

        // final results = List<Map<String, dynamic>>.from(
        //   response.data,
        // );

        // final List<Verse> verses = results
        //     .map((verse) => Verse.fromMap(verse))
        //     .toList(growable: false);

        final List<Verse> verses = chapter.verses!
            .where((element) => element.verseId.toString() == verseID)
            .toList(growable: false);

        return verses;
      } else {
        // final response =
        //     await _dio.get(_rootUrl + '/books/$bookID/chapters/$chapterID');
        //
        // final results = List<Map<String, dynamic>>.from(
        //   response.data,
        // );
        //
        // final List<Verse> verses = results
        //     .map((verse) => Verse.fromMap(verse))
        //     .toList(growable: false);

        Chapter chapter = await getChapter(bookID!, chapterID!, translationID);

        // final results = List<Map<String, dynamic>>.from(
        //   response.data,
        // );

        // final List<Verse> verses = results
        //     .map((verse) => Verse.fromMap(verse))
        //     .toList(growable: false);

        final List<Verse> verses = chapter.verses!.toList(growable: false);

        return verses;
      }
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  static int getBookIdFromPassageString(String? passage) {
    var ref = bible_reference_parser.parseReference(passage.toString());
    print("passage");
    print(passage);
    print(ref);
    print(ref.book); // 'John'
    print(ref.bookNumber); // 43
    print(ref.startChapterNumber); // 3
    print(ref.startVerseNumber); // 16
    print(ref.isValid); //
    return ref.bookNumber!;
  }

  static int getChapterIdFromPassageString(String? passage) {
    var ref = bible_reference_parser.parseReference(passage.toString());
    print("passage");
    print(passage);
    print("ref");
    print(ref.book); // 'John'
    print(ref.bookNumber); // 43
    print(ref.startChapterNumber); // 3
    print(ref.startVerseNumber); // 16
    print(ref.isValid); //
    return ref.startChapterNumber;
  }
}
