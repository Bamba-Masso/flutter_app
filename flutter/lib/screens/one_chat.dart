import 'package:flutter/material.dart';

class OneChatScreen extends StatefulWidget {
  final String name;
  final String image;

  const OneChatScreen({super.key, required this.name, required this.image});

  @override
  State<OneChatScreen> createState() => _OneChatScreenState();
}

class _OneChatScreenState extends State<OneChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': "Hey Justin, what's up?",
      'isMe': false,
      'date': "Today, May 3",
    },
    {
      'text': "Oh hey there, Anna. I'm all good btw. How are you?",
      'isMe': true,
      'date': "Today, May 3",
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': text,
          'isMe': true,
          'date': "Today, May 3", 
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.image),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(widget.name, style: const TextStyle(color: Colors.black)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - 1 - index;
                final msg = _messages[reversedIndex];
                final isMe = msg['isMe'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (index == _messages.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          msg['date'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.teal : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 18),
                          ),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black54),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Aa",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.black54),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
