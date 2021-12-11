import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? uid;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? password;
  String? position;

  User({
    this.uid,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.address,
    this.position,
  });

  void setValue(
      {required User user, required var info, required String newValue}) {
    //print(user.name);
    if (info == "uid") user.uid = newValue;
    if (info == "Name") user.name = newValue;
    if (info == "Phone Number") user.phone = newValue;
    if (info == "Email address") user.email = newValue;
    if (info == "Address") user.address = newValue;
    if (info == "Poste de jeu") user.position = newValue;
    if (info == "Password") user.password = newValue;
    //print(user.name);

    notifyListeners();
  }
}
