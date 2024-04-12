import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsCardSkeleton extends StatefulWidget {
  const CommentsCardSkeleton({super.key});

  @override
  State<CommentsCardSkeleton> createState() => _CommentsCardSkeletonState();
}

class _CommentsCardSkeletonState extends State<CommentsCardSkeleton> {
  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              CircleAvatar(
                radius: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [Text("datadatadata"), Text("datadata")],
              ),
            ],
          )),
          Skeleton.shade(child: Icon(Icons.camera_alt_outlined))
        ],
      ),
    ));
  }
}
