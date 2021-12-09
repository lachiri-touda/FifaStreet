// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
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
  String docId = '';

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    //final authService = Provider.of<AuthenticationService>(context);

    _signup(String email, String password) async {
      if (await context
          .read<AuthenticationService>()
          .createUser(email, password, context)) {
        Navigator.pushNamed(context, AppNavigationBottomBar().routeName);
      }
    }

    Future<void> addUser(String email, String password) {
      // Call the user's CollectionReference to add a new user
      return users
          .add({'email': email, 'password': password, 'age': "18"})
          .then((value) => //setState(() => docId = value.id)
              {
                context.read<UserData>().setValue(
                      newValue: value.id,
                      info: "docId",
                    ),
              })
          .catchError((error) => print("Failed to add user: $error"));
    }

    return SafeArea(
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
                    "Create an account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorHeight: 27,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  //onChanged: (value) => {},
                  //onFieldSubmitted: (newValue) => {setState(() {})},
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  cursorHeight: 27,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  //onFieldSubmitted: (newValue) => {setState(() {})},
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.12,
                ),
                DefaultButton(
                    text: "Register",
                    press: () => {
                          _signup(
                              emailController.text, passwordController.text),
                          addUser(emailController.text, passwordController.text)
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
