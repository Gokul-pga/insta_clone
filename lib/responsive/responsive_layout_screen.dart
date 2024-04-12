import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        // webScreensize is 600 it means above 600px automatically screen  switched to webscreenlayout
        if (constrains.maxWidth > webScreenSize) {
          //web Screen Layout
          return widget.webScreenLayout;
        }
        // Mobile screen Layout
        return widget.mobileScreenLayout;
      },
    );
  }
}
