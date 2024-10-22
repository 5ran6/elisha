import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/ui/views/bibestudy_series_view/biblestudy_series_view.dart';
import 'package:elisha/src/ui/views/opened_studyplan_view/opened_studyplan_view.dart';
import 'package:flutter/cupertino.dart';

class DevotionalPlansHomePageListView extends StatelessWidget {
  final List<DevotionalPlan> devPlans;

  const DevotionalPlansHomePageListView({Key? key, required this.devPlans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Study Plans',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Palatino")),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleStudySeriesPage(),
                ),
              );
            },
            child: Text('View All',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.normal, fontFamily: "Palatino")),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: devPlans.length,
              itemBuilder: (ctx, i) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenedStudyPlanScreen(devPlanID: devPlans[i].id)));
                        },
                        child: Card(
                          color: CantonMethods.alternateCanvasColorType2(context),
                          shape: CantonSmoothBorder.defaultBorder(),
                          child: CachedNetworkImage(
                            imageUrl: devPlans[i].imageUrl,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
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
                      Text(devPlans[i].title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  )),
        )
      ],
    );
  }
}
