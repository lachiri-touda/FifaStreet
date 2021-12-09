// ignore_for_file: prefer_const_constructors,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';

class InfoChange extends StatefulWidget {
  InfoChange({Key? key}) : super(key: key);

  final String routeName = "/changeInfo";
  @override
  _InfoChangeState createState() => _InfoChangeState();
}

class _InfoChangeState extends State<InfoChange> {
  String? newInfo;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = auth.FirebaseAuth.instance.currentUser;
  //final docId = users.where('email', isEqualTo: user!.email). ;

  Future<void> updateUser() {
    return users
        //.where('email', isEqualTo: user!.email)
        .doc()
        .set(
          {
            'email': "newemail@gmail.com",
            'age': "69",
          },
          SetOptions(merge: true),
        )
        .then((value) => print("SUCCESS"))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UserDetailsArguments;
    TextEditingController controller =
        TextEditingController(text: args.userData);

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
                    args.infoType,
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
                    args.infoType,
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
                  //initialValue: args.userData,
                  decoration: inputDecoration(),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => {
                    context.read<UserData>().setValue(
                          newValue: controller.text,
                          info: args.infoType,
                        )
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
                        "Update my ${args.infoType}",
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
      //floatingLabelBehavior: FloatingLabelBehavior.always,
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
        // borderRadius: new BorderRadius.circular(25.7),
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

  UserDetailsArguments({required this.userData, required this.infoType});
}
