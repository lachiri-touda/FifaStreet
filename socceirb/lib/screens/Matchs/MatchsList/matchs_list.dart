// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/match_details.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class MatchsList extends StatefulWidget {
  MatchsList({Key? key, required this.myAppUser}) : super(key: key);
  final User? myAppUser;
  final String routeName = "/matchs";
  @override
  State<MatchsList> createState() => _MatchsListState();
}

class _MatchsListState extends State<MatchsList> {
  List<Matchs> matchList = [];

  final Stream<QuerySnapshot> matchsStream = FirebaseFirestore.instance
      .collection('matchs')
      .orderBy('Date', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: StreamBuilder<QuerySnapshot>(
          stream: matchsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return snapshot.data != null
                ? ListView(
                    //padding: EdgeInsets.only(top: 10),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
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
                      );
                      return SingleChildScrollView(
                        child: ListTile(
                          title: Text(
                            "${myMatch.location}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff221822),
                            ),
                          ),
                          subtitle: Text(
                            "Date: ${data['Date']} at ${data['Time']}",
                          ),
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      MatchDetails(
                                        match: myMatch,
                                        myAppUser: widget.myAppUser!,
                                      )),
                            ),
                          },
                        ),
                      );
                    }).toList(),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}
