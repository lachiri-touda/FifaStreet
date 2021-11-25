import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
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
      firebaseAuth.authStateChanges().map(_userFromFirebase);

  Future<UserAuth?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    notifyListeners();
  }

  Future<UserAuth?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    //return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    notifyListeners();
    return await firebaseAuth.signOut();
  }
}
