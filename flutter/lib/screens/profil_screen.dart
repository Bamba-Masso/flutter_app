import 'package:flutter/material.dart';

class UserProfile {
  String username;
  String email;
  String phone;
  String country;

  UserProfile({
    required this.username,
    required this.email,
    required this.phone,
    required this.country,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile profile = UserProfile(
    username: "arielle20",
    email: "arielle@email.com",
    phone: "+22512345678",
    country: "Côte d'Ivoire",
  );

  void _editField(String field, String currentValue) async {
    TextEditingController controller = TextEditingController(text: currentValue);

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
              Text("Edit $field", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: field,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    switch (field) {
                      case "Username":
                        profile.username = controller.text;
                        break;
                      case "Email":
                        profile.email = controller.text;
                        break;
                      case "Phone":
                        profile.phone = controller.text;
                        break;
                      case "Country":
                        profile.country = controller.text;
                        break;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1AB3A6),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/pro.jpg'), 
          ),
          const SizedBox(height: 10),
          Text(
            profile.username,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            profile.email,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ProfileItem(label: "Username", value: profile.username, onTap: () => _editField("Username", profile.username)),
                ProfileItem(label: "Email", value: profile.email, onTap: () => _editField("Email", profile.email)),
                ProfileItem(label: "Phone", value: profile.phone, onTap: () => _editField("Phone", profile.phone)),
                ProfileItem(label: "Country", value: profile.country, onTap: () => _editField("Country", profile.country)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB3A6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Sign Out", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const ProfileItem({
    required this.label,
    required this.value,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
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
