import 'package:flutter/material.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';

class User with ChangeNotifier {
  String? uid;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? password;
  String? position;
  String? profilePic;
  Map<String, Matchs> matchsJoined;
  List<Matchs> allMatchs;
  List<Matchs> filterMatchs;

  User({
    this.uid,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.address,
    this.position,
    this.profilePic,
    required this.matchsJoined,
    required this.allMatchs,
    required this.filterMatchs,
  });

  void setValue(
      {required User user, required var info, required String newValue}) {
    if (info == "uid") user.uid = newValue;
    if (info == "Name") user.name = newValue;
    if (info == "Phone Number") user.phone = newValue;
    if (info == "Email address") user.email = newValue;
    if (info == "Address") user.address = newValue;
    if (info == "Poste de jeu") user.position = newValue;
    if (info == "Password") user.password = newValue;
    if (info == "Profile Picture") user.profilePic = newValue;
    if (info == "Matchs Joined") {
      user.matchsJoined[newValue] = Matchs(
          admin: '',
          date: '',
          id: '',
          latitude: '',
          location: '',
          longitude: '',
          players: '',
          time: '');
    }
    notifyListeners();
  }

  void addMatchJoined({required User user, required Matchs match}) {
    user.matchsJoined[match.id] = Matchs(
      location: match.location,
      latitude: match.latitude,
      longitude: match.longitude,
      time: match.time,
      players: match.players,
      admin: match.admin,
      date: match.date,
      id: match.id,
    );
    notifyListeners();
  }

  void setMatchsJoined(
      {required User user, required Map<String, Matchs> newValue}) {
    user.matchsJoined = newValue;
    notifyListeners();
  }

  void removeMatchJoined({required User user, required String matchId}) {
    user.matchsJoined.remove(matchId);
    notifyListeners();
  }

  void setFilterMatchs({required User user, required List<Matchs> newValue}) {
    user.filterMatchs = newValue;
    notifyListeners();
  }

  void initFilterMatchs({required User user}) {
    user.filterMatchs = user.allMatchs;
    notifyListeners();
  }

  void decrementPlayersFilterMatchs(
      {required User user, required Matchs match}) {
    int index =
        user.filterMatchs.indexWhere((element) => element.id == match.id);
    user.filterMatchs[index].players =
        (int.parse(user.filterMatchs[index].players) - 1).toString();
    notifyListeners();
  }

  void incrementPlayersFilterMatchs(
      {required User user, required Matchs match}) {
    int index =
        user.filterMatchs.indexWhere((element) => element.id == match.id);
    user.filterMatchs[index].players =
        (int.parse(user.filterMatchs[index].players) + 1).toString();
    notifyListeners();
  }

  List<Matchs> getFilterMatchs(User user) {
    return user.filterMatchs;
  }
}
