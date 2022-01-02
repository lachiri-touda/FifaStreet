// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/MatchsList/match_joined.dart';
import 'package:socceirb/screens/Matchs/MatchsList/matchs_list.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Home extends StatefulWidget {
  Home({Key? key, required this.myAppUser}) : super(key: key);
  final User myAppUser;
  final String routeName = "/home";

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool allMatchs = true;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  @override
  void initState() {
    super.initState();
    getJoinedMatchs();
  }

  Future<String?> getJoinedMatchs() async {
    var document = users.doc(widget.myAppUser.uid);
    List<String> matchsJoinedIds = [];
    Map<String, Matchs> map = {};
    await document.get().then((data) => {
          if (data['Matchs joined'].length == 0)
            {
              matchsJoinedIds.add(''),
            }
          else
            {
              for (var elm in data['Matchs joined'])
                {
                  matchsJoinedIds.add(elm),
                },
            }
        });
    for (var match in matchsJoinedIds) {
      var document = matchs.doc(match);
      document.get().then((data) => {
            map[match] = Matchs(
              location: data['Location'],
              latitude: data['Latitude'].toString(),
              longitude: data['Longitude'].toString(),
              date: data['Date'],
              time: data['Time'],
              players: data['Players'],
              id: document.id,
            )
          });
    }
    /*setState(() {
      widget.myAppUser.matchsJoined = map;
    });*/
    context.read<User>().setMatchsJoined(user: widget.myAppUser, newValue: map);
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthenticationService>().firebaseAuth;
    final myuser =
        context.watch<AuthenticationService>().firebaseAuth.currentUser;
    //SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          flexibleSpace: Stack(children: [
            Center(
                child: Text(
              "Matchs List",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ))
          ]),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: SizeConfig.screenHeight * 0.04,
                width: SizeConfig.screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => {
                        setState(() => {
                              allMatchs = true,
                            })
                      },
                      child: Text(
                        "All Matchs",
                        style: TextStyle(
                            color: allMatchs ? Colors.white : Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        setState(() => {
                              allMatchs = false,
                            })
                      },
                      child: Text(
                        "Matchs Joined",
                        style: TextStyle(
                            color: !allMatchs ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              allMatchs
                  ? Expanded(
                      child: MatchsList(myAppUser: widget.myAppUser),
                    )
                  : Expanded(
                      child: MatchsJoined(myAppUser: widget.myAppUser),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
