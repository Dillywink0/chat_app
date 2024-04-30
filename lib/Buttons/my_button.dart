import 'package:flutter/material.dart';

// CustomButton widget for a customizable button
class CustomButton extends StatelessWidget {
  // Constructor
  const CustomButton({
    required this.text, // Text displayed on the button
    required this.colorbtn, // Background color of the button
    required this.onPressed, // Callback function when the button is pressed
    super.key, // Added Key parameter
  }); // Added super call to pass the key to the superclass constructor

  final String text; // Text displayed on the button
  final Color colorbtn; // Background color of the button
  final VoidCallback onPressed; // Callback function when the button is pressed

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // Returning a Material widget wrapped in Padding for the button
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Padding around the button
      child: Material(
        elevation: 2, // Elevation of the button
        borderRadius: BorderRadius.circular(6), // Border radius for rounded corners
        color: colorbtn, // Background color of the button
        child: MaterialButton(
          minWidth: double.infinity, // Setting button width to match the parent width
          onPressed: onPressed, // Calling the provided callback function when the button is pressed
          child: Text(
            text, // Text displayed on the button
            style: const TextStyle(color: Colors.black, fontSize: 20), // Text style
          ),
        ),
      ),
    );
  }
}
