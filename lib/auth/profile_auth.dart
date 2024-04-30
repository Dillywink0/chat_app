import 'package:firebase_auth/firebase_auth.dart';

// AuthService class for authentication related functions
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get user email
  Future<String?> getUserEmail() async {
    try {
      // Getting current user
      User? user = _auth.currentUser;
      // Returning user's email
      return user?.email;
    } catch (e) {
      // Handling errors
      print("Error getting user email: $e");
      return null;
    }
  }
}
