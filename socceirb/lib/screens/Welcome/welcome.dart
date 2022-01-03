// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Socc",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "Eirb",
                              style: TextStyle(
                                color: Color(0xfffbb400),
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Your New Way to Organize Matchs!",
                          style: TextStyle(
                            color: Color(0xfffbb400),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          DefaultButton(
                            text: "Connexion",
                            press: () => {
                              Navigator.pushNamed(
                                  context, SigninScreen().routeName),
                            },
                            bgColor: kGoldenColor,
                            textColor: kBaseColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DefaultButton(
                            text: "Create an account",
                            press: () => {
                              Navigator.pushNamed(
                                  context, SignupScreen().routeName),
                            },
                            bgColor: kGoldenColor,
                            textColor: kBaseColor,
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }
}
