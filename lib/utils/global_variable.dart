import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screeens/add_post_screen.dart';
import 'package:insta_clone/screeens/feed_screen.dart';
import 'package:insta_clone/screeens/profile_screen.dart';
import 'package:insta_clone/screeens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(
    child: Text(
      "Rees Screen",
      style: TextStyle(color: Colors.cyan),
    ),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
