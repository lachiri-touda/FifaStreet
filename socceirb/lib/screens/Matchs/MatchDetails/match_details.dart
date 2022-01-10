// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/join_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/unjoin_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/joining_users_data.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/services/authentication.dart';

class MatchDetails extends StatefulWidget {
  MatchDetails(
      {Key? key,
      required this.match,
      required this.myAppUser,
      required this.fromMatchsJoined})
      : super(key: key);
  final User myAppUser;
  final String routeName = "matchDetails";
  final Matchs match;
  final bool fromMatchsJoined;

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  CollectionReference matchsJoinedDb =
      FirebaseFirestore.instance.collection('matchs_joined');
  final user = auth.FirebaseAuth.instance.currentUser;
  bool alreadyJoined = false;

  @override
  void initState() {
    super.initState();
    getJoiningUsers();
  }

  Future<String?> getJoiningUsers() async {
    var document = matchs.doc(widget.match.id);
    bool isEmpty = false;
    List<String> joiningUsersIds = [];
    Map<String, User> map = {};
    await document.get().then((data) => {
          if (data['Joining Users'].length != 0)
            {
              for (var elm in data['Joining Users'])
                {
                  joiningUsersIds.add(elm),
                },
            }
          else
            {
              isEmpty = true,
            }
        });
    if (!isEmpty) {
      for (var userId in joiningUsersIds) {
        var document = users.doc(userId);
        document.get().then((data) => {
              map[userId] = User(
                name: data['Name'],
                email: data["Email"],
                phone: data["Phone Number"],
                address: data["Address"],
                position: data["Poste de jeu"],
                profilePic: data["Profile Picture"],
                matchsJoined: {},
                allMatchs: [],
                filterMatchs: [],
              )
            });
      }
    }
    /*setState(() {
      widget.match.usersJoining = map;
    });*/
    context.read<Matchs>().setUsersJoining(match: widget.match, newValue: map);
  }

  @override
  Widget build(BuildContext context) {
    //getJoiningUsers();
    List<User> matchJoiningUsers =
        context.read<Matchs>().getUsersJoining(widget.match);
    if (widget.myAppUser.matchsJoined.keys.toList().contains(widget.match.id)) {
      setState(() {
        alreadyJoined = true;
      });
    }
    Matchs myMatch = widget.match;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBaseColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kGoldenColor,
            size: 23,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: SafeArea(
          child: Stack(children: [
            Center(
                child: Text(
              "Match Details",
              style: TextStyle(
                color: kGoldenColor,
                fontSize: 20,
              ),
            ))
          ]),
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              color: Colors.amber[50],
            ),
            child: myMatch != null
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            "Match will be played at: ${myMatch.location.toString()}.\n\nMatch will occur in ${myMatch.date.toString()} at: ${myMatch.time.toString()}.\n\nNumber of players needed: ${myMatch.players.toString()}.\n",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xff221822),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Players",
                            style: TextStyle(
                              color: kBaseColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            height: SizeConfig.screenHeight * 0.36,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("matchs_joined")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Container();
                                  default:
                                    return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.docs[index].data()!
                                                  as Map<String, dynamic>;
                                          return widget.match.id ==
                                                  data['MatchId']
                                              ? Column(
                                                  children: [
                                                    JoiningUsersData(
                                                      doc: snapshot
                                                          .data!.docs[index],
                                                      match: widget.match,
                                                    ),
                                                    //Divider()
                                                  ],
                                                )
                                              : Container();
                                        });
                                }
                              },
                            )),
                        Spacer(),
                      ],
                    ),
                  )
                : Center(child: Text("Refresh the page")),
          ),
        ),
        !alreadyJoined
            ? (int.parse(myMatch.players)) > 0
                ? Align(
                    alignment: Alignment(0, 1.1),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40),
                      child: DefaultButton(
                        textColor: kGoldenColor,
                        text: 'Join Match',
                        press: () => {
                          widget.match.usersJoining[widget.myAppUser.uid
                              .toString()] = widget.myAppUser,
                          context.read<User>().setValue(
                              user: widget.myAppUser,
                              info: "Matchs Joined",
                              newValue: myMatch.id.toString()),
                          context.read<User>().decrementPlayersFilterMatchs(
                              user: widget.myAppUser, match: myMatch),
                          if (widget.fromMatchsJoined)
                            {
                              myMatch.players =
                                  (int.parse(myMatch.players) - 1).toString()
                            },
                          joinMatch(
                            user: widget.myAppUser,
                            matchIds:
                                widget.myAppUser.matchsJoined.keys.toList(),
                            match: widget.match,
                          ).then(
                            (value) => setState(() {
                              alreadyJoined = true;
                            }),
                          ),
                        },
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment(0, 1.1),
                    child: Container(
                      height: SizeConfig.screenHeight * 0.06,
                      width: SizeConfig.screenWidth * 0.7,
                      margin: EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: kBaseColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          "Match Full",
                          style: TextStyle(
                            color: kGoldenColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  )
            : Align(
                alignment: Alignment(0, 1.1),
                child: Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: DefaultButton(
                    textColor: kGoldenColor,
                    text: 'Unjoin Match',
                    press: () => {
                      widget.match.usersJoining.remove(widget.myAppUser.uid),
                      context.read<User>().removeMatchJoined(
                          user: widget.myAppUser, matchId: widget.match.id),
                      unjoinMatch(
                        user: widget.myAppUser,
                        match: widget.match,
                        matchIds: widget.myAppUser.matchsJoined.keys.toList(),
                      ).then((val) => {
                            setState(() {
                              alreadyJoined = false;
                            }),
                          }),
                      context.read<User>().incrementPlayersFilterMatchs(
                          user: widget.myAppUser, match: myMatch),
                      if (widget.fromMatchsJoined)
                        {
                          myMatch.players =
                              (int.parse(myMatch.players) + 1).toString()
                        }
                    },
                  ),
                ),
              ),
      ]),
    );
  }
}
