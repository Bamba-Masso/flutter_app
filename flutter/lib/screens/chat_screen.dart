import 'package:chat_app/screens/discussion.dart';
import 'package:chat_app/screens/one_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/contact.dart';
import 'package:chat_app/screens/getDiscussion.dart';
import 'package:chat_app/composants/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  int pageIndex = 0;
  final User? user = Auth().currentUser;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final currentUser = FirebaseAuth.instance;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentUserUid = user!.uid;
    final userMail = user!.email ?? "";
    final userUsername = user!.displayName ?? "Utilisateur";

    final pages = [
      DiscussionPage(
        currentUserUid: currentUserUid,
        userMail: userMail,
        userUsername: userUsername,
      ),
      ContactPage(),
    ];
    return Scaffold(
      // body: pages[pageIndex],
      appBar: AppBar(
        title: Text(user?.displayName ?? ""),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),

      backgroundColor: const Color(0xFFE0F2F1),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.message), label: "Discussion"),
          NavigationDestination(
            icon: Icon(Icons.contact_emergency_outlined),
            label: "Contact",
          ),
        ],
      ),
    );
  }
}

extension on User? {
  get username => null;
}
