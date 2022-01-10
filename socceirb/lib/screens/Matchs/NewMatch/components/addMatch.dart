// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

Future<bool> addMatch(
    {required CollectionReference matchs,
    required String uidAdmin,
    required User user,
    required String position,
    required String time,
    required String date,
    String? playersNum}) async {
  bool success = false;
  List<Location> locations = await locationFromAddress(position);
  Matchs thisMatch;
  matchs
      .add({
        'Admin': uidAdmin,
        'Location': position,
        'Latitude': locations[0].latitude,
        'Longitude': locations[0].longitude,
        'Date': date,
        'Time': time,
        'Players': playersNum,
      })
      .then((doc) => {
            thisMatch = Matchs(
              latitude: locations[0].latitude.toString(),
              location: position,
              longitude: locations[0].longitude.toString(),
              date: date,
              id: doc.id,
              admin: user.uid ?? "",
              time: time,
              players: playersNum ?? "",
            ),
            user.allMatchs.add(thisMatch),
            user.filterMatchs.add(thisMatch),
            success = true,
          })
      .catchError((error) => print("Failed to create match: $error"));

  return success;
}
