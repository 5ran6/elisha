import 'dart:convert';

List<FeedbackModel> feedbackFromJson(List<dynamic> jsonList) =>
    List<FeedbackModel>.from(jsonList.map((x) => FeedbackModel.fromJson(x)));
String feedbackToJson(List<FeedbackModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackModel {
  String? userId;
  String feedback;
  String name;

  FeedbackModel({this.userId, required this.feedback, required this.name});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        userId: json["userId"] ?? '',
        feedback: json["feedback"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "feedback": feedback,
        "name": name,
      };

  @override
  String toString() {
    return 'FeedbackModel{userId: $userId, name: $name, feedback: $feedback}';
  }
}
