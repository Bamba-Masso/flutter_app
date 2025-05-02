import 'package:cloud_firestore/cloud_firestore.dart';

class Messagerie {
  FirebaseFirestore db = FirebaseFirestore.instance;
  sendMessage(String currentUid, String receiverUid, String message) async {
    List chatIds = [currentUid, receiverUid];
    chatIds.sort(); 
    String chatId = chatIds.join("_");


    
    await db.collection("Chats").doc(chatId).collection(chatId).add({
      "senderUid": currentUid,
      "receiverUid": receiverUid,
      "message": message,
      "chatId": chatId,
      "timeStamps": Timestamp.now(),
    });

   
    var discussionRef = db.collection("Discussion").doc(chatId);

   
    var snapshot = await discussionRef.get();

    if (!snapshot.exists) {
    
      await discussionRef.set({
        'users': [currentUid, receiverUid],
        'lastMessage': message,
        'lastMessageTime': Timestamp.now(),
      });
    } else {
    
      await discussionRef.update({
        'lastMessage': message,
        'lastMessageTime': Timestamp.now(),
      });
    }
  }
}
