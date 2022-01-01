// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/match_details.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class MatchsJoined extends StatefulWidget {
  MatchsJoined({Key? key, required this.myAppUser}) : super(key: key);
  final User myAppUser;
  final String routeName = "/matchsJoined";
  @override
  State<MatchsJoined> createState() => _MatchsListState();
}

class _MatchsListState extends State<MatchsJoined> {
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = auth.FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    Set<Matchs> matchsList = {};
    final Stream<QuerySnapshot> matchsJoinedStream =
        FirebaseFirestore.instance.collection('matchs_joined').snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: matchsJoinedStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Location: ${widget.myAppUser.matchsJoined![data['MatchId']]!.location}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                          "Date: ${widget.myAppUser.matchsJoined![data['MatchId']]!.date} at ${widget.myAppUser.matchsJoined![data['MatchId']]!.time}"),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => MatchDetails(
                                    match: widget.myAppUser
                                        .matchsJoined![data['MatchId']]!,
                                    myAppUser: widget.myAppUser,
                                  )),
                        ),
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
