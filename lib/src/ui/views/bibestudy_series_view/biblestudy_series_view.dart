import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/bibestudy_series_view/biblestudy_series_view_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/devotional_plans.dart';
import '../../../providers/api_provider.dart';
import '../opened_studyplan_view/opened_studyplan_view.dart';

class BibleStudySeriesPage extends StatefulWidget {
  const BibleStudySeriesPage({Key? key}) : super(key: key);

  @override
  _BibleStudySeriesPageState createState() => _BibleStudySeriesPageState();
}

class _BibleStudySeriesPageState extends State<BibleStudySeriesPage> {
  final controller = TextEditingController();

  var _devPlansList = List<DevotionalPlan>.empty();

  Future<List<DevotionalPlan>> get devPlansFuture {
    return RemoteAPI.getDevotionalPlans();
  }

  void fetchAndUpdateUIPlans() async {
    List<DevotionalPlan> devPlans = await devPlansFuture;

    setState(() {
      _devPlansList = devPlans;
    });
  }


  @override
  void initState() {
    fetchAndUpdateUIPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BibleStudySeriesHeaderView(),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Plan title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )
              ),
              onChanged: searchStudyPlan,
            ),


            const SizedBox(height: 10),
           Expanded(
             child: StaggeredGridView.countBuilder(
               itemCount: _devPlansList.length,
                 crossAxisCount: 4,
                 mainAxisSpacing: 8,
                 crossAxisSpacing: 8,
                 staggeredTileBuilder: (index) => StaggeredTile.count(2, 2),
               itemBuilder: (context, index) => buildBibleStudyPlanCardView(index),
             ),
           ),

          ],
        ),
      ),
    );
  }

  void searchStudyPlan(String query) {
    final planSuggestions = _devPlansList.where((plan) {
      final planTitle = plan.title.toLowerCase();
      final input = query.toLowerCase();

      return planTitle.contains(input);
    }).toList();

    setState(() {
      _devPlansList = planSuggestions;
    });

  }

  buildBibleStudyPlanCardView(int index) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OpenedStudyPlanScreen(devPlanID: _devPlansList[index].id)));
    },
    child: Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(_devPlansList[index].imageUrl,
          fit: BoxFit.cover,
          ),
      ),
    ),
  );
}



