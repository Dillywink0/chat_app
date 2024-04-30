import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  // Constructor to initialize with user ID
  DatabaseService({required this.uid});

  // Collection references
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference friendRequestsCollection = FirebaseFirestore.instance.collection('friendRequests');

  // Get user details from Firestore
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  // Get a list of user's friends from Firestore
  Future<List<String>> getUserFriends(String userId) async {
    DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
    List<String> friends = List<String>.from(userDoc['friends'] ?? []);
    return friends;
  }

  // Send a friend request (commented out for now)
  // Future<void> sendFriendRequest(String senderId, String receiverId) async {
  //   // Implementation goes here
  // }

  // Accept a friend request (commented out for now)
  // Future<void> acceptFriendRequest(String senderId, String receiverId) async {
  //   // Implementation goes here
  // }

  // Decline a friend request (commented out for now)
  // Future<void> declineFriendRequest(String senderId, String receiverId) async {
  //   // Implementation goes here
  // }

  // Get friend requests for a user (commented out for now)
  // Stream<QuerySnapshot> getFriendRequests(String userId) {
  //   // Implementation goes here
  // }

  // Send a message to Firestore
  void sendMessage(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection('your_messages_collection')
          .add({
            'senderId': FirebaseAuth.instance.currentUser!.uid,
            'text': text,
            'timestamp': DateTime.now(),
          });
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
