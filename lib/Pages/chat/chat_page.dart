import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../auth/database_service.dart'; // Importing database service for interacting with Firestore
import '../../widgets/message_tile.dart'; // Importing message tile widget
import '../../widgets/widgets.dart'; // Importing custom widgets
import '../Groups/group.dart'; // Importing group screen

// ChatPage widget for displaying group chat
class ChatPage extends StatefulWidget {
  final String groupId; // ID of the group
  final String groupName; // Name of the group
  final String userName; // Name of the current user
  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats; // Stream of chat messages
  TextEditingController messageController = TextEditingController(); // Controller for message input
  String admin = ""; // Admin of the group

  @override
  void initState() {
    getChatandAdmin(); // Initialize chat and admin data
    super.initState();
  }

  // Method to fetch chat messages and group admin
  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val; // Set chat stream
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val; // Set group admin
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName), // Display group name in app bar
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              ); // Navigate to group info screen
            },
            icon: const Icon(Icons.info), // Info icon for group details
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Display chat messages
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage(); // Send message when send button is tapped
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget for displaying chat messages
  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                  ); // Display message tile
                },
              )
            : Container(); // Return empty container if no data available
      },
    );
  }

  // Method to send message
  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap); // Send message to Firestore
      setState(() {
        messageController.clear(); // Clear message input field
      });
    }
  }
}
