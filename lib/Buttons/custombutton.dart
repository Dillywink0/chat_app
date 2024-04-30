import 'package:flutter/material.dart';

// CustomButton widget for a customizable button
class CustomButton extends StatelessWidget {
  final Color accentColor; // Color for text and border
  final Color mainColor; // Background color
  final String text; // Text displayed on the button
  final Function onpress; // Callback function when the button is pressed

  // Constructor
  const CustomButton({
    Key? key, // Added Key parameter
    required this.accentColor,
    required this.text,
    required this.mainColor,
    required this.onpress,
  }) : super(key: key); // Added super call to pass the key to the superclass constructor

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // Returning GestureDetector widget for handling taps
    return GestureDetector(
    //  onTap: onpress, // Calling the provided callback function when the button is tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: accentColor, // Border color
          ),
          color: mainColor, // Background color
          borderRadius: BorderRadius.circular(50), // Border radius for rounded corners
        ),
        width: MediaQuery.of(context).size.width * 0.6, // Button width as 60% of the screen width
        padding: const EdgeInsets.all(15), // Padding around the button content
        child: Center(
          child: Text(
            text.toUpperCase(), // Text displayed on the button, converted to uppercase
            style: TextStyle(fontFamily: 'Poppins', color: accentColor), // Text style
          ),
        ),
      ),
    );
  }
}
