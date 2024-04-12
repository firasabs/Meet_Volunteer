import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sce_project/helpers/fetching_user.dart';
//Student: Malik Abo Shah
class User {
  final String? username;
  final int? age;
  final String? country;
  final String? gender;
  final String? photoUrl;
  final String? city;
  final String? goal;
  final String? bio;
  final String uid;

  User(
      {this.username,
        this.age,
        this.country,
        this.gender,
        this.photoUrl,
        this.city,
        this.goal,
        this.bio,
        required this.uid});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'age': age,
      'country': country,
      'gender': gender,
      'avatar': photoUrl,
      'city': city,
      'goal': goal,
      'bio': bio,
      'uid': uid,
    };
  }
}
void main() {
  setUpAll(() async {
    await Firebase.initializeApp();
  });



  group('Fetch', () {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseFirestore = FirebaseFirestore.instance;



    test('fetchCurrentUser returns User', () async {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      );

      final user = User(
        username: 'test',
        age: 25,
        country: 'USA',
        gender: 'male',
        photoUrl: 'https://example.com/photo.jpg',
        city: 'New York',
        goal: 'test goal',
        bio: 'test bio',
        uid: userCredential.user!.uid,
      );

      await firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());

      final fetchUser = Fetch();
      final currentUser = await Fetch.fetchCurrentUser();

      expect(currentUser, isInstanceOf<User>());
      expect(currentUser.uid, userCredential.user!.uid);
    });

    test('fetchAllUsers returns List<User>', () async {
      final users = [
        User(
          username: 'test1',
          age: 25,
          country: 'USA',
          gender: 'male',
          photoUrl: 'https://example.com/photo1.jpg',
          city: 'New York',
          goal: 'test goal 1',
          bio: 'test bio 1',
          uid: 'user1',
        ),
        User(
          username: 'test2',
          age: 30,
          country: 'Canada',
          gender: 'female',
          photoUrl: 'https://example.com/photo2.jpg',
          city: 'Toronto',
          goal: 'test goal 2',
          bio: 'test bio 2',
          uid: 'user2',
        ),
      ];

      for (final user in users) {
        await firebaseFirestore.collection('users').doc(user.uid).set(user.toJson());
      }

      final fetchUser = Fetch();
      final allUsers = await Fetch.fetchAllUsers();

      expect(allUsers, isInstanceOf<List<User>>());
      expect(allUsers.length, users.length);

      for (int i = 0; i < users.length; i++) {
        expect(allUsers[i].uid, users[i].uid);
      }
    });

    test('fetchUser returns User', () async {
      final user = User(
        username: 'test',
        age: 25,
        country: 'USA',
        gender: 'male',
        photoUrl: 'https://example.com/photo.jpg',
        city: 'New York',
        goal: 'test goal',
        bio: 'test bio',
        uid: 'testUid',
      );

      await firebaseFirestore.collection('users').doc(user.uid).set(user.toJson());

      final fetchUser = Fetch();
      final fetchedUser = await Fetch.fetchUser(user.uid);

      expect(fetchedUser, isInstanceOf<User>());
      expect(fetchedUser.uid, user.uid);
    });
  });
}
