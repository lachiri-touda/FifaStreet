// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socceirb/screens/NewMatch/components/matchs.dart';

class MatchsList extends StatefulWidget {
  MatchsList({Key? key}) : super(key: key);
  final String routeName = "/matchs";
  @override
  State<MatchsList> createState() => _MatchsListState();
}

class _MatchsListState extends State<MatchsList> {
  final LatLng _center = const LatLng(44.837789, -0.57918);
  List<Matchs> matchList = [];

  final Stream<QuerySnapshot> matchsStream =
      FirebaseFirestore.instance.collection('matchs').snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          flexibleSpace: Stack(children: const [
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
        body: StreamBuilder<QuerySnapshot>(
          stream: matchsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
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
                          "Location: ${data['Location']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text("Time: ${data['Time']}"),
                        onTap: () => {},
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
