
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/devotional_plans.dart';
import 'package:elisha/src/ui/views/opened_studyplan_view/opened_studyplan_view.dart';

class SelectedStudyPlansListview extends StatefulWidget {
  const SelectedStudyPlansListview({required this.devPlansFromDB});

  final List<DevotionalPlan> devPlansFromDB;

  @override
  _SelectedStudyPlansListviewState createState() => _SelectedStudyPlansListviewState();
}

class _SelectedStudyPlansListviewState extends State<SelectedStudyPlansListview> {

  @override
  Widget build(BuildContext context) {
    return widget.devPlansFromDB.isNotEmpty? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text('My Study Plans',
              style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10,);
              },
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.devPlansFromDB.length,
              itemBuilder: (ctx, i) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OpenedStudyPlanScreen(devPlanID: widget.devPlansFromDB[i].id)));
                    },
                    child: Card(
                      color: CantonMethods.alternateCanvasColorType2(context),
                      shape: CantonSmoothBorder.defaultBorder(),
                      child:  CachedNetworkImage(
                        imageUrl: widget.devPlansFromDB[i].imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.devPlansFromDB[i].title, style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold))
                ],
              )),
        )
      ],
    ) : Center(child: Text('No Study Plan Selected', style: Theme.of(context).textTheme.headline5,));
  }
}
