import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  showErrDialog(BuildContext context, String err) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog(
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(err),
        actions: <Widget>[
          OutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
      context: context,
    );
  }

  //SignUP

  Future<User> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: email);
      User user = result.user;
      return Future.value(user);
      // return Future.value(true);
    } catch (error) {
      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          showErrDialog(context, "Email Already  Exists");
          break;
        case 'ERROR_INVALID_EMAIL':
          showErrDialog(context, "Invalid Email Address");
          break;
        case 'ERROR_WEAK_PASSWORD':
          showErrDialog(context, "Please Choose a stronger password");
          break;
      }
      return Future.value(null);
    }
  }

  // Future registerEmailPass(String email, String password) async {
  //   try {
  //     UserCredential result = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     User user = result.user;
  //     return user;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  //SignIn

  Future<User> signin(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result =
          await auth.signInWithEmailAndPassword(email: email, password: email);
      User user = result.user;
      // return Future.value(true);
      return Future.value(user);
    } catch (e) {
      // simply passing error code as a message
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_WRONG_PASSWORD':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_NOT_FOUND':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_DISABLED':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showErrDialog(context, e.code);
          break;
      }
      return Future.value(null);
    }
  }
  // Future<User> newLogin(String email, String password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return result.user;
  //   } on FirebaseAuthException catch (e) {
  //     return e.toString();
  //   }
  // }

  //SignOut

  Future<void> signOut() async {
    await auth.signOut();
  }
}
