// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/components/default_textfield.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  final String routeName = "/signup";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    //final authService = Provider.of<AuthenticationService>(context);
    User myAppUser;
    Future<void> addUser(String email, String password, User myAppUser) {
      return users
          .doc(myAppUser.uid)
          .set({
            'Email': email,
            'Password': password,
            'Poste de jeu': '',
            'Address': '',
            'Phone Number': '',
            'Name': '',
            'Profile Picture': '',
            'Matchs joined': '',
          })
          .then((value) => {})
          .catchError((error) => print("Failed to add user: $error"));
    }

    _signup(String email, String password) async {
      User appUser = await context
          .read<AuthenticationService>()
          .createUser(email, password, context);
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
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  const Center(
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  MyTextField(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  DefaultButton(
                      text: "Register",
                      press: () => {
                            _signup(emailController.text,
                                    passwordController.text)
                                .then((value) => {
                                      myAppUser = value,
                                      setState(() => myAppUser = value),
                                      addUser(emailController.text,
                                          passwordController.text, myAppUser),
                                    }),

                            //addUser(emailController.text, passwordController.text)
                          }),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultButton(
                    text: "Sign in",
                    press: () =>
                        Navigator.pushNamed(context, SigninScreen().routeName),
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

class UserDocId {
  String? userId = 'nul';

  UserDocId({required this.userId});
}
