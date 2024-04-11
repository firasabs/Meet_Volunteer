import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesignedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DesignedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue, // Change the color to your desired color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class InputText extends StatefulWidget {
  const InputText({
    super.key,
    required this.hint,
    required this.icon,
    required this.type,
    required this.controller, // Add controller parameter
  });

  final String hint;
  final IconData icon;
  final bool type;
  final TextEditingController controller; // Declare the controller

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 30.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.type,
        keyboardType:
            widget.type ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hint,
          icon: Icon(
            widget.icon,
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
    );
  }
}

BoxDecoration GradientBackground = const BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xA9F1DFFF), Color(0xFFBBBB99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

void saveDataToFirestore(String data) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('example');

  await collectionReference.add({
    'data': data,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
