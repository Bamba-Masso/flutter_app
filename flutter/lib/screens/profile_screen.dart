import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  late User _user;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser!;
    try {
      final doc = await _firestore.collection('users').doc(_user.uid).get();
      final data = doc.data();
      setState(() {
        username = data?['username'] ?? _user.displayName ?? '';
        email = data?['email'] ?? _user.email ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _editField(String fieldName, String currentValue) async {
    final controller = TextEditingController(text: currentValue);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Modifier $fieldName", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: fieldName),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final newValue = controller.text.trim();
                  if (newValue.isNotEmpty) {
                    setState(() => _isLoading = true);
                    if (fieldName == "Username") {
                      await _user.updateDisplayName(newValue);
                      await _firestore.collection('users').doc(_user.uid).update({'username': newValue});
                      username = newValue;
                    } else if (fieldName == "Email") {
                      await _user.updateEmail(newValue);
                      await _firestore.collection('users').doc(_user.uid).update({'email': newValue});
                      email = newValue;
                    }
                  }
                  Navigator.pop(context);
                  setState(() => _isLoading = false);
                },
                child: const Text("Enregistrer"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: const Color(0xFF1AB3A6),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFE5F7F7),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/img2.png'),
          ),
          const SizedBox(height: 10),
          Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(email, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ProfileItem(label: "Username", value: username, onTap: () => _editField("Username", username)),
                _ProfileItem(label: "Email", value: email, onTap: () => _editField("Email", email)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pop(); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB3A6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Se déconnecter", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Text("$label :", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(child: Text(value)),
              const Icon(Icons.edit, size: 18, color: Colors.grey),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}