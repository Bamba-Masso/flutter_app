import 'package:flutter/material.dart';
import 'package:chat_app/screens/discussion.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/composants/message.dart';
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final currentUser = FirebaseAuth.instance;
  final User? user = Auth().currentUser;
  final TextEditingController searchController = TextEditingController();
  
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFFececf8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: "Rechercher un utilisateur...",
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection("Users")
                      .where("uid", isNotEqualTo: currentUser.currentUser!.uid)
                      .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                 
                }
                final users =
                    snapshot.data!.docs.where((doc) {
                      final username = doc["username"].toString().toLowerCase();
                      return username.contains(searchQuery);
                    }).toList();

                if (users.isEmpty) {
                  return const Center(child: Text("Aucun utilisateur trouvé."));
                }

                return ListView.builder(
                  // shrinkWrap: true,
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
                                (context) => Discussion(
                                  mail: userMail,
                                  uid: userUid,
                                  username: userUsername,
                                ),
                          ),
                        );
                      },
                      child: Message(
                        userMail: userMail,
                        userUid: userUid,
                        userUsername: userUsername,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
  }
}
