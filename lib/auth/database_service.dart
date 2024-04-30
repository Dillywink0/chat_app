import 'package:cloud_firestore/cloud_firestore.dart';

// DatabaseService class for database related functions
class DatabaseService {
  final String? uid;

  // Constructor
  DatabaseService({this.uid});

  // Collection references
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");
  final CollectionReference friendRequestsCollection = FirebaseFirestore.instance.collection('friendRequests');

  // Method to save user data to Firestore
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // Method to send friend request
  Future<void> sendFriendRequest(String receiverUid) async {
    try {
      // Sending friend request to the receiver and updating sender's and receiver's collections
      await userCollection.doc(uid).collection('friendRequestsSent').doc(receiverUid).set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      await userCollection.doc(receiverUid).collection('friendRequestsReceived').doc(uid).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
  
    } catch (e) {
      print('Error sending friend request: $e');
      throw Exception('Failed to send friend request.');
    }
  }

  // Method to accept friend request
  Future<void> acceptFriendRequest(String senderId, String receiverId) async {
    // Updating friends list of both sender and receiver
    await userCollection.doc(receiverId).update({
      'friends': FieldValue.arrayUnion([senderId]),
    });

    await userCollection.doc(senderId).update({
      'friends': FieldValue.arrayUnion([receiverId]),
    });

    // Deleting friend request document
    await friendRequestsCollection.doc(receiverId).collection('requests').doc(senderId).delete();
  }

  // Method to decline friend request
  Future<void> declineFriendRequest(String senderId, String receiverId) async {
    // Deleting friend request document
    await friendRequestsCollection.doc(receiverId).collection('requests').doc(senderId).delete();
  }

  // Stream to get friend requests
  Stream<QuerySnapshot> getFriendRequests(String userId) {
    return friendRequestsCollection.doc(userId).collection('requests').snapshots();
  }

  // Method to get user's friends
  Future<List<String>> getUserFriends(String userId) async {
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();
    List<String> friends = List<String>.from(userDoc['friends'] ?? []);
    return friends;
  }

  // Method to get user data by email
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // Method to get all groups
  Future<List<DocumentSnapshot>> getAllGroups() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('groups').get();
    return querySnapshot.docs;
  }

  // Method to get user's groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // Method to create a group
  Future createGroup(String userName, String id, String groupName) async {
    // Adding group document to Firestore and updating user's groups
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // Method to get chats of a group
  getChats(String groupId) async {
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  // Method to get group admin
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // Method to get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // Method to search groups by name
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // Method to check if user is joined a group
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // Method to toggle group join
  Future toggleGroupJoin(String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // Method to send a message to a group
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // Method to change group admin
  Future<void> changeGroupAdmin(String groupId, String newAdminUserId) async {
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'admin': newAdminUserId,
    });
  }
}
