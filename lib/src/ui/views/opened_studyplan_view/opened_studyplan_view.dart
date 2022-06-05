import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page_fromplans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../providers/api_provider.dart';


class OpenedStudyPlanScreen extends StatefulWidget {
   final String devPlanID;
  // final String devPlanDescription;
  // final String devPlanImageUrl;
  // final List<Devotional> devs;

  const OpenedStudyPlanScreen({required this.devPlanID});

  @override
  _OpenedStudyPlanScreenState createState() => _OpenedStudyPlanScreenState();
}

class _OpenedStudyPlanScreenState extends State<OpenedStudyPlanScreen> {
  DevotionalPlan? _devPlanWithFullDevotionals = null;

  Future<DevotionalPlan> get devPlansWithDevotionalsFuture {
    return RemoteAPI.getDevotionalPlanWithID(widget.devPlanID);
  }

  void getDevotionalPlan() async {
    DevotionalPlan devPlansWithDev = await devPlansWithDevotionalsFuture;

    setState(() {
      _devPlanWithFullDevotionals = devPlansWithDev;

    });
  }


  @override
  void initState() {
    getDevotionalPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _devPlanWithFullDevotionals != null ? Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_devPlanWithFullDevotionals!.imageUrl),
                      fit: BoxFit.fill
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(_devPlanWithFullDevotionals?.description ?? '',
              style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (index) => StaggeredTile.count(2,1),
                  itemCount: _devPlanWithFullDevotionals?.devotionals?.length,
                      mainAxisSpacing: 8,
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                    itemBuilder: (context, index) => buildDailyPlanCard(index),
                ),
              ),


            ],
          ): Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)),
      ),
    );
  }

  Widget buildDailyPlanCard(int index) => GestureDetector(
    onTap: () {
      //List<Devotional> devsForPlan = _devPlansWithDevotionals[index].devotionals;
      if (_devPlanWithFullDevotionals != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionalPageFromPlans(devotionalFromPlan: _devPlanWithFullDevotionals!.devotionals[index])));


      }
    },
    child: Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
          child: Center(child: Text('Day$index', style: Theme.of(context).textTheme.headline5))
        )

      ),
    ),
  );

}

