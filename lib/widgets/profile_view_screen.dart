import 'package:flutter/material.dart';

class ProfileViewScreen extends StatelessWidget {
  final userdata;

  const ProfileViewScreen({super.key, required this.userdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 5),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  )),
            )
          ],
        ),
        body: Center(
            child: CircleAvatar(
          radius: 150,
          backgroundImage: NetworkImage(userdata),
        )));
  }
}
