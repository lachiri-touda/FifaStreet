// ignore_for_file: avoid_print

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
    return StreamBuilder<UserAuth?>(
      stream: context.watch<AuthenticationService>().user,
      builder: (_, AsyncSnapshot<UserAuth?> snapshot) {
        final isSignedIn = snapshot.data != null ? snapshot.data!.email : null;
        if (isSignedIn != null) {
          print("USER STREAM UPDATED ===> " + snapshot.data!.email.toString());
        }
        return isSignedIn != null
            ? const AppNavigationBottomBar()
            : const SigninScreen();
      },
    );
  }
}
