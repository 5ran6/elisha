import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryColor = Color(0XFF317CFB);
const kWhiteColor = Color(0XFFFFFFFF);
const kBlackColor = Color(0XFF000000);
const kDescriptionTextColor = Color(0XFF002434);
const kDotsColor = Color(0XFF212121);

final kDefaultHorizontalPadding = ScreenUtil().setWidth(20);
final kDefaultVerticalPadding = ScreenUtil().setHeight(10);
final double kDefaultButtonRadius = ScreenUtil().radius(30);
final onBoardingButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
  shape: MaterialStateProperty.all<OutlinedBorder>(
    const CircleBorder(),
  ),
);

// The screen sizes
final screenHeight = ScreenUtil().setHeight(690);
final screenWidth = ScreenUtil().setWidth(360);

final kTextFieldDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  enabledBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white70),
  ),
  focusedBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white70),
  ),
  border: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white70),
  ),
  labelStyle: TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(12),
  ),
  hintStyle: TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(12),
  ),
);
const k2TextFieldDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
);
final kTextFieldStyle = TextStyle(
  color: Colors.white,
  fontSize: ScreenUtil().setSp(12),
);

final kTextStyle = TextStyle(
  color: kBlackColor,
  fontSize: ScreenUtil().setSp(12),
);

final kTitleTextStyle = TextStyle(color: kBlackColor, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w700);
final kBodyTextStyle = TextStyle(
  color: Colors.white,
  fontSize: ScreenUtil().setSp(12),
);
final kDescriptionTextStyle = TextStyle(
  color: kDescriptionTextColor,
  fontSize: ScreenUtil().setSp(14),
);
final kDrawerTextStyle = TextStyle(
  color: kPrimaryColor,
  fontSize: ScreenUtil().setSp(14),
);

Widget pageIndicator(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 250,
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    height: ScreenUtil().setHeight(10),
    width: isActive ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(10),
    decoration: BoxDecoration(
      color: isActive ? kWhiteColor : kWhiteColor,
      borderRadius: BorderRadius.all(
        Radius.circular(ScreenUtil().setWidth(10)),
      ),
    ),
  );
}

deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Future<bool?> checkInternetConnectivity() async {
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       print('connected');
//       return true;
//     }
//   } on SocketException catch (_) {
//     print('not connected');
//     return false;
//   }
//   return null;
// }

String insertCommasInString(String value) {
  return value.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
}

dynamic lightSetting = cantonLightTheme().copyWith(
    primaryColor: const Color(0xFF030C5A),
    colorScheme: cantonLightTheme().colorScheme.copyWith(primaryContainer: const Color(0xFF030C5A)));
dynamic darkSetting = cantonDarkTheme().copyWith(
    primaryColor: const Color(0xFF0B83B3),
    colorScheme: cantonDarkTheme().colorScheme.copyWith(primaryContainer: const Color(0xFF0B83B3)));
