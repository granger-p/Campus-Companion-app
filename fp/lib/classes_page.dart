import 'package:flutter/material.dart';
import 'main.dart'; // Import Student model from main.dart

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Student Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Student Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Student Image URL (Optional)
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: "Image URL (Optional)",
                hintText: "https://example.com/image.jpg",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    final newStudent = Student(
                      name: _nameController.text,
                      image: _imageController.text.isNotEmpty
                          ? _imageController.text
                          : "https://via.placeholder.com/150", // 👈 default image
                    );
                    Navigator.pop(context, newStudent); // return student
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter student name"),
                      ),
                    );
                  }
                },
                child: const Text("Add Student"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
