// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/join_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/unjoin_match.dart';
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
  CollectionReference matchsJoinedDb =
      FirebaseFirestore.instance.collection('matchs_joined');
  final user = auth.FirebaseAuth.instance.currentUser;
  bool alreadyJoined = false;

  @override
  Widget build(BuildContext context) {
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
      body: Container(
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        "Match will be played at: ${myMatch.location.toString()}.\n\nMatch will occur in ${myMatch.date.toString()} at: ${myMatch.time.toString()}.\n\nNumber of players needed: ${myMatch.players.toString()}.\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff221822),
                        ),
                      ),
                    ),
                    Spacer(),
                    !alreadyJoined
                        ? (int.parse(myMatch.players)) > 0
                            ? Align(
                                alignment: Alignment.center,
                                child: DefaultButton(
                                  textColor: kGoldenColor,
                                  text: 'Join Match',
                                  press: () => {
                                    context.read<User>().setValue(
                                        user: widget.myAppUser,
                                        info: "Matchs Joined",
                                        newValue: myMatch.id.toString()),
                                    context
                                        .read<User>()
                                        .decrementPlayersFilterMatchs(
                                            user: widget.myAppUser,
                                            match: myMatch),
                                    if (widget.fromMatchsJoined)
                                      {
                                        myMatch.players =
                                            (int.parse(myMatch.players) - 1)
                                                .toString()
                                      },
                                    joinMatch(
                                      user: widget.myAppUser,
                                      matchIds: widget
                                          .myAppUser.matchsJoined.keys
                                          .toList(),
                                      match: widget.match,
                                    ).then(
                                      (value) => setState(() {
                                        alreadyJoined = true;
                                      }),
                                    ),
                                  },
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.06,
                                  width: SizeConfig.screenWidth * 0.7,
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
                            alignment: Alignment.center,
                            child: DefaultButton(
                              textColor: kGoldenColor,
                              text: 'Unjoin Match',
                              press: () => {
                                context.read<User>().removeMatchJoined(
                                    user: widget.myAppUser,
                                    matchId: widget.match.id),
                                unjoinMatch(
                                  user: widget.myAppUser,
                                  match: widget.match,
                                  matchIds: widget.myAppUser.matchsJoined.keys
                                      .toList(),
                                ).then((val) => {
                                      setState(() {
                                        alreadyJoined = false;
                                      }),
                                    }),
                                context
                                    .read<User>()
                                    .incrementPlayersFilterMatchs(
                                        user: widget.myAppUser, match: myMatch),
                                if (widget.fromMatchsJoined)
                                  {
                                    myMatch.players =
                                        (int.parse(myMatch.players) + 1)
                                            .toString()
                                  }
                              },
                            ),
                          ),
                    Spacer(),
                  ],
                ),
              )
            : Center(child: Text("Refresh the page")),
      ),
    );
  }
}
