import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sce_project/helpers/designs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_test/flutter_test.dart'; // For unit testing
import 'package:mockito/mockito.dart'; // For unit testing

// Create a mock for FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  static String id = 'contact';

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _numbercontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _topiccontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  bool loading = false;

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
            leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Center(
              child: Text(
                "Contact Us",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loading
                  ? LoadingAnimationWidget.inkDrop(
                      color: Colors.blue,
                      size: 45,
                    )
                  : Container(),
              InputText(
                  hint: 'Email (Required)',
                  icon: Icons.email,
                  type: false,
                  controller: _emailcontroller),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0, right: 30),
                child: TextField(
                  controller: _numbercontroller,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone number (Optional)",
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputText(
                  hint: 'Topic',
                  icon: Icons.message,
                  type: false,
                  controller: _topiccontroller),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0, right: 30),
                child: TextField(
                  maxLines: 8,
                  controller: _descriptioncontroller,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Description",
                    icon: const Icon(
                      Icons.text_fields,
                      color: Colors.transparent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              DesignedButton(
                  key: const Key('submitButtom'),
                  text: "Submit",
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    if (_emailcontroller.text.isEmpty) {
                      showToast("Please fill your email.",
                          context: context,
                          position: StyledToastPosition.top,
                          backgroundColor: Colors.red);
                      setState(() {
                        loading = false;
                      });
                    } else {
                      try {
                        // Get a reference to the Firestore collection
                        CollectionReference contactCollection = 
                            FirebaseFirestore.instance
                                .collection('support_submittions');
                        await contactCollection.add({
                          'email': _emailcontroller.text,
                          'phone': _numbercontroller.text,
                          'topic': _topiccontroller.text,
                          'description': _descriptioncontroller.text,
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        showToast("Submission successful!",
                            context: context,
                            position: StyledToastPosition.top,
                            backgroundColor: Colors.green);
                        setState(() {
                          loading = false;
                        });
                      } catch (e) {
                        print("Error submitting data: $e");
                        showToast("Error submitting data.",
                            context: context,
                            position: StyledToastPosition.top,
                            backgroundColor: Colors.red);

                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  }),
              const SizedBox(
                height: 70,
              ),
              const Text(
                "Or send a message \nat @malikab1@ac.sce.ac.il",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
