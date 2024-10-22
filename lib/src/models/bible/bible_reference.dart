import 'package:elisha/src/models/bible/models.dart';

class BibleReference {
  const BibleReference({
    this.version,
    required this.book,
    required this.chapter,
    this.startVerse = 1,
    this.endVerse,
    this.verses = const [],
  });
  final Version? version;
  final Book book;
  final int chapter, startVerse;
  final int? endVerse;
  final List<Verse> verses;

  factory BibleReference.fromText(String reference) {
    List<String> referenceToken = reference.split(' ');

    String bookName = int.tryParse(referenceToken[0]) != null
        ? "${referenceToken[0]} ${referenceToken[1]}"
        : referenceToken[0];

    int chapterId = int.parse(referenceToken[referenceToken.indexOf(":") - 1]);
    int startVerseId =
        int.parse(referenceToken[referenceToken.indexOf(":") + 1]);
    int? endVerseId = referenceToken.contains("-")
        ? int.parse(referenceToken[referenceToken.indexOf("-") + 1])
        : null;

    return BibleReference(
      book: Book.fromName(bookName),
      chapter: chapterId,
      startVerse: startVerseId,
      endVerse: endVerseId,
    );
  }
}
