import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_clone/resource/firestore_methods.dart';
import 'package:insta_clone/widgets/add_tofavourites.dart';
import 'package:insta_clone/widgets/follow_button.dart';
import 'package:insta_clone/widgets/profile_edit_screen.dart';
import 'package:insta_clone/screeens/signin.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:get/get.dart';
import 'package:insta_clone/widgets/profile_view_screen.dart';
import 'package:insta_clone/widgets/saved_posts.dart';

class ProfileScreen extends StatefulWidget {
  final uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails();
    postDetails();
    print("Profile Screen");
  }

  int followers = 0;
  int following = 0;
  int postcount = 0;
  var userData = {};
  bool isFollowing = false;

  void userDetails() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      if (snap.exists) {
        setState(() {
          userData = snap.data()!;
          // Handle followers and following as lists and get their lengths
          followers = (userData['followers'] as List<dynamic>?)?.length ?? 0;
          following = (userData['following'] as List<dynamic>?)?.length ?? 0;
          postcount = (userData['posts'] as List<dynamic>?)?.length ?? 0;
        });
      } else {
        print('User data does not exist.');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  var postData = {};

  postDetails() async {
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      setState(() {
        postcount = postSnap.docs.length;
      });
    } catch (err) {
      print("Error fetching post Details ${err}");
    }
  }

  void logout() async {
    await Get.defaultDialog(
        title: "",
        content: const Text("Are you want to logout your Account?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                FirebaseAuth.instance.signOut();
              },
              child: const Text("Yes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: mobileBackgroundColor,
          title: FirebaseAuth.instance.currentUser!.uid == widget.uid
              ? TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.blueGrey[900],
                        context: context,
                        builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                userData['photoUrl']),
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          userData['username'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 13),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.blueAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      height: 15,
                                      color: Colors.transparent,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const SigninScreen();
                                        }));
                                      },
                                      child: Row(
                                        children: [
                                          const Expanded(
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 0),
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
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          await FirebaseAuth.instance.signOut();
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const SigninScreen();
                                          }));
                                        },
                                        child: InkWell(
                                          onTap: logout,
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                  child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0),
                                                child: IconButton(
                                                    onPressed: () {
                                                      print("object");
                                                    },
                                                    icon: const Icon(
                                                      Icons.logout,
                                                      color: Colors.white,
                                                      size: 25,
                                                      weight: 18,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Text(
                          userData['username'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        )),
                    Expanded(
                        child: Text(
                      userData['username'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
          actions: [
            FirebaseAuth.instance.currentUser!.uid == widget.uid
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_box_outlined,
                            color: Colors.white,
                            size: 27,
                          )),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.blueGrey[800],
                                context: context,
                                builder: (context) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 5,
                                            top: 30,
                                            bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const SavedPostsScreen();
                                                }));
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.bookmark,
                                                    color: Colors.white,
                                                    size: 27,
                                                  ),
                                                  Gap(10),
                                                  Text(
                                                    "Saved Posts",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Gap(20),
                                            InkWell(
                                              onTap: () {},
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.local_activity,
                                                    color: Colors.white,
                                                    size: 27,
                                                  ),
                                                  Gap(10),
                                                  Text(
                                                    "Your activity",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Gap(20),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const AddToFavourites();
                                                }));
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.star_border,
                                                    color: Colors.white,
                                                    size: 27,
                                                  ),
                                                  Gap(10),
                                                  Text(
                                                    "Add to favourites",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 27,
                          )),
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 27,
                          )),
                    ],
                  )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ProfileViewScreen(
                            userdata: userData['photoUrl']);
                      }));
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${postcount}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      const Text(
                        "Posts",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${followers}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      const Text(
                        "Followers",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${following}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      const Text(
                        "Following",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? const Row()
                      : isFollowing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FollowButton(
                                  backgroundColor: Colors.blueAccent,
                                  borderColor: Colors.grey,
                                  text: "Unfollow",
                                  textColor: primaryColor,
                                  function: () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.uid);
                                    setState(() {
                                      followers--;
                                      isFollowing = false;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FollowButton(
                                  backgroundColor: Colors.blueAccent,
                                  borderColor: Colors.grey,
                                  text: "Follow",
                                  textColor: primaryColor,
                                  function: () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.uid);
                                    setState(() {
                                      followers++;
                                      isFollowing = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 10,
                          ),
                          child: Text(userData['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white,
                              ))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 10,
                          ),
                          child: Text(userData['bio'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white)))
                    ],
                  ),
                ],
              ),
            ),
            FirebaseAuth.instance.currentUser!.uid == widget.uid
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 155,
                            height: 35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[500],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const ProfileEditScreen();
                                }));
                              },
                              child: const Text(
                                "Edit profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: 155,
                            height: 35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[500],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (context) {
                                //   return const ProfileEditScreen();
                                // }));
                              },
                              child: const Text(
                                "Share profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Icon(
                              Icons.person_add_rounded,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 0,
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(
                      height: 0,
                    ),
                  ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where("uid", isEqualTo: widget.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: (snapshot.data! as dynamic).docs.length < 1
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey[850],
                                  size: 45,
                                ),
                                const Text(
                                  "No Posts Yet",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                )
                              ],
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) => Image.network(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['postUrl'],
                                  fit: BoxFit.cover,
                                )),
                  );
                }),
          ],
        ),
      )),
    );
  }
}
