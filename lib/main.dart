import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/push_notification/firebase_api.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screeens/signin.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? {
          await Firebase.initializeApp(
              options: const FirebaseOptions(
                  apiKey: "AIzaSyDK8pGj_kmtu8D5UAvu4xa9pijKaKuUgWE",
                  appId: "1:1048279876632:web:a0d54fc76df19e5adfef6d",
                  messagingSenderId: "1048279876632",
                  projectId: "insta-clone-flutter-3a416",
                  storageBucket: "insta-clone-flutter-3a416.appspot.com")),
          await FirebaseApi().initNotifications(),
        }
      : await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // Request permission for iOS and Android

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return
                    //CommentsCardSkeleton();
                    const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLauyout(),
                  webScreenLayout: WebScreenLauyout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const SigninScreen();
          },
        ),
      ),
    );
  }
}
