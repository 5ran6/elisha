import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/devotional_page/devotional_page_fromplans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../providers/api_provider.dart';

class OpenedStudyPlanScreen extends StatefulWidget {
  final String devPlanID;

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
    //if in db, show from db. If not, then fetch.
    DevotionalPlan? planFromDB = await DevotionalDBHelper.instance.getDevotionalPlanFromDBWithID(widget.devPlanID);

    if (planFromDB == null) {
      DevotionalPlan devPlanWithFullDevotionals = await devPlansWithDevotionalsFuture;

      DevotionalDBHelper.instance.insertDevotionalPlan(devPlanWithFullDevotionals);
      setState(() {
        _devPlanWithFullDevotionals = devPlanWithFullDevotionals;
      });
    } else {
      setState(() {
        _devPlanWithFullDevotionals = planFromDB;
      });
    }
  }

  @override
  void initState() {
    getDevotionalPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _devPlanWithFullDevotionals != null
            ? Column(
                children: [
                  CachedNetworkImage(
                      imageUrl: _devPlanWithFullDevotionals!.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                              //borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error)),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      _devPlanWithFullDevotionals?.description ?? '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontFamily: "Palatino"),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (index) => StaggeredTile.count(2, 1),
                      itemCount: _devPlanWithFullDevotionals?.devotionals.length,
                      mainAxisSpacing: 8,
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      itemBuilder: (context, index) => buildDailyPlanCard(index),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )),
      ),
    );
  }

  Widget buildDailyPlanCard(int index) => GestureDetector(
        onTap: () {
          if (_devPlanWithFullDevotionals != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DevotionalPageFromPlans(devotionalFromPlan: _devPlanWithFullDevotionals!.devotionals[index])));
          }
        },
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              margin: EdgeInsets.all(5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Center(child: Text('Day ${index + 1}', style: Theme.of(context).textTheme.headlineSmall)))),
        ),
      );
}
