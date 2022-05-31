
import 'dart:convert';

import 'devotional.dart';

//List<DevotionalPlans> devotionalPlansFromJson(String str) => List<DevotionalPlans>.from(json.decode(str).map((x) => DevotionalPlans.fromJson(x)));
List<DevotionalPlans> devotionalPlansFromJson(List<dynamic> jsonList) =>
    List<DevotionalPlans>.from(jsonList.map((x) => DevotionalPlans.fromJson(x)));
String devotionalPlansToJson(List<DevotionalPlans> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

DevotionalPlans devotionalPlanWithIDFromJson(String str) => DevotionalPlans.fromJson(json.decode(str));
String devotionalPlansWithIDToJson(DevotionalPlans plans) => json.encode(plans.toJson());

class DevotionalPlans {
  DevotionalPlans({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.devotionals,
  });

  String id;
  String title;
  String imageUrl;
  String description;
  List<Devotional> devotionals;

  factory DevotionalPlans.fromJson(Map<String, dynamic> json) => DevotionalPlans(
    id: json["id"],
    title: json["title"],
    imageUrl: json["imageUrl"],
    description: json["description"],
    devotionals: List<Devotional>.from(json["devotionals"].map((x) => Devotional.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "imageUrl": imageUrl,
    "description": description,
    "devotionals": List<dynamic>.from(devotionals.map((x) => x.toMap())),
  };
}

