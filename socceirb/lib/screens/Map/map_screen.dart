// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/match_details.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, required this.myAppUser}) : super(key: key);
  final User myAppUser;
  final String routeName = "/map";
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = <Marker>[];
  final LatLng _center = const LatLng(44.837789, -0.57918);
  List<Matchs> matchList = [];
  //CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  final Stream<QuerySnapshot> matchsStream =
      FirebaseFirestore.instance.collection('matchs').snapshots();
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: matchsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              markers.add(Marker(
                  markerId: MarkerId(document.id),
                  position: LatLng(data['Latitude'], data['Longitude']),
                  infoWindow: InfoWindow(
                    title: data['Location'],
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => MatchDetails(
                                  match: myMatch,
                                  myAppUser: widget.myAppUser,
                                )),
                      ),
                    },
                  )));
              /* matchList.add(Matchs(
                  admin: uid,
                  latitude: data['Latitude'],
                  location: data['Location'],
                  longitude: data['Longitude'],
                  players: data['Players'],
                  time: data['Time']));*/
            }).toList();
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(markers),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 13,
                  ),
                ),
                /*DefaultButton(
                    text: "Mat",
                    press: () => {
                          print(matchList.length),
                        }),*/
              ],
            );
          },
        ),
      ),
    );
  }
}
