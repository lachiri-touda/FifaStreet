// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/match_details.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class UserMatchsList extends StatefulWidget {
  UserMatchsList({Key? key, required this.myAppUser}) : super(key: key);
  final String routeName = "/userMatchs";
  final User myAppUser;
  @override
  State<UserMatchsList> createState() => _UserMatchsListState();
}

class _UserMatchsListState extends State<UserMatchsList> {
  String? uid;
  Stream<QuerySnapshot>? matchsStream;
  final matchs = FirebaseFirestore.instance.collection('matchs');

  Future<void> deleteMatch(String docId) {
    widget.myAppUser.allMatchs.removeWhere((element) => element.id == docId);
    widget.myAppUser.filterMatchs.removeWhere((element) => element.id == docId);
    return matchs
        .doc(docId)
        .delete()
        .catchError((error) => print("Failed to delete match: $error"));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = auth.FirebaseAuth.instance.currentUser!.uid;
      matchsStream = FirebaseFirestore.instance
          .collection('matchs')
          .where('Admin', isEqualTo: uid.toString())
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBaseColor,
        flexibleSpace: SafeArea(
          child: Stack(children: [
            Center(
                child: Text(
              "Matchs Created",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ))
          ]),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: matchsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            //padding: EdgeInsets.only(top: 15),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Matchs myMatch = Matchs(
                latitude: data['Latitude'].toString(),
                location: data['Location'],
                longitude: data['Longitude'].toString(),
                time: data['Time'],
                players: data['Players'],
                admin: data['Admin'],
                date: data['Date'],
                id: document.id,
                usersJoining: {},
              );
              return SingleChildScrollView(
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close_sharp,
                      color: Colors.red,
                      size: 25,
                    ),
                    onPressed: () => {deleteMatch(document.id)},
                  ),
                  title: Text(
                    "${myMatch.location}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("Date: ${data['Date']} at ${data['Time']}"),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => MatchDetails(
                                match: myMatch,
                                myAppUser: widget.myAppUser,
                                fromMatchsJoined: false,
                              )),
                    ),
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
