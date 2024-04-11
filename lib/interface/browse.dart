import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sce_project/interface/otherprofile.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);
  static String id = 'browse';

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  User? currentUser;
  String? currentUserCountry;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserLastSeen() async {
    if (_auth.currentUser != null) {
      final userRef =
          _firestore.collection('users').doc(_auth.currentUser!.uid);
      await userRef.update({'lastSeen': FieldValue.serverTimestamp()});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await updateUserLastSeen();
    await Fetch.fetchCurrentUser();
    setState(() {
      currentUserCountry = Fetch.currentUserCountry;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Community',
          style: TextStyle(color: Colors.black, fontFamily: 'Truculenta'),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
          )
        ],
      ),
      body: currentUserCountry == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<User1>>(
                future: Fetch.fetchAllUsers(currentUserCountry!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No user found.: ${snapshot.error}'),
                    );
                  } else {
                    List<User1> usersList = snapshot.data ?? [];

                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          final user = usersList[index];

                          if (currentUser != null &&
                              currentUser.uid != user.uid) {
                            return Container(
                              height: 140,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  user.username ??
                                                      '', // Add null check
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Truculenta'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, top: 4),
                                                  child: Text(
                                                    '${user.age ?? ''}', // Add null check
                                                    style: const TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                user.gender == 'Male'
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.male,
                                                          color: Color.fromARGB(
                                                              255, 46, 87, 158),
                                                        ),
                                                      )
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.female,
                                                          color: Colors.pink,
                                                        ),
                                                      )
                                              ],
                                            ),
                                            Text(
                                              user.goal ?? '', // Add null check
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              user.country ??
                                                  '', // Add null check
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              user.city ?? '', // Add null check
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, right: 27),
                                      child: CircleAvatar(
                                        radius: 50,
                                        child: ClipOval(
                                          child: user.photoUrl != null
                                              ? Image.network(
                                                  user.photoUrl!,
                                                  fit: BoxFit
                                                      .fill, // Use BoxFit.fill for exact fit
                                                )
                                              : Image.asset(
                                                  'images/defaultAvatar.png',
                                                  fit: BoxFit
                                                      .fill, // Use BoxFit.fill for exact fit
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtherProfile(
                                        otherUser: user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container if currentUser is null or if uid matches
                          }
                        },
                      ).animate().fadeIn(duration: 2000.ms),
                    );
                  }
                },
              ),
            ),
    );
  }
}

class Fetch {
  static String? currentUserCountry;

  static Future<void> fetchCurrentUser() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();

        if (snapshot.exists) {
          currentUserCountry = snapshot['country'];
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }

  static Future<List<User1>> fetchAllUsers(String currentUserCountry) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('country', isEqualTo: currentUserCountry)
              .get();

      List<User1> userList = querySnapshot.docs.map((doc) {
        return User1(
          username: doc['username'],
          age: doc['age'],
          country: doc['country'],
          gender: doc['gender'],
          photoUrl: doc['avatar'],
          city: doc['city'],
          uid: doc['uid'],
          goal: doc['goal'],
          bio: doc['bio'],
          email: doc['email'],
          lastSeen: doc['lastSeen'],
          token: doc['token'],
        );
      }).toList();

      // Sort the list based on lastSeen timestamp
      userList.sort((a, b) => (b.lastSeen as Timestamp).compareTo(a.lastSeen!));

      return userList;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  static Future<User1> fetchUser(String uid) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (snapshot.exists) {
          return User1(
            username: snapshot['username'],
            age: snapshot['age'],
            country: snapshot['country'],
            gender: snapshot['gender'],
            photoUrl: snapshot['avatar'],
            city: snapshot['city'],
            goal: snapshot['goal'],
            uid: snapshot['uid'],
            bio: snapshot['bio'],
            email: snapshot['email'],
            token: snapshot['token'],

          );
        }
      }
      return User1();
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }
}

class User1 {
  final String? username;
  final int? age;
  final String? country;
  final String? gender;
  final String? photoUrl;
  final String? city;
  final String? uid;
  final String? goal;
  final String? bio;
  final String? email;
  final Timestamp? lastSeen;
  final String? token;

  User1(
      {this.username,
      this.age,
      this.country,
      this.gender,
      this.photoUrl,
      this.uid,
      this.city,
      this.goal,
      this.bio,
      this.email,
      this.lastSeen,this.token});
}
