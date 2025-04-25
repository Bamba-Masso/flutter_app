import 'package:cloud_firestore/cloud_firestore.dart';


class Messagerie {
FirebaseFirestore db = FirebaseFirestore.instance;

  sendMessage(String currentUid,String receiverUid, String message, String chatId){
    List chatIds=[currentUid, receiverUid];
    chatIds.sort();
    String chatId =chatIds.join("_");

    db.collection("Chats").doc(chatId).collection(chatId).add({
      "senderUid": currentUid,
      "receiverUid":receiverUid,
      "message":message,
      "chatId":chatId,
      "timeStamps":Timestamp.now()
    });
  }
}