import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
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
    final myuser = context.watch<AuthenticationService>().firebaseAuth.currentUser;
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
              InkWell(
              onTap: () => authService.signOut(),
              child: const RoundButton(
                color: Colors.yellow,
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            
            ],
          ),
        ),
      ),
    );
  }
}
