import 'package:chat_app/Pages/settings/Friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String friendId;

  ChatScreen(this.friendId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  void loadMessages() async {
    try {
      // Load messages from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .where('receiverId', isEqualTo: widget.friendId)
          .orderBy('timestamp', descending: false)
          .get();

      // Convert documents to a list of message maps
      List<Map<String, dynamic>> msgs = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'text': doc['text'].toString(),
                'senderId': doc['senderId'].toString(),
                'timestamp': doc['timestamp'],
              })
          .toList();

      // Update messages state
      setState(() {
        messages = msgs;
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  String getMessageTime(DateTime messageTime) {
    // Function to format message time
    DateTime now = DateTime.now();

    if (now.difference(messageTime).inHours < 24) {
      return 'Today ${messageTime.hour}:${messageTime.minute}';
    } else if (now.difference(messageTime).inHours < 48) {
      return 'Yesterday ${messageTime.hour}:${messageTime.minute}';
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year} ${messageTime.hour}:${messageTime.minute}';
    }
  }

  void deleteMessage(String messageId) async {
    // Function to delete a message
    try {
      await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();

      // Reload messages
      loadMessages();
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  void sendMessage(String text) async {
    // Function to send a message
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'receiverId': widget.friendId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Reload messages
      loadMessages();
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.friendId}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final bool isCurrentUserSender =
                    FirebaseAuth.instance.currentUser!.uid == messages[index]['senderId'];

                return ListTile(
                  title: Text(messages[index]['text']),
                  subtitle: Text(
                    getMessageTime(messages[index]['timestamp'].toDate()),
                  ),
                  trailing: isCurrentUserSender
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Allow deletion only if the current user is the sender
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Delete Message"),
                                  content: const Text("Are you sure you want to delete this message?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteMessage(messages[index]['id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      // Handle text changes
                    },
                    onSubmitted: (text) {
                      // Handle text submitted
                      sendMessage(text);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      sendMessage(text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: FriendsPage(),
  ));
}
