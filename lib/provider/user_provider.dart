import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart' as modal;
import 'package:insta_clone/resource/auth_methods.dart';

class UserProvider with ChangeNotifier {
  modal.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  modal.User get getUser => _user!;

  Future<void> refreshUser() async {
    String txt = "error occurred";
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapshot.exists) {
        modal.User user = await _authMethods.getUserDetails();
        _user = user;
        notifyListeners();
        txt = "Success";
      } else
        (err) {
          print('Error fetching user details: $err');
          txt = "Failled";
        };
    } catch (err) {
      print("Data does not exists: $err");
      txt;
    }
  }
}
