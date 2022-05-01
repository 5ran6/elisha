import 'dart:convert';

List<DevotionalModel> devotionsFromJson(String str) =>
    List<DevotionalModel>.from(json.decode(str).map((x) => DevotionalModel.fromJson(x)));

String devotionsToJson(List<DevotionalModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => null)));



class DevotionalModel {
  String date;
  String text;
  String title;
  String author;
  String memoryVerse;
  String memoryVersePassage;
  String fullPassage;
  String fullText;
  String bibleInAYear;
  String image;


  DevotionalModel({
    required this.date,
    required this.title,
    required this.text,
    required this.author,
    required this.memoryVerse,
    required this.memoryVersePassage,
    required this.fullPassage,
    required this.fullText,
    required this.bibleInAYear,
    required this.image});

  factory DevotionalModel.fromJson(Map<String, dynamic> json) => DevotionalModel(
    date : json['date'],
    title : json['title'],
    text : json['text'],
    author : json['author'],
    memoryVerse : json['memoryVerse'],
    memoryVersePassage : json['memoryVersePassage'],
    fullPassage : json['fullPassage'],
    fullText : json['fullText'],
    bibleInAYear : json['bibleInAYear'],
    image : json['image'],
  );
}