import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const UserDetailsScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'), // Deals with User Details text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: $userId'), // Deals with the Text for the User ID
            const SizedBox(height: 8),
            Text('User Name: $userName'), // Deals with the User name TEXT
            // Add more user details as needed
          ],
        ),
      ),
    );
  }
}