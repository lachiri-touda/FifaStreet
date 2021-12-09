import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:socceirb/components/show_dialog.dart';
import 'package:socceirb/user/user_auth.dart';

class AuthenticationService with ChangeNotifier {
  bool userState = false;
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  UserAuth? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserAuth(email: user.email, uid: user.uid);
  }

  Stream<UserAuth?>? get user =>
      firebaseAuth.idTokenChanges().map((user) => _userFromFirebase(user));

  Future signIn(String email, String password, context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      print("ERROR MESSAGE ===>" + e.message!);
      showMyDialog(
        message: e.message!,
        title: 'Error',
        context: context,
      );
    }
  }

  Future createUser(String email, String password, context) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      print("ERROR MESSAGE ===>" + e.message!);
      showMyDialog(
        message: e.message!,
        title: 'Error',
        context: context,
      );
    }
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } on auth.FirebaseAuthException catch (e) {
      print("ERROR LOGOUT azertyMESSAGE ===>" + e.message!);
    }
  }
}
