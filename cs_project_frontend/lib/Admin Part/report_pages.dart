import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model class
class SemesterReport {
  final String semester;
  final String attendance;
  final String assignments;
  final String performance;

  SemesterReport({
    required this.semester,
    required this.attendance,
    required this.assignments,
    required this.performance,
  });

  // Factory method for JSON
  factory SemesterReport.fromJson(Map<String, dynamic> json) {
    return SemesterReport(
      semester: json['semester'],
      attendance: json['attendance'],
      assignments: json['assignments'],
      performance: json['performance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "semester": semester,
      "attendance": attendance,
      "assignments": assignments,
      "performance": performance,
    };
  }
}

class ReportPage extends StatefulWidget {
  final String studentName;
  final bool isAdmin;

  const ReportPage({
    super.key,
    required this.studentName,
    this.isAdmin = false,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<SemesterReport>> _futureReports;

  @override
  void initState() {
    super.initState();
    _futureReports = fetchReportData();
  }

  // Replace with your API endpoint
  final String apiBaseUrl = "http://your-backend.com/api";

  // Fetch reports from API
  Future<List<SemesterReport>> fetchReportData() async {
    final response = await http.get(Uri.parse("$apiBaseUrl/reports/${widget.studentName}"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SemesterReport.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load report");
    }
  }

  // Update report via API
  Future<void> _updateReport(SemesterReport report) async {
    final response = await http.put(
      Uri.parse("$apiBaseUrl/reports/${widget.studentName}/${report.semester}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(report.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {
        _futureReports = fetchReportData(); // reload reports
      });
    } else {
      throw Exception("Failed to update report");
    }
  }

  void _showEditDialog(SemesterReport report) {
    final attendanceController = TextEditingController(text: report.attendance);
    final assignmentsController = TextEditingController(text: report.assignments);
    final performanceController = TextEditingController(text: report.performance);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit ${report.semester}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: attendanceController, decoration: const InputDecoration(labelText: "Attendance")),
            TextField(controller: assignmentsController, decoration: const InputDecoration(labelText: "Assignments")),
            TextField(controller: performanceController, decoration: const InputDecoration(labelText: "Performance")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedReport = SemesterReport(
                semester: report.semester,
                attendance: attendanceController.text,
                assignments: assignmentsController.text,
                performance: performanceController.text,
              );
              _updateReport(updatedReport);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.studentName}'s Report"),
      ),
      body: FutureBuilder<List<SemesterReport>>(
        future: _futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reports available"));
          }

          final reports = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  title: Text(
                    report.semester,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  children: [
                    ListTile(title: Text("📊 Attendance: ${report.attendance}")),
                    ListTile(title: Text("📝 Assignments: ${report.assignments}")),
                    ListTile(title: Text("⭐ Performance: ${report.performance}")),
                    if (widget.isAdmin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _showEditDialog(report),
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}