// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Home/components/home_locationInput.dart';
import 'package:socceirb/screens/Home/components/home_topbar.dart';

class HomeTopContainer extends StatelessWidget {
  const HomeTopContainer({
    Key? key,
    required this.locationController,
  }) : super(key: key);

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.2, 0.9],
            colors: [kBaseColor, kFadedBaseColor, kBaseColor],
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //HomeTopBar(),
              SizedBox(
                height: 10,
              ),
              HomeLocationInput(locationController: locationController)
            ],
          ),
        ),
      ),
    );
  }
}
