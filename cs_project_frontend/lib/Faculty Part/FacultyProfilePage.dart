import 'package:flutter/material.dart';

class FacultyProfilePage extends StatelessWidget {
  // final Map<String, dynamic> facultyData;

  // const FacultyProfilePage({super.key, required this.facultyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Faculty Profile")),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   facultyData['name'] ?? 'Unknown Faculty',
                //   style: const TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blueAccent,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   "Teaches: ${facultyData['subject'] ?? 'N/A'}",
                //   style: const TextStyle(fontSize: 18),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}