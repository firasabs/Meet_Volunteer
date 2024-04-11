import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sce_project/interface/browse.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sce_project/interface/otherprofile.dart';
import 'package:sce_project/interface/yourprofile.dart';
import 'package:sce_project/intro/register_page.dart';
import 'package:sce_project/interface/settings.dart';
import 'package:sce_project/intro/welcome_page.dart';
import 'package:sce_project/intro/login_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sce_project/helpers/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:sce_project/interface/browse.dart' as fetch;
import 'package:awesome_dialog/awesome_dialog.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MeetVolunteer extends StatefulWidget {
  const MeetVolunteer({Key? key}) : super(key: key);

  static String id = 'meet_volunteer';
  @override
  State<MeetVolunteer> createState() => _MeetVolunteerState();
}

class _MeetVolunteerState extends State<MeetVolunteer> {
  int _currentindex = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _friendRequests = [];
  List<fetch.User1> users = [];
  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
    updateUserLastSeen();
  }



  Future<void> updateUserLastSeen() async {
    if (_auth.currentUser != null) {
      final userRef =
          _firestore.collection('users').doc(_auth.currentUser!.uid);
      await userRef.update({'lastSeen': FieldValue.serverTimestamp()});
    }
  }

  void _updateFriendRequests(
      List<String> requests, List<fetch.User1> fetchedUsers) {
    setState(() {
      _friendRequests = requests;
      users = fetchedUsers;
    });
  }

  void _showFriendRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<String>>(
          future: _fetchFriendRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<String> requests = snapshot.data ?? [];
              return Container(
                decoration: GradientBackground,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Friend Requests',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<fetch.User1>(
                            future: fetch.Fetch.fetchUser(requests[index]),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              } else {
                                fetch.User1 user = userSnapshot.data!;
                                return ListTile(
                                  onTap: () {},
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    user.username!,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Truculenta'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0, top: 4),
                                                    child: Text(
                                                      '${user.age}',
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
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons.male,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    46,
                                                                    87,
                                                                    158),
                                                          ),
                                                        )
                                                      : const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons.female,
                                                            color: Colors.pink,
                                                          ),
                                                        )
                                                ],
                                              ),
                                              Text(
                                                user.goal!,
                                                style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                user.country!,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                user.city!,
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
                                            top: 40.0, right: 27),
                                        child: Row(
                                          children: [
                                            TextButton(
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  _acceptFriendRequest(
                                                      user.uid!);
                                                  // Optionally, close the bottom sheet here
                                                  Navigator.pop(context);
                                                }),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            TextButton(
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  _declineFriendRequest(
                                                      user.uid!);
                                                  // Optionally, close the bottom sheet here
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 1000.ms);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showFriendsList(BuildContext context) async {
    try {
      List<String> friendUids = await _fetchFriendUids();
      List<fetch.User1> friendUsers = [];

      for (String uid in friendUids) {
        fetch.User1 user = await fetch.Fetch.fetchUser(uid);
        friendUsers.add(user);
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: GradientBackground,
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Friends',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: friendUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherProfile(
                                      otherUser: friendUsers[index],
                                    )),
                          );
                        },
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          friendUsers[index].username!,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Truculenta'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 4),
                                          child: Text(
                                            '${friendUsers[index].age}',
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        friendUsers[index].gender == 'Male'
                                            ? const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.male,
                                                  color: Color.fromARGB(
                                                      255, 46, 87, 158),
                                                ),
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.female,
                                                  color: Colors.pink,
                                                ),
                                              )
                                      ],
                                    ),
                                    Text(
                                      friendUsers[index].goal!,
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      friendUsers[index].country!,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      friendUsers[index].city!,
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
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 0),
                              child: CircleAvatar(
                                radius: 50,
                                child: ClipOval(
                                  child: friendUsers[index].photoUrl != null
                                      ? Image.network(
                                          friendUsers[index].photoUrl!,
                                          fit: BoxFit
                                              .fill, // Use BoxFit.fill for exact fit
                                        )
                                      : Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/sce-project-679d8.appspot.com/o/profile_pictures%2Fperson-295.png?alt=media&token=034284ff-2eee-4158-a557-4dec345e701f',
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ).animate().fadeIn(duration: 1000.ms);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Failed to fetch friends: $e');
      showToast('Failed to fetch friends', context: context);
    }
  }

  Future<List<String>> _fetchFriendUids() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      List<dynamic> friends = snapshot['friends'];
      return friends.cast<String>();
    } catch (e) {
      print('Failed to fetch friend UIDs: $e');
      return [];
    }
  }

  Future<List<String>> _fetchFriendRequests() async {
    try {
      List<String> requests = await fetchFriendRequests();
      return requests;
    } catch (e) {
      print('Failed to fetch friend requests: $e');
      return [];
    }
  }

  Future<List<String>> fetchFriendRequests() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      List<dynamic> receivedRequests = snapshot['received_requests'];
      return receivedRequests.cast<String>();
    } catch (e) {
      print('Failed to fetch friend requests: $e');
      return [];
    }
  }

  void _acceptFriendRequest(String friendUid) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'friends': FieldValue.arrayUnion([friendUid]),
      });
      await _firestore.collection('users').doc(friendUid).update({
        'friends': FieldValue.arrayUnion([_auth.currentUser!.uid]),
      });
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'received_requests': FieldValue.arrayRemove([friendUid]),
      });
      await _firestore.collection('users').doc(friendUid).update({
        'sent_requests': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });

      _fetchFriendRequests();

      showToast('Friend request accepted',
          context: context, duration: const Duration(seconds: 2));
    } catch (e) {
      print('Failed to accept friend request: $e');
      showToast('Failed to accept friend request',
          context: context, duration: const Duration(seconds: 2));
    }
  }

  void _declineFriendRequest(String friendUid) async {
    try {
      // Remove friend request from current user's received requests
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'received_requests': FieldValue.arrayRemove([friendUid]),
      });
      // Remove friend request from friend's sent requests
      await _firestore.collection('users').doc(friendUid).update({
        'sent_requests': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });

      // Refresh the friend requests list
      _fetchFriendRequests();

      // Update UI or show a notification to indicate success
      setState(() {
        // Update the UI as necessary
      });
      showToast('Friend request declined',
          context: context, duration: const Duration(seconds: 2));
    } catch (e) {
      print('Failed to decline friend request: $e');
      showToast('Failed to decline friend request',
          context: context, duration: const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      const ProfilePage(),
      const BrowsePage(),
      const SettingsPage(),
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: 'Settings'),
    ];
    assert(_kTabPages.length == _kBottmonNavBarItems.length);

    final bottomNavBar = BottomNavigationBar(
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.transparent,
      items: _kBottmonNavBarItems,
      currentIndex: _currentindex,
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      onTap: (int index) {
        setState(() {
          _currentindex = index;
        });
      },
    );

    return Container(
      decoration: GradientBackground,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "MeetVolunteer",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Truculenta',
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _showFriendsList(context);
                },
                child: const Icon(
                  Icons.people,
                  color: Colors.black,
                )),
            TextButton(
                onPressed: () {
                  _showFriendRequestsBottomSheet(context);
                },
                child: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                )),
            TextButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'Confirmation',
                    desc: 'Are you sure you want to logout?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      await saveUserLoggedIn(false);
                      await _auth.signOut();
                      Navigator.pushReplacementNamed(context, WelcomePage.id);
                    },
                  ).show();
                },
                child: const Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: _kTabPages[_currentindex],
        bottomNavigationBar: bottomNavBar,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
