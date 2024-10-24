import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/theme/apptheme.dart';
import 'package:elisha/src/ui/views/authentication_views/auth_selection_view.dart';
import 'package:elisha/src/ui/views/onboarding_view/widgets/onboardingItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elisha/utils/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late SharedPreferences prefs;
  List<OnBoardingItem> onBoardItems = [
    const OnBoardingItem(
      imageAsset: "assets/images/study.jpg",
      title: """Study""",
      description: """Let the word of God dwell in you richly.""",
    ),
    const OnBoardingItem(
      imageAsset: "assets/images/pray.jpg",
      title: """Pray""",
      description:
          """Pray without ceasing. The effectual fervent prayer of the righteous man makes tremendous power available.""",
    ),
    const OnBoardingItem(
      imageAsset: "assets/images/without_distractions.jpg",
      title: "Without Distractions",
      description: "Avoid distractions while you focus on God in the course of your devotion",
    ),
  ];
  final int _numberOfPages = 2;
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 70, 1),
      body: SizedBox(
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(110),
              padding: EdgeInsets.all(
                ScreenUtil().setHeight(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: getStarted,
                    child: Text(
                      "Skip",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppTheme.kPrimaryColor, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(490),
              //color: AppTheme.kWhiteColor,
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                children: onBoardItems,
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(90),
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(10)),
              color: Color.fromRGBO(3, 3, 70, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildPageIndicator(),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: AppTheme.kWhiteColor,
                            borderRadius: BorderRadius.circular(kDefaultButtonRadius),
                          ),
                          height:
                              _currentPage != _numberOfPages ? ScreenUtil().setHeight(55) : ScreenUtil().setHeight(55),
                          width:
                              _currentPage != _numberOfPages ? ScreenUtil().setWidth(60) : ScreenUtil().setWidth(120),
                          child: TextButton(
                            //style: onBoardingButtonStyle,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(6)),
                                child: Text(
                                  _currentPage != _numberOfPages ? "Next" : "Get Started",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(13),
                                      color: Theme.of(context).primaryColorLight),
                                ),
                              ),
                            ),
                            onPressed: _currentPage != _numberOfPages ? moveToNextItem : getStarted,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= _numberOfPages; i++) {
      list.add(i == _currentPage ? pageIndicator(true) : pageIndicator(false));
    }
    return list;
  }

  moveToNextItem() {
    _pageController.nextPage(duration: const Duration(milliseconds: 750), curve: Curves.ease);
  }

  getStarted() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarded", true).then((value) => Navigator.pushReplacement(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 600),
            type: PageTransitionType.fade,
            child: const AuthenticationSelectionScreen())));
  }
}
