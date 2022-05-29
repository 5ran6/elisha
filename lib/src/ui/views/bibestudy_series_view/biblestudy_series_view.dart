import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/bibestudy_series_view/biblestudy_series_view_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/devotional_plans.dart';
import '../../../providers/api_provider.dart';

class BibleStudySeriesPage extends StatefulWidget {
  const BibleStudySeriesPage({Key? key}) : super(key: key);

  @override
  _BibleStudySeriesPageState createState() => _BibleStudySeriesPageState();
}

class _BibleStudySeriesPageState extends State<BibleStudySeriesPage> {
  // final List pictures =  ['assets/images/appreciate.jpeg', 'assets/images/heart.jpeg', 'assets/images/light.jpg',
  //   'assets/images/master.jpg', "assets/images/bow.jpg"];
  // final List titles = ['Humility', 'Raging Battle', 'Purity', 'New Creation Man', 'Firebrands'];


  var _devPlansList = List<DevotionalPlans>.empty();

  Future<List<DevotionalPlans>> get devPlansFuture {
    return RemoteAPI.getDevotionalPlans();
  }

  void fetchAndUpdateUIPlans() async {
    List<DevotionalPlans> devPlans = await devPlansFuture;

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
           Expanded(
             child: StaggeredGridView.countBuilder(
               itemCount: _devPlansList.length,
                 crossAxisCount: 3,
                 mainAxisSpacing: 8,
                 crossAxisSpacing: 8,
                 staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
               itemBuilder: (context, index) => buildBibleStudyPlanCardView(index),
             ),
           ),

          ],
        ),
      ),
    );
  }

  buildBibleStudyPlanCardView(int index) => Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(_devPlansList[index].imageUrl),
        )

    ),
  );
}



