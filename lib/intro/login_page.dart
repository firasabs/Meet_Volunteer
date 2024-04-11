import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sce_project/interface/meet_volunteer.dart';
import 'package:sce_project/helpers/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sce_project/intro/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool successful = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xF9F1DFFF),
              Color(0xFFBBBB99)
            ], // Adjust the colors as needed
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
                  key: const Key('emailField'),
                  hint: 'Enter your email:',
                  icon: Icons.email_outlined,
                  type: false,
                  controller: _emailController),
              const SizedBox(
                height: 15,
              ),
              InputText(
                  hint: 'Enter your password:',
                  key: const Key('passwordField'),
                  icon: Icons.password,
                  type: true,
                  controller: _passwordController),
              const SizedBox(
                height: 40,
              ),
              DesignedButton(
                  key: const Key('loginButton'),
                  text: "Log in",
                  onPressed: () async {
                    try {
                      if (_passwordController.text == null ||
                          _emailController.text == null) {
                      } else {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        setState(() {
                          successful = true;
                          saveUserLoggedIn(false);
                        });

                        if (successful) {
                          showToast(
                              "Welcome back ${userCredential.user!.displayName!}!",
                              context: context,
                              position: StyledToastPosition.top,
                              backgroundColor: Colors.green);
                          Navigator.pushNamedAndRemoveUntil(
                              context, MeetVolunteer.id, (route) => false);
                        }
                      }
                    } catch (e) {
                      setState(() {
                        successful = false;
                      });

                      showToast("Invalid email or password.",
                          context: context,
                          position: StyledToastPosition.top,
                          backgroundColor: Colors.red);
                      print("Error");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
