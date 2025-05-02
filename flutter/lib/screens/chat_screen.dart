import 'package:chat_app/screens/discussion.dart';
import 'package:chat_app/screens/one_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/contact.dart';
import 'package:chat_app/screens/getDiscussion.dart';
import 'package:chat_app/composants/message.dart';
import 'package:chat_app/screens/profile_screen.dart';

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
      const ContactPage(),
    ];

    return Scaffold(
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
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F2F1),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFFE0F2F1),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Color.fromARGB(255, 40, 146, 141));
            }
            return const IconThemeData(color: Colors.grey);
          }),
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(color: Color.fromARGB(255, 47, 131, 127));
            }
            return const TextStyle(color: Colors.grey);
          }),
        ),
        child: NavigationBar(
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
      ),
    );
  }
}
