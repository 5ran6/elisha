import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/services/devotionalDB_helper.dart';
import 'package:elisha/src/ui/views/opened_studyplan_view/opened_studyplan_view.dart';

class SelectedStudyPlansListview extends StatefulWidget {
  SelectedStudyPlansListview({required this.devPlansFromDB});

  List<DevotionalPlan> devPlansFromDB;

  @override
  _SelectedStudyPlansListviewState createState() => _SelectedStudyPlansListviewState();
}

class _SelectedStudyPlansListviewState extends State<SelectedStudyPlansListview> {
  @override
  Widget build(BuildContext context) {
    return widget.devPlansFromDB.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: Text('My Study Plans',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.devPlansFromDB.length,
                    itemBuilder: (ctx, i) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpenedStudyPlanScreen(devPlanID: widget.devPlansFromDB[i].id)));
                              },
                              onLongPress: () {
                                alertDialog(context, widget.devPlansFromDB[i].id);
                              },
                              child: Card(
                                color: CantonMethods.alternateCanvasColorType2(context),
                                shape: CantonSmoothBorder.defaultBorder(),
                                child: CachedNetworkImage(
                                  imageUrl: widget.devPlansFromDB[i].imageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: 100,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(widget.devPlansFromDB[i].title,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                          ],
                        )),
              )
            ],
          )
        : Center(
            child: Text(
            'No Study Plan Selected',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w500, fontFamily: "Palatino"),
          ));
  }

  void deleteStudyPlan(String id) async {
    await DevotionalDBHelper.instance.deleteSelectedStudyPlan(id);
  }

  Future<List<DevotionalPlan>> get devPlansFuture {
    return DevotionalDBHelper.instance.getDevotionalPlansFromDB();
  }

  void fetchAndUpdateUIPlans() async {
    List<DevotionalPlan> devPlans = await devPlansFuture;

    setState(() {
      widget.devPlansFromDB = devPlans;
    });
  }

  void alertDialog(BuildContext context, String planID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Discard study plan ?",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('DISCARD'),
              onPressed: () {
                deleteStudyPlan(planID);
                setState(() {
                  fetchAndUpdateUIPlans();
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
