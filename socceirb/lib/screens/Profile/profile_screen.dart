// ignore_for_fionst_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/services/authentication.dart';
import 'components/info_change.dart';
import 'components/profile_picture.dart';
import 'components/user_info.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  
  //final String routeName = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? userOne;
  User realUserData = User(
    address: 'Enseirb-Matmeca, Telecom Lab',
    email: 'elmehdiamiz@gmail.com',
    name: 'El Mehdi Amiz',
    phone: '0778145071',
    position: 'Milieu Offensif',
  );
  void initState() {
    super.initState();
   // print("object");
    context.read<UserData>().setUser(
          name: realUserData.name,
          phone: realUserData.phone,
          email: realUserData.email,
          address: realUserData.address,
          position: realUserData.position,
        );
  }

  @override
  Widget build(BuildContext context) {
    final myuser = context.watch<AuthenticationService>().firebaseAuth.currentUser;
    /*context.read<UserData>().setUser(
          name: realUserData.name,
          phone: realUserData.phone,
          email: realUserData.email,
          address: realUserData.address,
          position: realUserData.position,
        );*/
    userOne = context.watch<UserData>().userState;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ProfilePicture(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                ),
                UserInfo(
                  label: 'Name',
                  value: userOne!.name,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      "/changeInfo",
                      arguments: UserDetailsArguments(
                        infoType: "Name",
                        userData: userOne!.name,
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Phone Number',
                  value: userOne!.phone,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      "/changeInfo",
                      arguments: UserDetailsArguments(
                        infoType: "Phone Number",
                        userData: userOne!.phone,
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Email address',
                  value: userOne!.email,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      "/changeInfo",
                      arguments: UserDetailsArguments(
                        infoType: "Email address",
                        userData: userOne!.email,
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Address',
                  value: userOne!.address,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      "/changeInfo",
                      arguments: UserDetailsArguments(
                        infoType: "Address",
                        userData: userOne!.address,
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Poste de jeu',
                  value: userOne!.position,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      "/changeInfo",
                      arguments: UserDetailsArguments(
                        infoType: "Poste de jeu",
                        userData: userOne!.position,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserData with ChangeNotifier {
  /*var address = 'Enseirb-Matmeca, Telecom Lab';
  var email = 'elmehdiamiz@gmail.com';
  var name = 'El Mehdi Amiz';
  var phone = '0778145071';
  var position = 'Milieu Offensif';*/
  User userState =
      User(address: '', email: '', name: '', phone: '', position: '');

  void setUser({
    required name,
    required phone,
    required email,
    required address,
    required position,
  }) {
    userState.name = name;
    userState.phone = phone;
    userState.email = email;
    userState.address = address;
    userState.position = position;
  }

  void setValue({required var info, required String newValue}) {
    print(userState.name);
    if (info == "Name") userState.name = newValue;
    if (info == "Phone Number") userState.phone = newValue;
    if (info == "Email address") userState.email = newValue;
    if (info == "Address") userState.address = newValue;
    if (info == "Poste de jeu") userState.position = newValue;
    print(userState.name);

    notifyListeners();
  }
}
