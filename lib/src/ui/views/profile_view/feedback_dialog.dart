import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/profile_view/star_rating.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  double ratingValue = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4),),
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
                        const CircleAvatar(radius: 20,
                          backgroundImage: AssetImage("assets/images/app_icon.png"),
                        ),
                        Container(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Secret Place", style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),),
                              Container(height: 5),
                              Text("Feedback services", style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.normal),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(height: 5),
                    const Divider(),
                    Container(height: 5),
                    StarRating(
                      starCount: 5, rating : ratingValue, color: Colors.orange[300], size: 30,
                      onRatingChanged: (value){
                        setState(() { ratingValue = value; });
                      },
                    ),
                    Container(height: 15),
                    Container(
                      color: Colors.grey, height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: TextField(
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        keyboardType: TextInputType.multiline,
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("CLOSE", style: TextStyle(color: Colors.pink[500])),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.transparent),
                    child: const Text("SUBMIT", style: TextStyle(color: Colors.black)),
                    onPressed: (){},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
