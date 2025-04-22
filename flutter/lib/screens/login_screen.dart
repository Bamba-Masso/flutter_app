import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/services/firebase/auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _forKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF009688),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenue Sur AppChat!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Connexion',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _forKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email is required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_forKey.currentState!.validate()) {
                            //login
                            try {
                              await Auth().loginWithEmaiAndPassword(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              Fluttertoast.showToast(
                                msg:
                                    "Votre adresse email ou votre mot de passe semblent être incorrects.",
                              );
                              print(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${e.message}"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const ChatScreen(),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Avez-vous déjà un compte ?",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                    const Divider(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final user = await Auth().signInWithGoogle();

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          } else {
                            print("Connexion échouée");
                          }
                        } catch (e) {
                          print("Erreur pendant la connexion Google : $e");
                        }
                      },
                      icon: Image.asset("assets/images/google.png", height: 30),
                      label: const Text("connecter vous avec google "),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTextField({required String label, bool isPassword = false}) {
  //   return TextField(
  //     obscureText: isPassword,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       filled: true,
  //       fillColor: Colors.white,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  //     ),
  //   );
  // }
}
