import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String name;
  String phone;
  String email;
  String address;
  String position;

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.position,
  });

}
