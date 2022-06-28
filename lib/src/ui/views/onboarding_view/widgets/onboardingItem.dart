
import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingItem extends StatelessWidget {
  final String? imageAsset;
  final String? title;
  final String? description;
  const OnBoardingItem({this.imageAsset, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(imageAsset!),
              height: ScreenUtil().setHeight(300),
              width: ScreenUtil().setWidth(300),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text(
            title!,
            style: TextStyle(color: Colors.white, fontSize: 27, fontFamily: "Palatino", fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(7),
          ),
          Text(
            description!,
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Palatino"),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}