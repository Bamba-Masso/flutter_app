import 'package:chat_app/screens/discussion.dart';
import 'package:chat_app/screens/one_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/composants/message.dart';

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
            onPressed: (){},
             icon: const Icon(Icons.person))
        ],
      ),

      backgroundColor: const Color(0xFFE0F2F1),

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

// class ChatItem extends StatelessWidget {
//   final String name;
//   final String country;
//   final String image;
//   final bool isNew;

//   const ChatItem({
//     super.key,
//     required this.name,
//     required this.country,
//     required this.image,
//     this.isNew = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(image),
//           radius: 25,
//         ),
//         title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Text(country),
//         trailing: isNew
//             ? Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.teal,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Text(
//                   'Nouveau',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }
