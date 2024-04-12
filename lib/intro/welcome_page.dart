import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:sce_project/intro/login_page.dart';
import 'package:sce_project/intro/register_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  static String id = 'welcome_page';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                DesignedButton(
                  text: "Log in",
                  onPressed: () {
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                DesignedButton(
                  text: "Register",
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

VoidCallback test() {
  return () {};
}
