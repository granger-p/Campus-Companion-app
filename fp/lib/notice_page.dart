import 'package:flutter/material.dart';
import '/std/notice_data.dart'; // <-- shared global list

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  // Pick date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Submit notice
  void _submitNotice() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text.trim();
      String description = _descriptionController.text.trim();
      String? dateString = _selectedDate != null
          ? _selectedDate!.toLocal().toIso8601String().split('T')[0]
          : "No Date";

      // 🔹 Add to global list
      setState(() {
        notices.insert(0, {
          "title": title,
          "description": description,
          "date": dateString,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notice added!")),
      );

      // Clear fields
      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Notice"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Notice Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Notice Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Enter title" : null,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Notice Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
                  ),
                  const SizedBox(height: 20),

                  // Date Picker
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "No Date Selected"
                              : "Date: ${_selectedDate!.toLocal().toIso8601String().split('T')[0]}",
                          style: TextStyle(fontSize: 16, color: onSurfaceColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text("Pick Date"),
                        onPressed: () => _pickDate(context),
                      ),
                      if (_selectedDate != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Clear date',
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                          icon: Icon(Icons.clear, color: onSurfaceColor),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "Submit Notice",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _submitNotice,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Recent Announcements
            const Text(
              "Recent Announcements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            if (notices.isEmpty)
              const Text("No announcements yet."),
            for (var notice in notices)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(notice["title"] ?? ""),
                  subtitle: Text(notice["description"] ?? ""),
                  trailing: Text(notice["date"] ?? ""),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
