import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resource/firestore_methods.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/screeens/feed_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool indicator = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void postImage(String username, String uid, String profImage) async {
    try {
      // setState(() {
      //   indicator = true;
      // });

      showSnackBar("Uploading...", context);
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, uid, _file!, username, profImage);
      showSnackBar('Posted', context);
      // if (context.mounted) {
      //   showSnackBar(
      //     'Posted!',
      //     context,
      //   );
      // }
      // setState(() {
      //   indicator = false;
      // });

      if (res == "Success") {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const MobileScreenLauyout();
        }));

        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(res, context);
        }
      }
    } catch (err) {
      print("Post error occured: $err ");
    }
    ;
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            alignment: AlignmentDirectional.center,
            title: const Text("Create a Post"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleDialogOption(
                      padding: const EdgeInsets.all(20),
                      child: const Text("Take a photo",
                          style: TextStyle(fontSize: 18)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Uint8List file = await pickImage(ImageSource.camera);
                        setState(() {
                          _file = file;
                        });
                      },
                    ),
                    const Icon(Icons.camera_alt)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleDialogOption(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "Choose from gallery",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Uint8List file = await pickImage(ImageSource.gallery);
                        setState(() {
                          _file = file;
                        });
                        print(_file.toString());
                      },
                    ),
                    const Icon(Icons.image)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetails();
    print("add to post screen");
  }

  String username = '';
  String userid = '';
  var userimg = '';
  var userDetails = {};

  void fetchDetails() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userDetails = snap.data()!;
    setState(() {
      // _file2 = userpic;
      username = (snap.data() as Map<String, dynamic>)['username'];
      userid = (snap.data() as Map<String, dynamic>)['uid'];
      userimg = (snap.data() as Map<String, dynamic>)['photoUrl'];

      //print(_file2.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _selectImage(context)),
                const Text(
                  "Upload",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )
              ],
            )),
          )
        : GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: mobileBackgroundColor,
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _file == null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                title: const Text(
                  "New post",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                centerTitle: false,
              ),
              body: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // username == ""
                      //     ? Text("$username")
                      //     :
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              width: 50,
                              height: 40,
                              // child:  CircleAvatar(
                              //   radius: 30,
                              //   backgroundImage: NetworkImage(
                              //     //"userProvider.getUser.photoUrl"
                              //     "https://cdn.pixabay.com/photo/2020/10/11/19/51/cat-5646889_1280.jpg",
                              //   ),
                              // ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(userDetails['photoUrl']),
                              )),
                          Text(
                            username,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      //Text(user.username),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 350,
                              width: 350,
                              child: Image.memory(_file!)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              width: double.infinity,
                              child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                      hintText: "write a caption...",
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                      border: InputBorder.none),
                                  maxLines: 3),
                            ),
                            indicator
                                ? LinearProgressIndicator(
                                    color: Colors.blueAccent,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          postImage(username, userid,
                                              userDetails['photoUrl']);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            minimumSize: const Size(550, 50),
                                            backgroundColor: Colors.blueAccent),
                                        child: const Text(
                                          "Post",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      indicator = false;
                                      _file == null;
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const MobileScreenLauyout();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize: const Size(550, 50),
                                      backgroundColor: Colors.white),
                                  child: const Text(
                                    "Cancle",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
