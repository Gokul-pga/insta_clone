import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_clone/resource/firestore_methods.dart';
import 'package:insta_clone/screeens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/SkeletonUi/Post_Screen_Skeleton.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/comments_card.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool likeToggle = false;
  bool isLikeAnimating = false;
  bool saveToggle = false;
  var username = '';
  var userid = '';
  String userimg = '';
  bool skeleton = false;
  int commentsLen = 0;
  TextEditingController textcomment = TextEditingController();
  var userdetails = {};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textcomment.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getCommentData();
    saveToggleFunction();
  }

  getData() async {
    skeleton = true;
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userdetails = userSnap.data()!;
      setState(() {
        username = (userSnap.data() as Map<String, dynamic>)["username"];
        userid = (userSnap.data() as Map<String, dynamic>)["uid"];
      });
      skeleton = false;
    } catch (err) {
      print("Postcard error: $err");
    }
  }

  saveToggleFunction() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("savedPosts")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("posts")
          .doc((widget.snap["postUrl"] ==
              FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.snap["postUrl"])) as String?)
          .get();
      if (snap.exists) {
        setState(() {
          saveToggle = true; // Set saveToggle based on document existence
        });
      } else {
        setState(() {
          saveToggle = true; // Set saveToggle based on document existence
        });
      }
    } catch (err) {
      // Handle any errors if necessary
    }
  }

  //get comments data for display in the posts
  getCommentData() async {
    try {
      var userComment = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection("comments")
          .get();

      commentsLen = userComment.docs.length;
    } catch (err) {
      print('comment get error ${err}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return skeleton == true
        ? const PostScreenSkeleton()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            color: mobileBackgroundColor,
            child: Container(
              //color: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 2)
                            .copyWith(right: 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ProfileScreen(
                                uid: widget.snap['uid'],
                              );
                            }));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(widget.snap["profImage"]),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap["username"],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              // post menu icon toggle button
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.blueGrey[800],
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                        height: 330,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .bookmark_border,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Gap(5),
                                                            Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SimpleDialog(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Text(
                                                                            "Are you sure want to delete this post?",
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 5,
                                                                              left: 5,
                                                                              right: 5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                    FirestoreMethods().deletePost(widget.snap["postId"]);
                                                                                  },
                                                                                  child: const Text("Yes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Text("No", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Gap(5),
                                                            Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.star_border,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        "Add to favourites",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .person_add_rounded,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        "Follow",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.visibility_off,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        "Hide",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        "About this account",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.report,
                                                        size: 25,
                                                        color: Colors.red,
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        "Report",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.red),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  });
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      await FirestoreMethods().likePost(
                          widget.snap['postId'], userid, widget.snap["likes"]);
                      setState(() {
                        isLikeAnimating = true;
                        likeToggle = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(widget.snap["postUrl"]),
                        ),
                        AnimatedOpacity(
                          opacity: isLikeAnimating ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            duration: const Duration(milliseconds: 400),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icon styling column
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Row(
                          children: [
                            LikeAnimation(
                              isAnimating:
                                  widget.snap['likes'].contains(userid),
                              smallLike: true,
                              child: IconButton(
                                  onPressed: () async {
                                    await FirestoreMethods().likePost(
                                        widget.snap['postId'],
                                        userid,
                                        widget.snap["likes"]);
                                  },
                                  icon: widget.snap['likes'].contains(userid)
                                      ? const Icon(
                                          Icons.favorite_outlined,
                                          color: Colors.red,
                                          size: 27,
                                        )
                                      : const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white,
                                          size: 27,
                                        )),
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.blueGrey[800],
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                            width: double.infinity,
                                            height: 760,
                                            child: Scaffold(
                                              backgroundColor:
                                                  Colors.blueGrey[800],
                                              appBar: AppBar(
                                                automaticallyImplyLeading:
                                                    false,
                                                leading: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )),
                                                backgroundColor:
                                                    Colors.blueGrey[800],
                                                title: const Text(
                                                  "Comments",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              body: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("posts")
                                                    .doc(widget.snap['postId'])
                                                    .collection("comments")
                                                    .orderBy("datePublished",
                                                        descending: true)
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            QuerySnapshot<
                                                                Map<String,
                                                                    dynamic>>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }
                                                  ;
                                                  return ListView.builder(
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return ProfileScreen(
                                                                        uid: (snapshot.data!
                                                                                as dynamic)
                                                                            .docs[index]['uid']);
                                                                  }));
                                                                },
                                                                child: CommentsCard(
                                                                    data: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()),
                                                              ));
                                                },
                                              ),
                                              bottomNavigationBar: SafeArea(
                                                child: Container(
                                                  height: kToolbarHeight,
                                                  margin: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 15,
                                                          bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                userdetails[
                                                                    'photoUrl']),
                                                        radius: 22,
                                                      ),
                                                      Expanded(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 8),
                                                        child: TextField(
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          controller:
                                                              textcomment,
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  "Add a comment for ${widget.snap["username"]}",
                                                              hintStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                        ),
                                                      )),
                                                      InkWell(
                                                        onTap: () {
                                                          FirestoreMethods()
                                                              .postComment(
                                                                  widget.snap[
                                                                      "uid"],
                                                                  textcomment
                                                                      .text,
                                                                  userdetails[
                                                                      'photoUrl'],
                                                                  username,
                                                                  widget.snap[
                                                                      "postId"]);
                                                          setState(() {
                                                            textcomment.text =
                                                                "";
                                                          });
                                                          print(
                                                              "comments posted");
                                                        },
                                                        child: const Text(
                                                          "Send",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                      });
                                },
                                icon: const Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                  size: 27,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 27,
                                ))
                          ],
                        ),
                      )),
                      InkWell(
                          onTap: () async {
                            await FirestoreMethods().savePosts(
                                widget.snap["postId"],
                                widget.snap["username"],
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.snap["postUrl"]);
                          },
                          child: saveToggle == true
                              ? const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                  size: 27,
                                )
                              : const Icon(
                                  Icons.bookmark_border_outlined,
                                  color: Colors.white,
                                  size: 27,
                                ))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.snap['likes'].length} likes",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 2, left: 10),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: widget.snap["username"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: "   ${widget.snap["description"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(top: 2, left: 10),
                      width: double.infinity,
                      child: Text(
                        "View all ${commentsLen} comments",
                        style: const TextStyle(
                            color: secondaryColor, fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 2, left: 10),
                    width: double.infinity,
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap["datePublished"].toDate()),
                      style:
                          const TextStyle(color: secondaryColor, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
