import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:sce_project/interface/browse.dart';
import 'package:sce_project/main.dart';
import '../helpers/fetching_user.dart' as userInfo;
import 'package:sce_project/interface/browse.dart' as FetchUser;
import 'package:sce_project/interface/meet_volunteer.dart' as update;
import 'package:sce_project/interface/usercontact.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OtherProfile extends StatefulWidget {
  OtherProfile({super.key, required this.otherUser});

  final FetchUser.User1 otherUser;
  static String id = 'otherprofile';
  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  userInfo.User? user;
  String? _externalUserId;

  bool _isLoading = true;
  FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }


  Future<bool> areFriends(String userUid, String otherUserUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(userUid).get();
      DocumentSnapshot<Map<String, dynamic>> otherUserSnapshot =
          await _firestore.collection('users').doc(otherUserUid).get();

      List<dynamic> userFriends = userSnapshot['friends'];
      List<dynamic> otherUserFriends = otherUserSnapshot['friends'];

      if (userFriends.contains(otherUserUid) &&
          otherUserFriends.contains(userUid)) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking friendship status: $e');
      return false;
    }
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final fetchedUser = await userInfo.Fetch.fetchCurrentUser();
        setState(() {
          user = fetchedUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch current user: $e');
    }
  }

  Future<void> sendFriendRequest() async {
    try {
      await _firestore.collection('users').doc(widget.otherUser!.uid).update({
        'received_requests': FieldValue.arrayUnion([_auth.currentUser!.uid]),
      });
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'sent_requests': FieldValue.arrayUnion([widget.otherUser!.uid]),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Friend request sent'),
      ));
    } catch (e) {
      print('Failed to send friend request: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to send friend request'),
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            decoration: GradientBackground,
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : FutureBuilder<bool>(
            future: areFriends(user!.uid!, widget.otherUser.uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: GradientBackground,
                );
              } else {
                bool areFriends = snapshot.data ?? false;
                return Container(
                  decoration: GradientBackground,
                  child: Scaffold(
                    appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        leading: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ))),
                    backgroundColor: Colors.transparent,
                    body: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .5,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.elliptical(
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                            100.0),
                                        bottomRight: Radius.elliptical(
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                            100.0),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: widget.otherUser!.photoUrl !=
                                                null
                                            ? NetworkImage(
                                                widget.otherUser!.photoUrl!)
                                            : const NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/sce-project-679d8.appspot.com/o/profile_pictures%2Fperson-295.png?alt=media&token=034284ff-2eee-4158-a557-4dec345e701f'),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible: areFriends,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContactUser(
                                                        otherUser:
                                                            widget.otherUser,
                                                      )),
                                            );
                                          },
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Color(0xffD8D8D8),
                                            child: Icon(
                                              Icons.contact_page,
                                              size: 30,
                                              color: Color(0xff6E6E6E),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !areFriends,
                                        child: TextButton(
                                          onPressed: () {
                                            sendFriendRequest();
                                          },
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Color(0xffD8D8D8),
                                            child: Icon(
                                              Icons.person_add_alt_1_outlined,
                                              size: 30,
                                              color: Color(0xff6E6E6E),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text(
                              widget.otherUser!.username!,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Truculenta',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          user != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text(
                                    '${widget.otherUser!.bio}',
                                    style: const TextStyle(
                                        fontSize: 20, fontFamily: 'Truculenta'),
                                  ),
                                )
                              : Container(),
                          if (user != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              children: [
                                                const Text('Age'),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${widget.otherUser!.age!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              children: [
                                                const Text('Gender'),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${widget.otherUser!.gender!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              children: [
                                                const Text('Goal'),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${widget.otherUser!.goal!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              children: [
                                                const Text('Country'),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${widget.otherUser!.country!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              children: [
                                                const Text('City'),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${widget.otherUser!.city!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 1000.ms);
              }
            },
          );
  }
}
