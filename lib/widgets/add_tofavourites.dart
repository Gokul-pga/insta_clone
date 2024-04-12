import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

class AddToFavourites extends StatefulWidget {
  const AddToFavourites({super.key});

  @override
  State<AddToFavourites> createState() => _AddToFavouritesState();
}

class _AddToFavouritesState extends State<AddToFavourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.white),
        title: Text(
          "Saved",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 27,
              ))
        ],
      ),
    );
  }
}
