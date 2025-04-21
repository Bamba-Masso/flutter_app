import 'package:flutter/material.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/services/firebase/auth.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RedirectionPageState();
  }
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }else if (snapshot.hasData){
          return const  ChatScreen();
        }else{
          return  LoginScreen();
        }
      },
    );
  }
}
