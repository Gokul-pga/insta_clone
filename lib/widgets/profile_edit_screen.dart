// import 'dart:typed_data';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:insta_clone/resource/auth_methods.dart';
// import 'package:insta_clone/utils/colors.dart';
// import 'package:insta_clone/utils/utils.dart';
//
// class ProfileEditScreen extends StatefulWidget {
//   const ProfileEditScreen({super.key});
//
//   @override
//   State<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }
//
// class _ProfileEditScreenState extends State<ProfileEditScreen> {
//   Uint8List? _image;
//
//   void selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = img;
//     });
//   }
//
//   final _loginformkey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: mobileBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         leading: IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.arrow_back_ios_sharp,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Stack(
//                     children: [
//                       _image == null
//                           ? CircleAvatar(
//                               radius: 65,
//                               child: Image.asset(
//                                   "assests/png_images/profimg3.jpg"),
//                             )
//                           : CircleAvatar(
//                               radius: 65,
//                               backgroundImage: MemoryImage(_image!),
//                             ),
//                       Positioned(
//                         top: 80,
//                         left: 70,
//                         child: IconButton(
//                           onPressed: () {
//                             selectImage();
//                           },
//                           icon: const Icon(
//                             Icons.add_a_photo,
//                             size: 40,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//               child: Form(
//                 key: _loginformkey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _usernameController,
//                       validator: (name) {
//                         if (name!.isEmpty) {
//                           return "Username is required";
//                         }
//                       },
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                           hintText: "Username",
//                           labelText: "Change your Username",
//                           hintStyle: const TextStyle(color: Colors.white),
//                           labelStyle: const TextStyle(color: Colors.white),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                     ),
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     TextFormField(
//                       controller: _bioController,
//                       validator: (bio) {
//                         if (bio!.isEmpty) {
//                           return "Bio is required";
//                         }
//                       },
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                           hintText: "Bio",
//                           labelText: "Change Your Bio",
//                           hintStyle: const TextStyle(color: Colors.white),
//                           labelStyle: const TextStyle(color: Colors.white),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0)),
//                     backgroundColor: Colors.blue),
//                 onPressed: () {},
//                 child: const Text(
//                   "Update Profile",
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resource/auth_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Uint8List? _image;
  bool indicator = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final _loginformkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void updateProfile() async {
    if (_image == null ||
        _usernameController.text.isEmpty ||
        _bioController.text.isEmpty) {
      // Add proper validation handling here
      print("All fields are mandatory");
    }

    setState(() {
      indicator = true;
    });

    try {
      await AuthMethods().profileUpdate(
        file: _image!,
        username: _usernameController.text,
        bio: _bioController.text,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
      Navigator.of(context).pop();
    } catch (error) {
      // Handle errors during profile update
      print("Error updating profile: $error");
      // Add proper error handling or show an error message to the user
    } finally {
      setState(() {
        indicator = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            indicator
                ? const LinearProgressIndicator(
                    color: Colors.blueAccent,
                  )
                : Row(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      _image == null
                          ? CircleAvatar(
                              radius: 65,
                              child: Image.asset(
                                  "assests/png_images/profimg3.jpg"),
                            )
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: MemoryImage(_image!),
                            ),
                      Positioned(
                        top: 80,
                        left: 70,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Form(
                key: _loginformkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return "Username is required";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Username",
                          labelText: "Change your Username",
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _bioController,
                      validator: (bio) {
                        if (bio!.isEmpty) {
                          return "Bio is required";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Bio",
                          labelText: "Change Your Bio",
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Colors.blue),
                onPressed: () {
                  updateProfile();
                },
                child: const Text(
                  "Update Profile",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
