import 'package:elisha/utils/utils.dart';

class Book {
  const Book({required this.id});
  final int id;

  factory Book.fromName(String name) {
    int id;
    try {
      id = bibleBooks.indexOf(name) + 1;
    } catch (e) {
      throw Exception("Invalid book name");
    }
    return Book(id: id);
  }

  String name() {
    return bibleBooks[id - 1];
  }
}
