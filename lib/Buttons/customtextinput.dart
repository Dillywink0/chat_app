import 'package:flutter/material.dart';

// CustomTextInput widget for a customizable text input field
class CustomTextInput extends StatelessWidget {
  final String hintText; // Hint text displayed in the text field
  final IconData leading; // Leading icon for the text field
  final Function userTyped; // Callback function called when the user types
  final bool obscure; // Boolean flag indicating whether the text should be obscured (e.g., for password fields)
  final TextInputType keyboard; // Keyboard type for the text field

  // Constructor
  const CustomTextInput({
    super.key, // Added Key parameter
    required this.hintText,
    required this.leading,
    required this.userTyped,
    required this.obscure,
    this.keyboard = TextInputType.text, // Default keyboard type is TextInputType.text
  }); // Added super call to pass the key to the superclass constructor

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // Returning a container with a text field inside
    return Container(
      margin: const EdgeInsets.only(top: 15), // Margin for spacing
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the container
        borderRadius: BorderRadius.circular(30), // Border radius for rounded corners
      ),
      padding: const EdgeInsets.only(left: 10), // Padding inside the container
      width: MediaQuery.of(context).size.width * 0.70, // Width of the container as 70% of the screen width
      child: TextField(
        keyboardType: keyboard, // Setting keyboard type
        onSubmitted: (value) {}, // Callback function called when the user submits the text field
        autofocus: false, // Autofocus set to false
        obscureText: obscure ? true : false, // Setting obscure text flag
        decoration: InputDecoration(
          icon: Icon(
            leading, // Leading icon
            color: Colors.deepPurple, // Icon color
          ),
          border: InputBorder.none, // Removing border
          hintText: hintText, // Setting hint text
          hintStyle: const TextStyle(
            fontFamily: 'Poppins', // Setting hint text style
          ),
        ),
      ),
    );
  }
}
