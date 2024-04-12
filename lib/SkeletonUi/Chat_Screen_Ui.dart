import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreenSkeleton extends StatelessWidget {
  const ChatScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const Skeletonizer(
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
            )));
  }
}
