import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/global_variable.dart';

class MobileScreenLauyout extends StatefulWidget {
  const MobileScreenLauyout({super.key});

  @override
  State<MobileScreenLauyout> createState() => _MobileScreenLauyoutState();
}

class _MobileScreenLauyoutState extends State<MobileScreenLauyout> {
  int _page = 0;
  late PageController pageController;

  void navigationTaped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Home_Screen",
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: homeScreenItems,
            ),
          ),
          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? Colors.white : Colors.grey,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? Colors.white : Colors.grey,
                    // size: _page == 1 ? 35 : 30,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    color: _page == 2 ? Colors.white : Colors.grey,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.slow_motion_video,
                    color: _page == 3 ? Colors.white : Colors.grey,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: _page == 4 ? Colors.white : Colors.grey,
                  ),
                  label: ""),
            ],
            onTap: navigationTaped,
          ),
        ),
      ),
    );
  }
}
