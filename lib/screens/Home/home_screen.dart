import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/components/round_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  final String routeName = "/home";
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int ctr = 0;
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
              if (myuser != null) Text("${myuser.email}"),
              Text("home page $ctr"),
              RoundButton(
                color: Colors.red,
                icon: const Icon(Icons.add),
                press: () => {
                  setState(() {
                    ctr++;
                  })
                },
              ),
              DefaultButton(
                text: "Sign out",
                press: () => {
                  context.read<AuthenticationService>().signOut().then,
                  Navigator.pushNamed(context, const SigninScreen().routeName),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
