// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/info_change.dart';
import 'package:socceirb/screens/Profile/components/profile_picture.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/components/user_info.dart';

class ProfileOther extends StatelessWidget {
  const ProfileOther({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGoldenColor, //Colors.amber[50],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            //height: SizeConfig.screenHeight * 0.25,
            decoration: fadeColorDecoration(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding: EdgeInsets.only(left: 10),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: kGoldenColor,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    ProfilePicture(
                      myAppUser: user,
                      otherProfile: true,
                    ),
                    SizedBox(height: 10),
                    userName(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Center(child: userAllData(context)),
        ],
      ),
    );
  }

  Text userName() {
    return Text(
      user.name ?? "",
      style: TextStyle(
        color: kGoldenColor,
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  BoxDecoration fadeColorDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.2, 0.9],
        colors: [kBaseColor, kFadedBaseColor, kBaseColor],
      ),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
    );
  }

  SingleChildScrollView userAllData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.05,
          ),
          UserInfo(
            label: 'Phone Number',
            value: user.phone ?? "",
          ),
          UserInfo(
            label: 'Email address',
            value: user.email ?? "",
          ),
          UserInfo(
            label: 'Address',
            value: user.address ?? "",
          ),
          UserInfo(
            label: 'Poste de jeu',
            value: user.position ?? "",
          ),
        ],
      ),
    );
  }
}
