import 'package:chat_app/screens/discussion.dart';
import 'package:chat_app/screens/one_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/composants/message.dart';
import 'package:chat_app/screens/profil_screen.dart';
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        
        title: Text( user?.displayName?? ""),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Auth().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OneScreen()),
              );
            },
          ),
          IconButton(
            onPressed: ( ){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
             icon: const Icon(Icons.person))
        ],
      ),

      backgroundColor: const Color.fromARGB(255, 181, 224, 222),

      body: StreamBuilder(
     
        stream:
            FirebaseFirestore.instance
                .collection("Users")
                .where("uid", isNotEqualTo: currentUser.currentUser!.uid)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("aucun utilisateur");
          }
          List<dynamic> users = [];
          snapshot.data!.docs.forEach((_element) {
            users.add(_element);
          });
          return ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userMail = user["email"];
              final userUid = user['uid'];
              final userUsername = user['username'];

              // return Message(userMail:userMail , userUid:userUid);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Discussion(mail: userMail, uid: userUid, username:userUsername),
                    ),
                  );
                },
                child: Message(userMail: userMail, userUid: userUid, userUsername: userUsername,),
              );
            },
          );
        },
       
      ),

    );
  }
}

extension on User? {
  get username => null;
}

