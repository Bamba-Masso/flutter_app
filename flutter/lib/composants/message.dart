import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.userMail, required this.userUid, required this.userUsername});
  final String userMail;
  final String userUid;
  final String userUsername;
 

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightGreen,
        ),
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(userUsername),
      subtitle: Text(userMail),
    );
  }
}
