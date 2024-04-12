import 'package:flutter/material.dart';
import 'package:insta_clone/screeens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsCard extends StatefulWidget {
  final data;
  const CommentsCard({super.key, required this.data});

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showComment();
  }

  bool likeToggle = false;
  bool showcomment = true;

  showComment() {
    if (widget.data.length > 1) {
      setState(() {
        showcomment = false;
      });
    } else {
      setState(() {
        showcomment = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
        child: showcomment
            ? Center(
                child: Column(
                  children: [
                    const Text(
                      "No comments yet",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    Skeletonizer(
                        child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ProfileScreen(uid: widget.data["uid"]);
                            }));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage("${widget.data['profilePic']}"),
                            radius: 22,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.data['username'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      DateFormat.yMMMd().format(widget
                                          .data['datePublished']
                                          .toDate()),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                widget.data['text'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                print("Like by user");
                                setState(() {
                                  likeToggle = !likeToggle;
                                });
                              },
                              icon: likeToggle
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.favorite,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                            ),
                            const Text(
                              "asdffghjkl",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              )
            : InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage("${widget.data['profilePic']}"),
                      radius: 22,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.data['username'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  DateFormat.yMMMd().format(
                                      widget.data['datePublished'].toDate()),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                          Text(
                            widget.data['text'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    )),
                    IconButton(
                      onPressed: () {
                        print("Like by user");
                        setState(() {
                          likeToggle = !likeToggle;
                        });
                      },
                      icon: likeToggle
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.grey,
                              size: 20,
                            ),
                    )
                  ],
                ),
              ));
  }
}
