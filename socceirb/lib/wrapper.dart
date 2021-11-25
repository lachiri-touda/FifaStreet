import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:socceirb/user/user_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //bool connected = false;
    //final myuser = context.watch<AuthenticationService>().user;
    final authService = context.watch<AuthenticationService>().firebaseAuth;
    //bool userState = context.watch<AuthenticationService>().userState;
    //final myuser = context.watch<AuthenticationService>().firebaseAuth.currentUser;
    /*myauth.authStateChanges().listen((myuser) {
    if (myuser == null) {
      setState(() {
      connected = false;
    });
      print('User is currently signed out!');
    } else {
      setState(() {
      connected = true;
    });
      print(myuser.email);
    }
  });*/
    return //connected ? SigninScreen() : AppNavigationBottomBar();
    StreamBuilder<User?>(
        stream: authService.authStateChanges(),
        builder: (_, snapshot) {
          final isSignedIn = snapshot.data != null;
          return isSignedIn ? AppNavigationBottomBar() : SigninScreen();
        },
      );
       // myuser == null ? SigninScreen() : AppNavigationBottomBar();
    /*final authService = Provider.of<AuthenticationService>(context);
    return StreamBuilder<UserAuth?>(
      stream: context.watch<AuthenticationService>().user,
      builder: (_, AsyncSnapshot<UserAuth?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserAuth? user = snapshot.data;
          return user == null ? SigninScreen() : AppNavigationBottomBar();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );*/
  }
}
