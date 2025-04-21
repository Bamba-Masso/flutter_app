import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/redirect.dart';
// import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/one_screen.dart';
import 'package:chat_app/screens/login_screen.dart';   
import 'package:chat_app/screens/chat_screen.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
       home: const RedirectionPage(),
      routes: {
        '/one': (context) => const OneScreen(),
        '/register': (context) =>  SignUpScreen(), 
        '/login': (context) =>  LoginScreen(),  
        '/chat': (context) => const ChatScreen(),     
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
