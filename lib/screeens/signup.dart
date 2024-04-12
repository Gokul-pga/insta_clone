import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resource/auth_methods.dart';
import 'package:insta_clone/screeens/signin.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _loginformkey = GlobalKey<FormState>();
  bool passwordvisible = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  Uint8List? _image;
  bool isloading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  void signupUser() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      isloading = false;
    });

    if (res != "Success") {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Signup page",
      home: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: ListView(
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
                      child:
                          Image.asset("assests/png_images/instatextlogo.png"),
                    ),
                  ],
                ),
                const Text(
                  "Sign up to see photos and videos from your friends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          size: 30,
                          color: Colors.blue,
                        )),
                    const Text(
                      "Log in with facebook",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 70, backgroundImage: MemoryImage(_image!))
                          : CircleAvatar(
                              foregroundColor: Colors.green,
                              radius: 70,
                              child: Image.asset(
                                  "assests/png_images/profimg3.jpg"),
                            ),
                      Positioned(
                        bottom: -12,
                        left: 70,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Form(
                      key: _loginformkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: _usernameController,
                              validator: (email) {
                                if (email!.isEmpty && email != null) {
                                  return "Username is required";
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: "Enter your username ",
                                  labelText: " Enter your username ",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusColor: Colors.black,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: _emailController,
                              validator: (name) {
                                if (name!.isEmpty && name != null) {
                                  return "Email is required";
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.mail,
                                      color: Colors.white),
                                  hintText: "Enter your email ",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusColor: Colors.black,
                                  labelText: "Enter your email",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: _passwordController,
                              validator: (password) {
                                if (password!.isEmpty &&
                                    password != null &&
                                    password != " ") {
                                  if (password.length < 6) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Password must be at least 6 characters long",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                  return "Password is required";
                                }
                              },
                              obscureText: passwordvisible,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.password, color: Colors.white),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passwordvisible = !passwordvisible;
                                        });
                                      },
                                      icon: passwordvisible
                                          ? const Icon(Icons.visibility_off,
                                              color: Colors.white)
                                          : const Icon(Icons.visibility,
                                              color: Colors.white)),
                                  hintText: " Password",
                                  labelText: "Password ",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusColor: Colors.black,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: _bioController,
                              validator: (username) {
                                if (username!.isEmpty && username != null) {
                                  return "Bio is required";
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: "Enter your bio  ",
                                  labelText: " Enter your bio",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                    )),
                const Text(
                  "People who use our service may have uploaded your contact information to Instagram.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.blue),
                        onPressed: signupUser,
                        child: isloading
                            ? const Center(
                                child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange,
                                  color: Colors.white,
                                  strokeWidth: 4.0,
                                ),
                              ))
                            : const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SigninScreen();
                          }));
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
