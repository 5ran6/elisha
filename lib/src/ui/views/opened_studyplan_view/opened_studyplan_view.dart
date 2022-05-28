import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class OpenedStudyPlanScreen extends StatefulWidget {
  const OpenedStudyPlanScreen({Key? key}) : super(key: key);

  @override
  _OpenedStudyPlanScreenState createState() => _OpenedStudyPlanScreenState();
}

class _OpenedStudyPlanScreenState extends State<OpenedStudyPlanScreen> {


  final List pictures =  ['assets/images/appreciate.jpeg', 'assets/images/heart.jpeg', 'assets/images/light.jpg',
    'assets/images/master.jpg', "assets/images/bow.jpg"];
  final List titles = ['Humility', 'Raging Battle', 'Purity', 'New Creation Man', 'Firebrands'];
  final List days = ['Day1', 'Day2', 'Day3', 'Day4', 'Day5'];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/appreciate.jpeg"),
                      fit: BoxFit.fill
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('Description of Devotional Plan',
              style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (index) => StaggeredTile.count(2,1),
                  itemCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                    itemBuilder: (context, index) => buildDailyPlanCard(index),
                ),
              ),


            ],
          ),
      ),
    );
  }

  Widget buildDailyPlanCard(int index) => Card(
    margin: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      margin: EdgeInsets.all(5),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
        child: Center(child: Text('Day1', style: Theme.of(context).textTheme.headline5))
      )

    ),
  );

}

