import 'package:flutter/material.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers → ready for backend connection
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;

  // Pick a due date
  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  // Handle submit
  void _submitAssignment() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text.trim();
      String description = _descriptionController.text.trim();
      String? dueDateString = _dueDate != null
          ? _dueDate!.toLocal().toIso8601String().split('T')[0]
          : null;

      // 🔗 Backend payload (easy to send with http/dio later)
      final Map<String, dynamic> payload = {
        "title": title,
        "description": description,
        "due_date": dueDateString,
      };

      // For now we print — replace with API call
      print("Assignment payload => $payload");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assignment submitted successfully!")),
      );

      // Clear after submit
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _dueDate = null;
      });
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
        title: const Text("New Assignment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Assignment Title",
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
                    labelText: "Assignment Description",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter description"
                      : null,
                ),
                const SizedBox(height: 20),

                // Due Date Picker
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? "No Due Date Selected"
                            : "Due Date: ${_dueDate!.toLocal().toIso8601String().split('T')[0]}",
                        style: TextStyle(fontSize: 16, color: onSurfaceColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick Date"),
                      onPressed: () => _pickDueDate(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    if (_dueDate != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Clear date',
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                        icon: Icon(Icons.clear, color: onSurfaceColor),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      "Submit Assignment",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _submitAssignment,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}