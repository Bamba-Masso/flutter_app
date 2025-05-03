import 'package:chat_app/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/screens/discussion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:chat_app/composants/message.dart';
import 'package:flutter/material.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({
    super.key,
    required this.currentUserUid,
    required this.userMail,
    required this.userUsername,
  });
  final String currentUserUid;
  final String userMail;
  final String userUsername;

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Map<String, dynamic> allUsers = {};
  bool isLoading = true;

  final currentUser = FirebaseAuth.instance;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  final User? user = Auth().currentUser;

  @override

void initState() {
    super.initState();
    fetchAllUsers();
  }

    Future<void> fetchAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    Map<String, dynamic> userMap = {};
    for (var doc in snapshot.docs) {
      userMap[doc.id] = doc.data(); // doc.id = UID
    }
    setState(() {
      allUsers = userMap;
      isLoading = false;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Discussion')
          .where('users', arrayContains: widget.currentUserUid)
          .where('lastMessageTime',
              isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(0))
          .orderBy('lastMessageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Aucune discussion trouvée"));
        }

        var conversations = snapshot.data!.docs;
        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            var data = conversations[index];
            List users = data['users'];
            String otherUserUid =
                users.firstWhere((uid) => uid != widget.currentUserUid);

            var userData = allUsers[otherUserUid];
            String username = userData?['username'] ?? 'Utilisateur';
            String lastMessage = data['lastMessage'] ?? 'Pas de message';

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  username,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Text(
                  lastMessage,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  formatTimestamp(data['lastMessageTime']),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[500],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Discussion(
                        mail: userData?['email'] ?? '',
                        uid: otherUserUid,
                        username: username,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}


