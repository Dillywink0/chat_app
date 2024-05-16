import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/database_service.dart';
import '../home/home.dart';

// Model class for chat message
class ChatMessage {
  final String id; // Unique ID for each message
  final String sender;
  final String text;
  final DateTime timestamp; // Timestamp of the message
  Map<String, bool> readStatus; // Map to track read status of each member
  bool isMuted; // Define isMuted property

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    Map<String, bool>? readStatus,
    this.isMuted = false, // Initialize isMuted to false by default
  }) : this.readStatus = readStatus ?? {};

  // Method to mark message as read
  void markAsRead(String userId) {
    readStatus[userId] = true;
  }
}

// Model class for pinned message
class PinnedMessage {
  final ChatMessage message;
  final bool isPinned;

  PinnedMessage({
    required this.message,
    required this.isPinned,
  });
}

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({
    Key? key,
    required this.adminName,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String selectedMember = '';
  List<ChatMessage> messages = [];
  List<PinnedMessage> pinnedMessages = [];

  @override
  void initState() {
    super.initState();
    getMembers();
    loadMockMessages(); // You can replace this with actual message loading logic
  }

  // Mock method to load messages
  void loadMockMessages() {
    setState(() {
      messages = [
        ChatMessage(id: '1', sender: 'User1', text: 'Hello!', timestamp: DateTime.now(), readStatus: {}),
        ChatMessage(id: '2', sender: 'User2', text: 'Hi there!', timestamp: DateTime.now(), readStatus: {}),
        ChatMessage(id: '3', sender: 'User1', text: 'How are you?', timestamp: DateTime.now(), readStatus: {}),
      ];
    });
  }

  // Method to get members of the group
  getMembers() async {
    try {
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getGroupMembers(widget.groupId)
          .then((val) {
        setState(() {
          members = val;
        });
      });
    } catch (e) {
      print("Error fetching group members: $e");
    }
  }

  // Method to extract name from the user ID
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  // Method to extract ID from the user ID
  String getId(String res) {
    int underscoreIndex = res.indexOf("_");
    return underscoreIndex != -1 ? res.substring(0, underscoreIndex) : res;
  }

  // Method to send friend request
  void sendFriendRequest(String receiverId, String receiverName) async {
    try {
      // Check if a friend request already exists
      final existingRequest = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('receiverId', isEqualTo: receiverId)
          .get();

      if (existingRequest.docs.isEmpty) {
        // If no existing request, send a new friend request
        await FirebaseFirestore.instance.collection('friend_requests').add({
          'senderId': FirebaseAuth.instance.currentUser!.uid,
          'receiverId': receiverId,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Remove the friend request from the list in the current widget
        setState(() {
          messages.removeWhere((message) => getId(message.text) == receiverId);
        });

        // You may want to show a success message to the user
        print('Friend request sent successfully!');
      } else {
        // Display a message indicating that a friend request already exists
        print('Friend request already sent.');
      }
    } catch (e) {
      print('Error sending friend request: $e');
      // Handle the error appropriately
    }
  }

  // Method to build each message as a ListTile widget
  Widget buildMessage(ChatMessage message) {
    bool isMessageRead =
        message.readStatus[FirebaseAuth.instance.currentUser!.uid] ?? false;

    return ListTile(
      title: Text(message.sender),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.text),
          Text(
            '${message.timestamp.hour}:${message.timestamp.minute}', // Displaying time
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMessageRead)
            const Icon(
              Icons.done_all,
              color: Colors.blue, // Change color based on your design
            ),
          IconButton(
            icon: Icon(message.isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: () {
              setState(() {
                message.isMuted = !message.isMuted;
              });
              // Implement your logic to update the mute status in the database
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Trigger the function to send a friend request
              sendFriendRequest(getId(message.text), message.sender);
            },
          ),
        ],
      ),
      onTap: () {
        // Mark message as read when tapped
        markMessageAsRead(message);
      },
    );
  }

  // Widget to display the list of members
  Widget memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String memberName = getName(snapshot.data['members'][index]);
                  String memberId = getId(snapshot.data['members'][index]);

                  return buildMessage(
                    ChatMessage(
                      id: memberId,
                      sender: memberName,
                      text: memberId,
                      timestamp: DateTime.now(), // Replace with actual timestamp
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  // Method to mark message as read
  void markMessageAsRead(ChatMessage message) {
    message.markAsRead(FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance
        .collection('group_messages')
        .doc(widget.groupId)
        .collection('messages')
        .doc(message.id) // Assuming each message has a unique ID
        .update({
      'readStatus.${FirebaseAuth.instance.currentUser!.uid}': true,
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit"),
                    content: const Text("Are you sure you want to exit the group?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .toggleGroupJoin(widget.groupId,
                                  getName(widget.adminName), widget.groupName)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () {
              showRenameGroupDialog(context);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              // Trigger the function to change the group admin
              changeGroupAdmin();
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              // Replace 'receiverId' and 'receiverName' with the actual logic
              // to get the friend's ID and name
              sendFriendRequest('receiverId', 'receiverName');
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.adminName)}"),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: memberList(),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show dialog for renaming the group
  void showRenameGroupDialog(BuildContext context) {}

  // Method to change the group admin
  void changeGroupAdmin() {
    // Placeholder function for changing the group admin
    print("Changing group admin");
    // Add your logic here if needed
  }
}
