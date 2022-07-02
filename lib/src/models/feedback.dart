import 'dart:convert';

List<FeedbackModel> feedbackFromJson(List<dynamic> jsonList) =>
    List<FeedbackModel>.from(jsonList.map((x) => FeedbackModel.fromJson(x)));
String feedbackToJson(List<FeedbackModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackModel {
  String feedback;
  String name;
  String timeDateSent;

  FeedbackModel({required this.feedback, required this.name, required this.timeDateSent});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        feedback: json["feedback"] ?? '',
        name: json["name"] ?? '',
        timeDateSent: json["timeDateSent"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "feedback": feedback,
        "name": name,
        "timeDateSent": timeDateSent,
      };

  @override
  String toString() {
    return 'FeedbackModel{date: $feedback, name: $name, review: $timeDateSent}';
  }
}
