// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Home extends StatefulWidget {
  final String routeName = "/home";
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthenticationService>().firebaseAuth;
    final myuser =
        context.watch<AuthenticationService>().firebaseAuth.currentUser;
    //SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("home page"),
            ],
          ),
        ),
      ),
    );
  }
}
