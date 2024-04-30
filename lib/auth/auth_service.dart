import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// AuthService class for authentication and user data related functions
class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get user details by UID
  Future<Map<String, dynamic>> getUserDetailsByUid(String uid) async {
    try {
      // Fetching user document from Firestore
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
      return userSnapshot.data() as Map<String, dynamic>; // Returning user data
    } catch (e) {
      throw Exception('Error fetching user details: $e'); // Throwing exception if an error occurs
    }
  }

  // Method to sign in with email and password
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      // Signing in with email and password
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Updating user document in Firestore with UID and email
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential; // Returning user credentials
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code); // Throwing exception if an error occurs
    }
  }

  // Method to sign up with email and password
  Future<UserCredential> signUpWithEmailandPassword(String email, String password) async {
    try {
      // Creating user with email and password
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password,
      );

      // Creating user document in Firestore with UID and email
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential; // Returning user credentials
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code); // Throwing exception if an error occurs
    }
  }
   
  // Method to sign out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut(); // Signing out from Firebase
  }
}