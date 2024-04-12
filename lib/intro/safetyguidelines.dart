import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';

class SafetyGuideLines extends StatefulWidget {
  const SafetyGuideLines({super.key});
  static String id = 'safetyguidelines';

  @override
  State<SafetyGuideLines> createState() => _SafetyGuideLinesState();
}

class _SafetyGuideLinesState extends State<SafetyGuideLines> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        alignment: Alignment.center,
        decoration: GradientBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Safety and Guidelines",
                style: TextStyle(
                    fontSize: 37,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Truculenta')),
            backgroundColor: Colors.transparent,
            leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon( // backward arrow icon
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                )),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: GradientBackground,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0), // distance between appbar and container
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[1]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[2]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[3]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[4]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[5]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[6]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[7]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    '-${rules[8]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Truculenta'),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  List<String> rules = [
    'Respect and Dignity: Treat all users with respect, kindness, and empathy. Discrimination, harassment, hate speech, or any form of disrespectful behavior will not be tolerated.',
    'Volunteers and elderly users must provide accurate information during the registration process.',
    'Protect your personal information and exercise caution when sharing sensitive details with other users.',
    'Communicate respectfully and appropriately with other users.',
    'Report any instances of abusive, threatening, or inappropriate messages to our moderation team.',
    'Prioritize safety when arranging in-person meetings with other users.',
    'Seek assistance from our support team if you encounter any issues or concerns regarding safety.',
    'Provide feedback on your experiences using the app, including suggestions for improving safety features.',
    'Report any suspicious or concerning behavior to help maintain a safe and inclusive space for all.',
  ];
}
