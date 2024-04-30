import 'package:flutter/material.dart';

// Model class for chat message
class ChatMessage {
  final String sender;
  final String text;
  bool isMuted;

  ChatMessage({
    required this.sender,
    required this.text,
    this.isMuted = false,
  });
}

// Model class for pinned message
class PinnedMessage {
  final ChatMessage message;
  bool isPinned;

  PinnedMessage({required this.message, this.isPinned = false});
}

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  // List of chat messages
  List<ChatMessage> messages = [
    ChatMessage(sender: 'User1', text: 'Hello!', isMuted: false),
    ChatMessage(sender: 'User2', text: 'Hi there!', isMuted: false),
    ChatMessage(sender: 'User1', text: 'How are you?', isMuted: false),
  ];

  // List of pinned messages
  List<PinnedMessage> pinnedMessages = [];

  // Widget to build each chat message
  Widget buildMessage(ChatMessage message) {
    return ListTile(
      title: Text(message.sender),
      subtitle: Text(message.text),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: () {
              setState(() {
                pinnedMessages.add(PinnedMessage(message: message, isPinned: true));
              });
            },
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
        ],
      ),
    );
  }

  // Widget to build each pinned message
  Widget buildPinnedMessage(PinnedMessage pinnedMessage) {
    return ListTile(
      title: Text(pinnedMessage.message.sender),
      subtitle: Text(pinnedMessage.message.text),
      trailing: IconButton(
        icon: const Icon(Icons.push_pin),
        onPressed: () {
          setState(() {
            pinnedMessage.isPinned = false;
            pinnedMessages.remove(pinnedMessage);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pinnedMessages.length,
              itemBuilder: (context, index) {
                return buildPinnedMessage(pinnedMessages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GroupChat(),
  ));
}
