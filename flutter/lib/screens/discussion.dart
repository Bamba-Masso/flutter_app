import 'package:chat_app/fonctionnalites/messageries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/composants/dataMessage.dart';
import 'package:flutter/material.dart';

class Discussion extends StatefulWidget {
  const Discussion({
    super.key,
    required this.mail,
    required this.uid,
    required this.username,
  });

  final String mail;
  final String uid;
  final String username;

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List chatIds = [auth.currentUser!.uid, widget.uid];
    chatIds.sort();
    String chatId = chatIds.join("_");

    const pastelColor = Color(0xFFE0F2F1);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username, style: const TextStyle(color: Colors.black)),
        backgroundColor: pastelColor,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              print("Appel vocal");
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              print("Appel vidéo");
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Chats")
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('timeStamps', descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Aucun message pour l'instant"));
                }

                List<dynamic> messages = [];
                snapshot.data!.docs.forEach((_element) {
                  messages.add(_element);
                });

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final content = message["message"];
                    final senderUid = message['senderUid'];

                    return DataMessage(
                      message: content,
                      rUid: senderUid,
                      currentUid: auth.currentUser!.uid,
                    );
                  },
                );
              },
            ),
          ),

          
          Container(
            color: pastelColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                
                GestureDetector(
                  onTap: () {
                    print("Ouvrir options : emoji ou image");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 28, color: Colors.teal),
                  ),
                ),
                const SizedBox(width: 10),

            
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Nouveau message",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

               
                GestureDetector(
                  onTap: () {
                    if (messageController.text.isNotEmpty) {
                      Messagerie().sendMessage(
                        auth.currentUser!.uid,
                        widget.uid,
                        messageController.text,
                      );
                      messageController.text = "";
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
