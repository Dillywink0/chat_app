import 'package:firebase_auth/firebase_auth.dart';

// Auth class for authentication related functions
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getter to get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream for authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Method to sign in with email and password
  Future<void> signInwithEmailandPassword({
    required String email,
    required String password,
  }) async {
    // Signing in with email and password
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Method to sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut(); // Signing out from Firebase
  }
}
