import 'package:flutter/material.dart';

// MyButton widget for custom button
class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  // Constructor
  const MyButton({
    super.key, // Added Key parameter
    required this.text,
    required this.onTap,
  }); // Added super call to pass the key to the superclass constructor

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // Returning GestureDetector widget for handling taps
    return GestureDetector(
      onTap: onTap, // Calling onTap function when tapped
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(212, 135, 81, 77),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.amber),
            ),
            const SizedBox(
              height: 15,
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}
