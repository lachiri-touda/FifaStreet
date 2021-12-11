// ignore_for_file: prefer_const_constructors,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';

class InfoChange extends StatefulWidget {
  InfoChange(
      {Key? key,
      required this.myAppUser,
      required this.infoType,
      required this.userData,
      required this.uid})
      : super(key: key);

  User myAppUser;
  String userData;
  final String infoType;
  String uid;

  final String routeName = "/changeInfo";
  @override
  _InfoChangeState createState() => _InfoChangeState();
}

class _InfoChangeState extends State<InfoChange> {
  String? newInfo;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final user = auth.FirebaseAuth.instance.currentUser;
    //final docId = users.where('email', isEqualTo: user!.email). ;

    updateUser({required String dataToUpdate, required String newValue}) {
      if (dataToUpdate == "Email address") {
        users.doc(widget.uid).set(
          {
            'Email': newValue,
          },
          SetOptions(merge: true),
        );
        user!.updateEmail(newValue);
      }
      if (dataToUpdate == "Name") {
        users.doc(widget.uid).set(
          {
            'Name': newValue,
          },
          SetOptions(merge: true),
        );
      }
      if (dataToUpdate == "Phone Number") {
        users.doc(widget.uid).set(
          {
            'Phone Number': newValue,
          },
          SetOptions(merge: true),
        );
      }
      if (dataToUpdate == "Address") {
        users.doc(widget.uid).set(
          {
            'Address': newValue,
          },
          SetOptions(merge: true),
        );
      }
      if (dataToUpdate == "Poste de jeu") {
        users.doc(widget.uid).set(
          {
            'Poste de jeu': newValue,
          },
          SetOptions(merge: true),
        );
      }
      if (dataToUpdate == "Password") {
        users.doc(widget.uid).set(
          {
            'Password': newValue,
          },
          SetOptions(merge: true),
        );
        user!.updatePassword(newValue);
      }
    }

    TextEditingController controller =
        TextEditingController(text: widget.userData);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: SizeConfig.screenHeight * 0.058,
          flexibleSpace: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.purple,
                            size: 23,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  //margin: EdgeInsets.only(right: 135),
                  child: Text(
                    widget.infoType,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 40, bottom: 10),
                  child: Text(
                    widget.infoType,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextField(
                  cursorHeight: 27,
                  controller: controller,
                  decoration: inputDecoration(),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => {
                    context.read<User>().setValue(
                        newValue: controller.text,
                        info: widget.infoType,
                        user: widget.myAppUser),
                    updateUser(
                        dataToUpdate: widget.infoType,
                        newValue: controller.text),
                    Navigator.pop(context),
                  },
                  child: Container(
                    height: SizeConfig.screenHeight * 0.045,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 0.08,
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Update my ${widget.infoType}",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[600]!,
          width: 0.2,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[600]!,
          width: 0.2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
    );
  }
}

class UserDetailsArguments {
  String userData;
  final String infoType;
  String uid;
  User myUser;

  UserDetailsArguments(
      {required this.userData,
      required this.infoType,
      required this.uid,
      required this.myUser});
}
