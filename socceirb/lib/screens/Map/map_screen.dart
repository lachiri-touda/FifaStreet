// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/screens/NewMatch/components/matchs.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);
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
              markers.add(Marker(
                  markerId: MarkerId('Id2'),
                  position: LatLng(data['Latitude'], data['Longitude']),
                  infoWindow: InfoWindow(title: data['Location'])));
              /* matchList.add(Matchs(
                  admin: uid,
                  latitude: data['Latitude'],
                  location: data['Location'],
                  longitude: data['Longitude'],
                  players: data['Players'],
                  time: data['Time']));*/
            }).toList();
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
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
