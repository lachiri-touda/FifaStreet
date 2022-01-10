import 'package:flutter/material.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class Matchs with ChangeNotifier {
  String location;
  String latitude;
  String longitude;
  String time;
  String players;
  String admin;
  String date;
  String id;
  Map<String, User> usersJoining;

  Matchs({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.players,
    required this.admin,
    required this.date,
    required this.id,
    required this.usersJoining,
  });

  void setUsersJoining(
      {required Matchs match, required Map<String, User> newValue}) {
    match.usersJoining = newValue;
    notifyListeners();
  }

  List<User> getUsersJoining(Matchs match) {
    return match.usersJoining.values.toList();
  }
}
