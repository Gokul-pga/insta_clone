import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/screeens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUser = false;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 45,
            child: TextField(
              controller: searchTextController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.search_rounded),
                labelText: "Search",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
              onSubmitted: (String _) {
                print(searchTextController.text);
                setState(() {
                  isShowUser = true;
                });
              },
            ),
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchTextController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProfileScreen(
                                    uid: (snapshot.data! as dynamic).docs[index]
                                        ['uid']);
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['photoUrl']),
                                ),
                                title: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ));
                      });
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Skeletonizer(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 3, right: 3),
                      child: MasonryGridView.count(
                        crossAxisCount: 3,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    ));
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, left: 3, right: 3),
                    child: MasonryGridView.count(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      ),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  );
                }));
  }
}
