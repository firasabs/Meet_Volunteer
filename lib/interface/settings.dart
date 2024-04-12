import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:sce_project/interface/contact.dart';
import 'package:sce_project/intro/login_page.dart';
import 'package:sce_project/intro/safetyguidelines.dart';
import 'package:sce_project/intro/setup.dart';
import 'package:sce_project/intro/welcome_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static String id = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;



  
  Future<void> _deleteAccount() async {  //delete account
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            title: 'Confirmation',
            desc: 'Are you sure you want to delete your account?',
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              await _firestore.collection('users').doc(user.uid).delete();
              if (user.photoURL != null) {
                await _storage.refFromURL(user.photoURL!).delete();
              }
              await user.delete();
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Account Deleted'),
              ));
              await Navigator.pushReplacementNamed(context, LoginPage.id);
             
            }).show();
      }
    } catch (error) {
      print("Error deleting account: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete your account'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Edit your profile',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Truculenta',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Container(
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30)),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setup(arrow: true,)),
                );
              },
              child: const Icon(
                color: Colors.white,
                Icons.edit,
                size: 70,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text('Delete Your Account',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Truculenta',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(30)),
            child: TextButton(
              onPressed: () {
                _deleteAccount();
              },
              child: const Icon(
                color: Colors.white,
                Icons.delete,
                size: 70,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text('Contact us',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Truculenta',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(30)),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactPage()),
                );
              },
              child: const Icon(
                color: Colors.white,
                Icons.message,
                size: 70,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text('Safety Guidelines',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Truculenta',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Container(
            decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(30)),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SafetyGuideLines()),
                );
              },
              child: const Icon(
                color: Colors.white,
                Icons.info,
                size: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
