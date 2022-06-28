
class FeedbackModel{

  String date;
  String name;
  String review;

  FeedbackModel({required this.date, required this.name, required this.review});



  @override
  String toString() {
    return 'FeedbackModel{date: $date, name: $name, review: $review}';
  }
}