import 'package:flutter/material.dart';

MaterialColor primaryMaterialColor = MaterialColor(
  0xFFFF7F7F,
  <int, Color>{
    50: Color.fromRGBO(255, 127, 127, .1),
    100: Color.fromRGBO(255, 127, 127, .2),
    200: Color.fromRGBO(255, 127, 127, .3),
    300: Color.fromRGBO(255, 127, 127, .4),
    400: Color.fromRGBO(255, 127, 127, .5),
    500: Color.fromRGBO(255, 127, 127, .6),
    600: Color.fromRGBO(255, 127, 127, .7),
    700: Color.fromRGBO(255, 127, 127, .8),
    800: Color.fromRGBO(255, 127, 127, .9),
    900: Color.fromRGBO(255, 127, 127, 1),
  },
);

const Color bluishClr = Color(0xFF4e5ae8);
const Color red = Color(0xFFEF444C);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFFF4667);
const Color white = Colors.white;
const primaryClr = red;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    fontFamily: "customFont",
    primaryColor: primaryClr,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryMaterialColor,
      brightness: Brightness.light,
    ).copyWith(background: Colors.white),
  );

  static final dark = ThemeData(
    fontFamily: "customFont",
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryMaterialColor,
      brightness: Brightness.dark,
    ).copyWith(background: darkGreyClr),
  );
}
