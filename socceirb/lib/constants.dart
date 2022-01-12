import 'package:flutter/material.dart';

class SizeConfig {
  static var screenHeight;
  static var screenWidth;
  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}

Color kGoldenColor = Color(0xfffbb400);
Color kFadedGoldenColor = Color(0xeafbb400);
Color kBaseColor = Color(0xff221822);
Color kFadedBaseColor = Color(0xfa211a2a);
Color kFadedBaseColor2 = Color(0xf3211a2a);
Color kFillColor = Color(0xff28293f);
Color kFadedBgYellowColor = Color(0xfffebe54);
Color kBgYellowColor = Color(0xffffbc3b);
