// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';

// Importing helper functions
import '../helper/helper_function.dart';

// Importing database service
import 'database_service.dart';

// AuthService class for authentication related functions
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Method for logging in with email and password
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      // Signing in with email and password
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true; // Return true if user is not null (login successful)
      }
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if login fails
    }
  }

  // Method for registering a new user with email and password
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      // Creating user with email and password
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // Call database service to update user data
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true; // Return true if user creation and data update successful
      }
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if registration fails
    }
  }

  // Method for signing out
  Future signOut() async {
    try {
      // Saving user logged-in status as false and clearing user data
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut(); // Signing out from Firebase
    } catch (e) {
      return null; // Return null if sign out fails
    }
  }
}
