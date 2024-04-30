import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// AuthService class for authentication and user data related functions
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to update profile picture
  Future<String> updateProfilePicture(File image) async {
    try {
      User? user = _auth.currentUser;

      // Uploading image to Firebase Storage
      String filePath = 'profile_images/${user?.uid}.jpg';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(image);
      String fileName = 'profile_images/${user?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await uploadTask.whenComplete(() {});

      // Uploading image again (this part seems redundant, consider removing it)
      await _storage.ref(fileName).putFile(image);

      // Getting download URL of the uploaded image
      String downloadURL = await _storage.ref(filePath).getDownloadURL();

      // Updating user's photo URL
      await user?.updatePhotoURL(downloadURL);
      return downloadURL;
    } catch (error) {
      throw error;
    }
  }

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

  // Method to update user details
  Future<void> updateUserDetails(String userName, String email) async {
    try {
      User? user = _auth.currentUser;

      // Updating user's display name and email
      await user?.updateDisplayName(userName);
      await user?.updateEmail(email);
    } catch (error) {
      throw error;
    }
  }
}
