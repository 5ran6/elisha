import 'dart:convert';

import 'devotional.dart';

//List<DevotionalPlans> devotionalPlansFromJson(String str) => List<DevotionalPlans>.from(json.decode(str).map((x) => DevotionalPlans.fromJson(x)));
List<DevotionalPlan> devotionalPlansFromJson(List<dynamic> jsonList) =>
    List<DevotionalPlan>.from(jsonList.map((x) => DevotionalPlan.fromJson(x)));

String devotionalPlansToJson(List<DevotionalPlan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

DevotionalPlan devotionalPlanWithIDFromJson(var js) =>
    DevotionalPlan.fromJson(js);

String devotionalPlansWithIDToJson(DevotionalPlan plans) =>
    json.encode(plans.toJson());

class DevotionalPlan {
  DevotionalPlan({
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

  factory DevotionalPlan.fromJson(Map<String, dynamic> json) => DevotionalPlan(
        id: json["id"],
        title: json["title"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        devotionals: List<Devotional>.from(json["devotionals"].map((x) => Devotional.fromJson(x)))

  );


  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
        "description": description,
        "devotionals": jsonEncode(devotionals.map((e) => jsonEncode(e.toMap())).toList()),
      };
}