import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color error = Colors.red[700]!;
  static Color appColor = Color(0xFFFF70000);
  static final Color primaryColor = Color(0xff36F12C);
  static final Color primaryColorLite = Color(0xff65FF8F);
  static final Color primarySwatchColor = Color(0xff36F12C);
  static final Color primaryDarkColor = Colors.green[700]!;
  static final Color ratingGreyColor = Color(0xffDADADA);
  static final Color ratingYellowColor = Color(0xffF4DD06);
  static final Color addButtonColor = Color(0xff4CAF50);
  static final Color whiteColor = Color(0xffFFFFFF);
  static final Color yellowColor = Color(0xffF4DD06);
  static Color appColorLight = Color(0xFFFB8080);
  

  static final ThemeData appThemeData = ThemeData(
    fontFamily: 'WorkSans',
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorLite,
  );
}
