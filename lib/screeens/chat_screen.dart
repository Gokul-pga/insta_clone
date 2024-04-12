import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/SkeletonUi/Chat_Screen_Ui.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/screeens/signin.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetails();
  }

  var userdetails = {};
  void fetchDetails() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userdetails = snap.data()!;
    setState(() {
      //username = (snap.data() as Map<String, dynamic>)['username'];
      //profilepic = (snap.data() as Map<String, dynamic>)['photoUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
        child: Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MobileScreenLauyout();
                  }));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  //'https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_1280.jpg'
                                                  userdetails['photoUrl']),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                            userdetails['username'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          )),
                                          Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.blueAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        height: 15,
                                        color: Colors.transparent,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return SigninScreen();
                                          }));
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "Add account",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ))),
                                            IconButton(
                                                onPressed: () {
                                                  print("object");
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: 25,
                                                  weight: 30,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Row(
                    children: [
                      Text(
                        userdetails['username'],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  )),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.video_call_outlined,
                      color: Colors.white,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.note_alt_outlined,
                      color: Colors.white,
                      size: 27,
                    ))
              ],
            ),
            body: ChatScreenSkeleton()));
  }
}
