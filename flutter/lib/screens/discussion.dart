import 'package:chat_app/fonctionnalites/messageries.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chat_app/composants/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/composants/dataMessage.dart';
import 'package:flutter/material.dart';

class Discussion extends StatefulWidget {
  const Discussion({super.key, required this.mail, required this.uid, required this.username });

  final String mail;
  final String uid;
  final String username;
 
  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final  messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List chatIds = [auth.currentUser!.uid, widget.uid];
    chatIds.sort();
    String chatId = chatIds.join("_");

   return Scaffold(
  appBar: AppBar(title: Text(widget.username)),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // StreamBuilder pour afficher les messages
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
            snapshot.data!.docs.forEach((_element){
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

      // Zone pour entrer un nouveau message
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Nouveau message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
            ),

            SizedBox( width:15),
            GestureDetector(
              onTap: () {
                if (messageController.text.isNotEmpty) {
                  Messagerie().sendMessage(
                    auth.currentUser!.uid,
                    widget.uid,
                    messageController.text,
                    DateTime.now().toString(), 
                  );
                  messageController.text = "";
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
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
