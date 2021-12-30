// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<void> addMatch(
    {required CollectionReference matchs,
    required String uidAdmin,
    required String position,
    required String time,
    String? playersNum}) async {
  List<Location> locations = await locationFromAddress(position);
  matchs
      .doc()
      .set({
        'Admin': uidAdmin,
        'Location': position,
        'Latitude': locations[0].latitude,
        'Longitude': locations[0].longitude,
        'Time': time,
        'Players': playersNum,
      })
      .then((value) => {})
      .catchError((error) => print("Failed to create match: $error"));
}
