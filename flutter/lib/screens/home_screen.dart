import 'package:chat_app/screens/one_screen.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
       
          Container(
            color: Color(0xFFB2DFDB), 
          ),
         
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(100),
                ),
              ),
            ),
          ),
        
          Center(
            child: Image.asset(
              'assets/images/img3.png',
              width: 400,
              height: 400,
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OneScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal, 
                  backgroundColor: Colors.white, 
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                ),
                child: Text('Continuer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
