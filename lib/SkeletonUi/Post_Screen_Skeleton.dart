import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostScreenSkeleton extends StatelessWidget {
  const PostScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 25,
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "hellohellohello",
                        style: TextStyle(color: Colors.grey),
                      ))),
              Icon(Icons.menu)
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 170,
            ),
          ),
          const Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Icon(Icons.menu),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.menu),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.menu),
                    ],
                  )),
                  Text("hello")
                ],
              ),
            ],
          ),
          //Divider(color: Colors.grey,)
        ],
      ),
    ));
  }
}
