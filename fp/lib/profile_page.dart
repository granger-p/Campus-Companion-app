import 'package:flutter/material.dart';
import 'main.dart'; // so we can use Student model

class ProfilePage extends StatelessWidget {
  final Student student;

  const ProfilePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${student.name} - Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(student.image),
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProfileField(title: "Email", value: "student@email.com"),
                    ProfileField(title: "Phone", value: "+91 9876543210"),
                    ProfileField(title: "Age", value: "20"),
                    ProfileField(title: "Department", value: "Computer Science"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Load more details (Backend integration ready)
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Connect backend API call here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fetching more details from backend..."),
                  ),
                );
              },
              icon: const Icon(Icons.cloud),
              label: const Text("Load More Details"),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable ProfileField widget
class ProfileField extends StatelessWidget {
  final String title;
  final String value;

  const ProfileField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
