import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sce_project/interface/meet_volunteer.dart';
import 'package:sce_project/intro/setup.dart';
import 'package:sce_project/intro/welcome_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = 'register_page';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  bool successful = false;

  String? mtoken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xF9F1DFFF), Color(0xFFBBBB99)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, WelcomePage.id);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Text(
                  "Meet  Volunteer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Satisfy',
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InputText(
                  key: const Key('usernameField'),
                  hint: 'Username:',
                  icon: Icons.person,
                  type: false,
                  controller: _usernameController),
              const SizedBox(
                height: 15,
              ),
              InputText(
                  key: const Key('emailField'),
                  hint: 'Email:',
                  icon: Icons.email_outlined,
                  type: false,
                  controller: _emailController),
              const SizedBox(
                height: 15,
              ),
              InputText(
                  key: const Key('passwordField'),
                  hint: 'Password (6-12):',
                  icon: Icons.password,
                  type: true,
                  controller: _passwordController),
              const SizedBox(
                height: 40,
              ),
              DesignedButton(
                  key: const Key('registerButton'),
                  text: "Register",
                  onPressed: () async {
                    try {
                      if (_passwordController.text == null ||
                          _emailController.text == null ||
                          _usernameController.text == null) {
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        setState(() {
                          successful = true;
                        });
                        User? user = userCredential.user;
                        await user!.updateDisplayName(_usernameController.text);
                        if (successful) {
                          getToken();
                          showToast("Your account has been registered.",
                              context: context,
                              position: StyledToastPosition.top,
                              backgroundColor: Colors.green);
                          print('WAS THERE');
                          Navigator.pushNamedAndRemoveUntil(
                              context, Setup.id, (route) => false);
                        }
                      }
                    } catch (e) {
                      setState(() {
                        successful = false;
                      });
                      setState(() {
                        isLoading = false;
                      });

                      showToast("Something went wrong.",
                          context: context,
                          position: StyledToastPosition.top,
                          backgroundColor: Colors.red);
                      print("Error");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token;
      print('My token is $mtoken');
    });
    saveToken(mtoken!);
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'token': token,
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
