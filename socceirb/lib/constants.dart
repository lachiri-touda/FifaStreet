import 'package:flutter/material.dart';

class SizeConfig {
  static var screenHeight;
  static var screenWidth;
  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
//