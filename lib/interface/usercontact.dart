import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:sce_project/interface/browse.dart' as _user;

class ContactUser extends StatefulWidget {
  const ContactUser({super.key, required this.otherUser});
  final _user.User1 otherUser;
  static String id = 'usercontact';
  @override
  State<ContactUser> createState() => _ContactUserState();
}

class _ContactUserState extends State<ContactUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xF9F1DFFF), Color(0xFFBBBB99)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "${widget.otherUser.username}",
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.otherUser.email}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Truculenta'),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ]),
      ),
    ));
  }
}
