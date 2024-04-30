import 'package:flutter/material.dart';

// MyTextField widget for a customizable text field
class MyTextField extends StatelessWidget {
  // Controller for the text field
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText; // Hint text displayed in the text field
  final bool obscureText; // Boolean flag indicating whether the text should be obscured (e.g., for password fields)

  // Constructor
  const MyTextField({
    super.key, // Added Key parameter
    required this.controller, // Required controller for the text field
    required this.hintText, // Required hint text for the text field
    required this.obscureText, // Required boolean flag for obscuring text
  }); // Added super call to pass the key to the superclass constructor

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // Returning a Padding widget wrapping a TextField
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0), // Padding around the text field
      child: TextField(
        controller: controller, // Setting controller for the text field
        obscureText: obscureText, // Setting obscure text flag
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color when the text field is enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400), // Border color when the text field is focused
          ),
          fillColor: Colors.grey.shade200, // Fill color of the text field
          filled: true, // Setting filled property to true
          hintText: hintText, // Setting hint text
          hintStyle: const TextStyle(color: Colors.black), // Setting hint text style
        ),
      ),
    );
  }
}
