//import 'package:cs_project_frontend/admin/modelstd.dart';

import 'package:cs_project_frontend/Admin%20Part/models/Student1.dart';
import 'package:flutter/material.dart';
 // to access Student model

class CallPage extends StatelessWidget {
  final Student student;

  const CallPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call ${student.name}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 30),

            // Call Info Placeholder
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.greenAccent),
                title: const Text("Phone Number"),
                subtitle: Text(
                  student.phone.isNotEmpty ? " +91 ${student.phone} ": "Not provided",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),


            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.amber),
                title: const Text("Last Call"),
                subtitle: const Text("No records yet"), // can be updated later
              ),
            ),

            const SizedBox(height: 30),

            // Call button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.call, size: 22),
              label: const Text("Start Call",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                // 🔗 Later connect actual phone call backend
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Calling ${student.name}..."),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}