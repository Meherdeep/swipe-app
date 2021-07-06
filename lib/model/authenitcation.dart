// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';

// abstract class BaseAuth {
//   Future<String> signIn(String email, String password);

//   Future<String> signUp(String email, String password);

//   Future<User> getCurrentUser();

//   Future<void> sendEmailVerification();

//   Future<void> signOut();

//   Future<bool> isEmailVerified();
// }

// class Auth implements BaseAuth {
//   Future<String> signIn(String email, String password) async {
//     User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
//     return user.uid;
//   }

//   Future<String> signUp(String email, String password) async {
//     User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
//     return user.uid;
//   }

//   Future<User> getCurrentUser() async {
//     return FirebaseAuth.instance.currentUser;
//   }

//   Future<void> signOut() async {
//     return FirebaseAuth.instance.signOut();
//   }

//   Future<void> sendEmailVerification() async {
//     User user = FirebaseAuth.instance.currentUser;
//     user.sendEmailVerification();
//   }

//   Future<bool> isEmailVerified() async {
//     User user = FirebaseAuth.instance.currentUser;
//     return user.emailVerified;
//   }
// }
