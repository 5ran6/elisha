import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/feedback.dart';
import 'package:elisha/src/ui/views/profile_view/star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  double ratingValue = 1;
  var feedbackNameController = TextEditingController();
  var feedbackReviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color.fromRGBO(3, 3, 70, 1),
                          backgroundImage: AssetImage("assets/images/app_icon.png"),
                        ),
                        Container(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Secret Place",
                                style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(height: 5),
                              Text(
                                "Feedback services",
                                style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(height: 5),
                    const Divider(),
                    Container(height: 5),
                    StarRating(
                      starCount: 5,
                      rating: ratingValue,
                      color: Colors.orange[300],
                      size: 30,
                      onRatingChanged: (value) {
                        setState(() {
                          ratingValue = value;
                        });
                      },
                    ),
                    Container(height: 15),
                    Container(
                      //color: Colors.grey,
                      height: 30,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: TextFormField(
                        controller: feedbackNameController,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        minLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name...',
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    Container(height: 5),
                    Container(
                      //color: Colors.grey,
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: TextFormField(
                        controller: feedbackReviewController,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        minLines: 30,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write review ...',
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.transparent),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CLOSE", style: TextStyle(color: Colors.pink[500])),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.transparent),
                    child: const Text("SUBMIT", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      String todayDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
                      FeedbackModel feedback = FeedbackModel(
                          feedback: feedbackReviewController.text,
                          name: feedbackNameController.text,
                          timeDateSent: todayDate);
                      sendFeedbackPostRequest(feedback);
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendFeedbackPostRequest(FeedbackModel feedback) async {
    final response = await http.post(Uri.parse("https://secret-place.herokuapp.com/api/feedbacks"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(feedback));

    print(response.statusCode);
  }
}
