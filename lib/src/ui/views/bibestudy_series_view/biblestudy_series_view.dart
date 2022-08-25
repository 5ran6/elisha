import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
  bool _isConnectionSuccessful = false;

  Future<List<DevotionalPlan>> get devPlansFuture {
    return RemoteAPI.getDevotionalPlans();
  }

  void fetchAndUpdateUIPlans() async {
    List<DevotionalPlan> devPlans = await devPlansFuture;

    setState(() {
      _devPlansList = devPlans;
    });
  }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('example.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }

  @override
  void initState() {
    _tryConnection();
    fetchAndUpdateUIPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const BibleStudySeriesHeaderView(),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: TextField(
              //     controller: controller,
              //     decoration: InputDecoration(
              //       prefixIcon: const Icon(Icons.search),
              //       hintText: 'Plan title',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(30),
              //         borderSide: BorderSide(color: Theme.of(context).primaryColor),
              //       )
              //     ),
              //     onChanged: searchStudyPlan,
              //   ),
              // ),

              const SizedBox(height: 20),
              _isConnectionSuccessful ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _devPlansList.length,
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  staggeredTileBuilder: (index) => StaggeredTile.count(2, 2),
                  itemBuilder: (context, index) => buildBibleStudyPlanCardView(index),
                ),
              ) : Text(
                'Enable Internet Connection',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void searchStudyPlan(String query) {
  //   final planSuggestions = _devPlansList.where((plan) {
  //     final planTitle = plan.title.toLowerCase();
  //     final input = query.toLowerCase();

  //     return planTitle.contains(input);
  //   }).toList();

  //   setState(() {
  //     _devPlansList = planSuggestions;
  //   });

  // }

  buildBibleStudyPlanCardView(int index) => GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OpenedStudyPlanScreen(devPlanID: _devPlansList[index].id)));
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _devPlansList[index].imageUrl,
              placeholder: (context, url) => Center(
                child:  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      );
}
