

import 'package:cs_project_frontend/Admin%20Part/models/Student1.dart';
import 'package:cs_project_frontend/Student%20Part/FeeStatusPage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Student student;

  const ProfilePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${student.name}'s Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(student.image),
            ),
          ),
          const SizedBox(height: 20),
          _profileCard(student),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Action when Fees button is pressed
                _showFeesDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Fees",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard(Student student) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField(title: "Name", value: student.name),
            ProfileField(title: "Email", value: student.email),
            ProfileField(title: "Phone", value: student.phone),
            ProfileField(title: "Age", value: student.age),
            ProfileField(title: "Department", value: student.department),
            ProfileField(title: "Roll Number", value: student.rollNumber),

          ],
        ),
      ),
    );
  }

  void _showFeesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Fees Details"),
        content: Text("${student.name}'s fees details will be shown here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FeeStatusPage())),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String title;
  final String value;

  const ProfileField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$title: ",
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontSize: 14, color: Colors.white70))),
        ],
      ),
    );
  }
}