// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/join_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/unjoin_match.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/services/authentication.dart';

class MatchDetails extends StatefulWidget {
  MatchDetails({Key? key, this.match, required this.myAppUser})
      : super(key: key);
  final User myAppUser;
  final String routeName = "matchDetails";
  final Matchs? match;

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
    if (widget.myAppUser.matchsJoined!.keys
        .toList()
        .contains(widget.match!.id)) {
      setState(() {
        alreadyJoined = true;
      });
    }
    Matchs myMatch = widget.match!;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        flexibleSpace: Stack(children: const [
          Center(
              child: Text(
            "Match Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ))
        ]),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                "Match will be played at: ${myMatch.location.toString()}.\n\nMatch will occur in ${myMatch.date.toString()} at: ${myMatch.time.toString()}.\n\nNumber of players needed for this match: ${myMatch.players.toString()}.\n",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Spacer(),
            !alreadyJoined
                ? Align(
                    alignment: Alignment.center,
                    child: DefaultButton(
                      text: 'Join Match',
                      press: () => {
                        context.read<User>().setValue(
                            user: widget.myAppUser,
                            info: "Matchs Joined",
                            newValue: myMatch.id.toString()),
                        joinMatch(
                          user: widget.myAppUser,
                          matchIds:
                              widget.myAppUser.matchsJoined!.keys.toList(),
                          match: widget.match!,
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
                    child: DefaultButton(
                      text: 'Unjoin Match',
                      press: () => {
                        context.read<User>().removeMatchJoined(
                            user: widget.myAppUser, matchId: widget.match!.id!),
                        unjoinMatch(
                          user: widget.myAppUser,
                          match: widget.match!,
                          matchIds:
                              widget.myAppUser.matchsJoined!.keys.toList(),
                        ).then((val) => {
                              setState(() {
                                alreadyJoined = false;
                              }),
                            })
                      },
                    ),
                  ),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
