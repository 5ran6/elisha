import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  final primaryColor = const Color(0XFF70648C);
  final whiteColor = const Color(0XFFFFFFFF);
  static const greyColor1 = Color(0XFF5B5B5B);
  static const greyColor2 = Color(0XFF6B6B6B);
  static final kdisplayLarge =
      TextStyle(color: kBlackColor, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w700);
  static final kdisplayMedium = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(20),
  );
  static final kBodyTextStyle = TextStyle(
    color: kDescriptionTextColor,
    fontSize: ScreenUtil().setSp(14),
  );
  static final kButtonTextStyle = TextStyle(
    color: kWhiteColor,
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w700,
  );
  static final kBottomLabelUnselectedTextStyle = TextStyle(
    color: kDescriptionTextColor,
    fontSize: ScreenUtil().setSp(12),
  );
  static final kBottomLabelSelectedTextStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w700,
  );

  static const String lightFontFamily = "Ubuntu-Light";
  static const String mediumFontFamily = "Ubuntu-Medium";
  static final Color loginCard = Colors.white.withOpacity(0.98);
  static const Color loadingColor = blueTheme;
  static const Color blueTheme = Color(0XFFC73EF5);
  static final Color iconContainerColor = AppTheme.blueTheme.withOpacity(0.8);
  static const kPrimaryColor = Color(0XFFC73EF5);
  static const kWhiteColor = Color(0XFFFFFFFF);
  static const kBlackColor = Color(0XFF000000);
  static const kDescriptionTextColor = Color(0XFF002434);
  static const kDotsColor = Color(0XFF212121);
  static const kGreyColor = Color(0XFF8F92A1);
  static final LinearGradient loginBackPainter = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.white.withOpacity(0.95), Colors.grey],
  );

  static TextStyle whiteBold = const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu');
  static TextStyle whiteNormal =
      const TextStyle(color: kWhiteColor, fontWeight: FontWeight.normal, fontFamily: 'Ubuntu');
  static TextStyle whiteBoldWithSpacing =
      const TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontFamily: 'Ubuntu');
  static TextStyle blackBold = const TextStyle(color: kBlackColor, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu');
  static TextStyle blackNormal =
      const TextStyle(color: kBlackColor, fontWeight: FontWeight.normal, fontFamily: 'Ubuntu');

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Ubuntu',
    brightness: Brightness.light,
    scaffoldBackgroundColor: kWhiteColor,
    //textSelectionHandleColor: Colors.grey[600],
    //textSelectionColor: Colors.black,
    shadowColor: Colors.black12,
    splashColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: const IconThemeData(),
      unselectedIconTheme: const IconThemeData(),
      selectedLabelStyle: kBottomLabelSelectedTextStyle,
      unselectedLabelStyle: kBottomLabelUnselectedTextStyle,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kGreyColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kGreyColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: kGreyColor),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: kdisplayLarge,
      displayMedium: kdisplayMedium,
      bodyLarge: kBodyTextStyle,
      bodyMedium: kBodyTextStyle.copyWith(fontSize: ScreenUtil().setSp(12)),
    ),
    cardColor: kWhiteColor,
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    focusColor: Colors.transparent,
    canvasColor: Colors.transparent,
    hoverColor: Colors.transparent,
    primaryColor: kPrimaryColor,
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B0D24),
    //textSelectionHandleColor: Colors.white,
    //textSelectionColor: Colors.grey[200],
    shadowColor: Colors.black12,
    splashColor: Colors.transparent,

    cardColor: const Color(0xFF24174D),
    splashFactory: InkRipple.splashFactory,
    highlightColor: Colors.transparent,
    canvasColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
