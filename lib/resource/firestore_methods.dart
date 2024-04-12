import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/models/posts.dart';
import 'package:insta_clone/resource/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  uploadPost(String description, String uid, Uint8List file, String username,
      String profImage) async {
    String res = "Some error Ocurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("Posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        postUrl: photoUrl,
        likes: [],
      );
      await _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "Success";
    } catch (error) {
      res = error.toString();
      print("Post Image error occured");
    }
  }

  // Add image post function
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = " Some error occurred on likePost while likes the post";
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
        res = "user likes the post";
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = "Success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

// Add comments on the post function
  Future<String> postComment(String uid, String text, String profilePic,
      String username, String postId) async {
    String res = "Some error occurred on postcomments";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(({
              "profilePic": profilePic,
              "uid": uid,
              "username": username,
              "text": text,
              "postId": postId,
              'datePublished': DateTime.now(),
            }));
        res = "Success";
      } else {
        res = "Please post comments";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Delete post from the post database
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred on delete post";
    try {
      FirebaseFirestore.instance.collection("posts").doc(postId).delete();
      res = "Successfully delete post";
    } catch (err) {
      res = err.toString();
    }
    ;
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    String res = "Some error occured";
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = await (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          "followers": FieldValue.arrayRemove([uid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          "followers": FieldValue.arrayUnion([uid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      res = err.toString();
    }
  }

  Future<void> savePosts(
      String postId, String username, String uid, String postUrl) async {
    String res = "Some error occurred on posts save to collection";
    try {
      // Check if the postId exists in the collection
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("savedPosts")
          .doc(uid)
          .collection("posts")
          .doc(postId)
          .get();

      if (snap.exists) {
        // If the document exists, remove it
        await FirebaseFirestore.instance
            .collection("savedPosts")
            .doc(uid)
            .collection("posts")
            .doc(postId)
            .delete();
        res = "Post removed from collection";
      } else {
        // If the document doesn't exist, add it
        await FirebaseFirestore.instance
            .collection("savedPosts")
            .doc(uid)
            .collection("posts")
            .doc(postId)
            .set({
          "postId": postId,
          "username": username,
          "uid": uid,
          "postUrl": postUrl,
        });
        res = "Post added to collection";
      }
    } catch (err) {
      res = err.toString();
    }
    print(res);
  }
}
