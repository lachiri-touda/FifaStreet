// ignore_for_fionst_literals_to_create_immutables, prefer_const_constructors

// ignore_for_file: implementation_imports, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'components/info_change.dart';
import 'components/profile_picture.dart';
import 'components/user_info.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.myAppUser}) : super(key: key);
  final User myAppUser;
  final String routeName = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = auth.FirebaseAuth.instance.currentUser;
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getData(widget.myAppUser, "email");
    getData(widget.myAppUser, "name");
    getData(widget.myAppUser, "password");
    getData(widget.myAppUser, "phone");
    getData(widget.myAppUser, "poste");
    getData(widget.myAppUser, "address");
    getData(widget.myAppUser, "profilePic");
  }

  Future<String?> getData(User user, String userData) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var document = users.doc(user.uid);
    document.get().then((data) => {
          if (userData == "email")
            {
              context.read<User>().setValue(
                    info: "Email address",
                    newValue: data["Email"],
                    user: user,
                  )
            },
          if (userData == "password")
            {
              context.read<User>().setValue(
                    info: "Password",
                    newValue: data["Password"],
                    user: user,
                  )
            },
          if (userData == "name")
            {
              context.read<User>().setValue(
                    info: "Name",
                    newValue: data["Name"],
                    user: user,
                  )
            },
          if (userData == "phone")
            {
              context.read<User>().setValue(
                    info: "Phone Number",
                    newValue: data["Phone Number"],
                    user: user,
                  )
            },
          if (userData == "address")
            {
              context.read<User>().setValue(
                    info: "Address",
                    newValue: data["Address"],
                    user: user,
                  )
            },
          if (userData == "poste")
            {
              context.read<User>().setValue(
                    info: "Poste de jeu",
                    newValue: data["Poste de jeu"],
                    user: user,
                  )
            },
          if (userData == "profilePic")
            {
              context.read<User>().setValue(
                    info: "Profile Picture",
                    newValue: data["Profile Picture"],
                    user: user,
                  )
            },
        });
  }

  @override
  Widget build(BuildContext context) {
    getData(widget.myAppUser, "email");
    getData(widget.myAppUser, "name");
    getData(widget.myAppUser, "password");
    getData(widget.myAppUser, "phone");
    getData(widget.myAppUser, "poste");
    getData(widget.myAppUser, "address");
    getData(widget.myAppUser, "profilePic");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () => {
                            context
                                .read<AuthenticationService>()
                                .signOut()
                                .then,
                            Navigator.pushNamed(
                                context, const SigninScreen().routeName),
                          },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black38,
                          ),
                          margin: EdgeInsets.only(right: 10, top: 10),
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ))),
                ),
                ProfilePicture(myAppUser: widget.myAppUser),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                ),
                UserInfo(
                  label: 'Name',
                  value: widget.myAppUser.name ?? "",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Name',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.name ?? "",
                        ),
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Phone Number',
                  value: widget.myAppUser.phone ?? "",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Phone Number',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.phone ?? "",
                        ),
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Email address',
                  value: widget.myAppUser.email ?? "",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Email address',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.email ?? "",
                        ),
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Password',
                  value: "******",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Password',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.password ?? "",
                        ),
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Address',
                  value: widget.myAppUser.address ?? "",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Address',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.address ?? "",
                        ),
                      ),
                    );
                  },
                ),
                UserInfo(
                  label: 'Poste de jeu',
                  value: widget.myAppUser.position ?? "",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => InfoChange(
                          infoType: 'Poste de jeu',
                          myAppUser: widget.myAppUser,
                          uid: widget.myAppUser.uid!,
                          userData: widget.myAppUser.position ?? "",
                        ),
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
