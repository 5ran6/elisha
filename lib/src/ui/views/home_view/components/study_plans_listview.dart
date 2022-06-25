import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/ui/views/bibestudy_series_view/biblestudy_series_view.dart';
import 'package:elisha/src/ui/views/opened_studyplan_view/opened_studyplan_view.dart';

class StudyPlansListView extends StatefulWidget {
  const StudyPlansListView({Key? key}) : super(key: key);

  @override
  _StudyPlansListViewState createState() => _StudyPlansListViewState();
}

class _StudyPlansListViewState extends State<StudyPlansListView> {
  final List pictures =  ['assets/images/appreciate.jpeg', 'assets/images/heart.jpeg', 'assets/images/light.jpg',
    'assets/images/master.jpg', "assets/images/bow.jpg"];
  final List titles = ['Humility', 'Raging Battle', 'Purity', 'New Creation Man', 'Firebrands'];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Study Series',
                style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BibleStudySeriesPage(),
                ),
                );
              },
              child: Text('View All',
                  style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.normal)),
            ),
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
                itemCount: 5,
                itemBuilder: (ctx, i) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OpenedStudyPlanScreen()));
                      },
                      child: Card(
                          color: CantonMethods.alternateCanvasColorType2(context),
                          shape: CantonSmoothBorder.defaultBorder(),
                          child:  Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(pictures[i]),
                                  fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(titles[i], style: const TextStyle(
                      fontSize: 15,
                        fontWeight: FontWeight.bold))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
