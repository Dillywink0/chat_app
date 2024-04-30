import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ChatService class for managing chat-related functionalities
class ChatService extends ChangeNotifier {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to send a message
  Future<void> sendMessage(String recevierUserID, string, message) async {
    // Get current user's ID, email, and current timestamp
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // Implement message sending logic here
  }

  // Stream method to get users' data
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data(); // Get user data
        return user;
      }).toList(); // Return list of users
    });
  }
}
