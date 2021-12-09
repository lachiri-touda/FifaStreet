import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String docId;
  String name;
  String phone;
  String? email;
  String address;
  String password;
  String position;

  User({
    required this.docId,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.position,
  });
}
