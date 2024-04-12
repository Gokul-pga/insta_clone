import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/resource/auth_methods.dart';
import 'package:insta_clone/widgets/forgotpassword.dart';
import 'package:insta_clone/screeens/signup.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool textVisible = true;
  final _signinFormKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController userpassword = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool isloading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    userpassword.dispose();
  }

  void loginuser() async {
    setState(() {
      isloading = true;
    });

    String res = await AuthMethods()
        .loginUser(email: username.text, password: userpassword.text);
    setState(() {
      isloading = false;
    });
    if (res == "Success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLauyout(),
              mobileScreenLayout: MobileScreenLauyout())));
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return Home_Screen();
      //   print("succesfuylly login");
      // }));
    } else {
      print("Check your email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: Form(
          key: _signinFormKey,
          child: ListView(
            // padding: EdgeInsets.symmetric(vertical: 50),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 75.0,
                    height: 250,
                    child: Image.asset("assests/png_images/instalogo.webp"),
                  ),
                  SizedBox(
                    width: 250.0,
                    height: 250,
                    child: Image.asset("assests/png_images/instatextlogo.png"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (username) {
                    if (username!.isEmpty && username != ' ') {
                      return "Enter your Username";
                    }
                    ;
                  },
                  controller: username,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Phone number, email or username",
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.person),
                      focusColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: (const BorderSide(color: Colors.white)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (userpassword) {
                    if (userpassword!.isEmpty && userpassword != ' ') {
                      return "Enter your Password";
                    }
                  },
                  controller: userpassword,
                  obscureText: textVisible,
                  decoration: InputDecoration(
                      labelText: "password",
                      hintText: "password",
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textVisible = !textVisible;
                          });
                        },
                        icon: textVisible
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                      ),
                      focusColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              (const BorderSide(color: Colors.black54)))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.blue),
                  onPressed: loginuser,
                  child: isloading
                      ? const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blueAccent,
                              color: Colors.white,
                              strokeWidth: 4.0,
                            ),
                          ),
                        )
                      : const Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPswScreen();
                        }));
                      },
                      child: const Text(
                        "Forget password?",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Or",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          Text(
                            "Log in with Facebook",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ))
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
