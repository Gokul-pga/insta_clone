import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/SkeletonUi/Post_Screen_Skeleton.dart';
import 'package:insta_clone/screeens/chat_screen.dart';
import 'package:insta_clone/widgets/notification_screen.dart';
import 'package:insta_clone/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController pageController;

  void navigationTaped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    //getUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: SizedBox(
            width: 120,
            height: 40,
            child: Image.asset("assests/png_images/instatexthead.png"),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const NotificationScreen();
                      }));
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 27,
                    )),
                const Positioned(
                    right: 10,
                    top: 16,
                    child: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 9,
                    ))
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ChatScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ));
                },
                icon: const Icon(
                  Icons.messenger_outline,
                  color: Colors.white,
                )),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .orderBy("datePublished")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PostScreenSkeleton();
              //showSnackBar("loading...", context);
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: snapshot.data!.docs[index].data())
                //PostScreenSkeleton()
                );
          },
        ));
  }
}
