// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:socceirb/components/app_logo.dart';
import 'package:socceirb/constants.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.06,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: AppLogo(),
            ),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
