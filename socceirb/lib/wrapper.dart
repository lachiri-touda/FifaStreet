// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
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
    //Stream<User?>? myAppUser = context.watch<AuthenticationService>().user;
    SizeConfig().init(context);
    return StreamBuilder<User?>(
      stream: context.watch<AuthenticationService>().user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        final isSignedIn = snapshot.data != null ? true : false;
        /*if (isSignedIn) {
          print("USER STREAM UPDATED ===> " + snapshot.data!.email.toString());
        }*/
        return isSignedIn
            ? AppNavigationBottomBar(
                myAppUser: snapshot.data,
              )
            : const SigninScreen();
      },
    );
  }
}
