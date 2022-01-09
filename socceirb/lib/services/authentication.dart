import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:socceirb/components/show_dialog.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/user/user_auth.dart';

class AuthenticationService with ChangeNotifier {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
      email: user.email,
      uid: user.uid,
      matchsJoined: {},
      allMatchs: [],
      filterMatchs: [],
    );
  }

  Stream<User?>? get user =>
      firebaseAuth.idTokenChanges().map((user) => _userFromFirebase(user));

  Future signIn(String email, String password, context) async {
    try {
      auth.UserCredential result = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      auth.User? user = result.user;
      return _userFromFirebase(user);
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
      auth.UserCredential result = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      auth.User? user = result.user;
      return _userFromFirebase(user);
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
