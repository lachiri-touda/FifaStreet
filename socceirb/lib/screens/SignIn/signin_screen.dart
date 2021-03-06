// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/components/default_textfield.dart';
import 'package:socceirb/components/round_button.dart';
import 'package:socceirb/components/show_dialog.dart';
import 'package:socceirb/components/text_inputv2.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Home/components/home_locationInput.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';
import 'package:socceirb/services/authentication.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);
  final String routeName = "/signin";

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    auth.FirebaseAuthException? error;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<AuthenticationService>(context);
    User myAppUser;

    _signin(String email, String password) async {
      User appUser = await context
          .read<AuthenticationService>()
          .signIn(email, password, context);
      if (appUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => AppNavigationBottomBar(
              myAppUser: appUser,
            ),
          ),
        );
      }
      return appUser;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.4, 0.8],
                colors: [
                  kBaseColor,
                  kFadedBaseColor,
                  kBaseColor,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  Center(
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: kGoldenColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  TextInputV2(
                      controller: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email),
                  SizedBox(
                    height: 15,
                  ),
                  TextInputV2(
                    controller: passwordController,
                    hintText: "Enter your password",
                    icon: Icons.vpn_key,
                    obscure: true,
                  ),

                  /*MyTextField(
                    controller: emailController,
                    label: 'Email',
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  MyTextField(
                    obscure: true,
                    controller: passwordController,
                    label: 'Password',
                    hintText: "Enter you password",
                  ),*/
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  DefaultButton(
                    bgColor: kGoldenColor,
                    textColor: kBaseColor,
                    text: "Sign In",
                    press: () => {
                      _signin(emailController.text, passwordController.text)
                          .then((value) => {
                                myAppUser = value,
                              }),
                    },
                  ),
                  SizedBox(height: 20),
                  DefaultButton(
                    bgColor: kGoldenColor,
                    textColor: kBaseColor,
                    text: "Create new account",
                    press: () =>
                        Navigator.pushNamed(context, SignupScreen().routeName),
                  ),
                  SizedBox(height: 20),
                  DefaultButton(
                    bgColor: kGoldenColor,
                    textColor: kBaseColor,
                    text: "Direct Test Access",
                    press: () => {
                      //context.read<AuthenticationService>().setTrue(),
                      _signin("zzuser@gmail.com", "azerty").then((value) => {
                            myAppUser = value,
                          }),

                      //setState(() {}),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration inputDecoration({required String label}) {
  return InputDecoration(
    //floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    labelText: label,
    hintText: "Enter your $label",
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[600]!,
        width: 0.2,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[600]!,
        width: 0.2,
      ),
      // borderRadius: new BorderRadius.circular(25.7),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 5,
    ),
  );
}

class HomePageAccess with ChangeNotifier {
  bool signedIn = false;

  void allowAccess() {
    signedIn = true;
    notifyListeners();
  }

  void retrieveAccess() {
    signedIn = false;
    notifyListeners();
  }
}
