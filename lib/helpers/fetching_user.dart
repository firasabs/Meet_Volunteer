import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String? username;
  final int? age;
  final String? country;
  final String? gender;
  final String? photoUrl;
  final String? city;
  final String? goal;
  final String? bio;
  final String? uid;

  User(
      {this.username,
      this.age,
      this.country,
      this.gender,
      this.photoUrl,
      this.city,
      this.goal,
      this.bio,
      this.uid});
}

class Fetch {
  static String? currentUserCountry;

  static Future<User> fetchCurrentUser() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();

        if (snapshot.exists) {
          return User(
            username: snapshot['username'],
            age: snapshot['age'],
            country: snapshot['country'],
            gender: snapshot['gender'],
            photoUrl: snapshot['avatar'],
            city: snapshot['city'],
            goal: snapshot['goal'],
            bio: snapshot['bio'],
            uid: snapshot['uid'],
          );
        }
      }
      return User();
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }

  static Future<List<User>> fetchAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<User> userList = querySnapshot.docs.map((doc) {
        return User(
          username: doc['username'],
          age: doc['age'],
          country: doc['country'],
          gender: doc['gender'],
          photoUrl: doc['avatar'],
          city: doc['city'],
          goal: doc['goal'],
          bio: doc['bio'],
          uid: doc['uid'],
        );
      }).toList();

      return userList;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  static Future<User> fetchUser(String uid) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (snapshot.exists) {
          return User(
            username: snapshot['username'],
            age: snapshot['age'],
            country: snapshot['country'],
            gender: snapshot['gender'],
            photoUrl: snapshot['avatar'],
            city: snapshot['city'],
            goal: snapshot['goal'],
            bio: snapshot['bio'],
            uid: snapshot['uid'],
          );
        }
      }
      return User();
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }
}
