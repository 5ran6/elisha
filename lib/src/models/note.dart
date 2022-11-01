// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

List<Note> noteFromJson(List<dynamic> jsonList) => List<Note>.from(jsonList.map((x) => Note.fromJson(x)));

//List<Note> noteFromJson(String str) => List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    this.id,
    required this.title,
    required this.writeUp,
    required this.date,
  });

  String? id;
  String title;
  String writeUp;
  String date;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
         id: json["id"],
        title: json["title"] ?? '',
        writeUp: json["writeUp"] ?? '',
        date: json["date"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "writeUp": writeUp,
        "date": date,
      };

  @override
  String toString() {
    return 'Note{id: $id, title: $title, writeUp: $writeUp, date: $date}';
  }
}
