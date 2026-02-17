import 'package:flutter/material.dart';
import 'dart:math'; // Imported for the summary card calculation.

// The main function is the entry point of the app.
// The improved, more attractive result status page.
class ResultStatusPage extends StatelessWidget {
  const ResultStatusPage({super.key});

  // Data remains the same.
  final List<Map<String, String>> _results = const [
    {
      'subject': 'Physics',
      'marks': '85',
      'status': 'Pass',
    },
    {
      'subject': 'Chemistry',
      'marks': '62',
      'status': 'Pass',
    },
    {
      'subject': 'Math',
      'marks': '45',
      'status': 'Fail',
    },
    {
      'subject': 'Computer Science',
      'marks': '90',
      'status': 'Pass',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the number of passed subjects for the summary card.
    final passedCount = _results.where((r) => r['status'] == 'Pass').length;
    final totalSubjects = _results.length;
    final overallPass = passedCount >= (totalSubjects / 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Status'),
      ),
      // Use a Column to stack the summary card and the list.
      body: Column(
        children: [
          // New: A summary card at the top.
          ResultSummaryCard(
            passedCount: passedCount,
            totalCount: totalSubjects,
            isOverallPass: overallPass,
          ),
          // Use Expanded to make the ListView fill the remaining space.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                // New: Using a custom, more attractive card widget.
                return ResultItemCard(
                  subject: item['subject']!,
                  marks: int.parse(item['marks']!),
                  status: item['status']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A new widget for the overall performance summary card.
class ResultSummaryCard extends StatelessWidget {
  final int passedCount;
  final int totalCount;
  final bool isOverallPass;

  const ResultSummaryCard({
    super.key,
    required this.passedCount,
    required this.totalCount,
    required this.isOverallPass,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isOverallPass ? theme.colorScheme.secondary : theme.colorScheme.tertiary;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              isOverallPass ? Icons.school_rounded : Icons.warning_amber_rounded,
              color: statusColor,
              size: 40,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Performance',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You have passed $passedCount out of $totalCount subjects.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A new widget representing a single, styled result item.
class ResultItemCard extends StatelessWidget {
  final String subject;
  final int marks;
  final String status;

  const ResultItemCard({
    super.key,
    required this.subject,
    required this.marks,
    required this.status,
  });

  // Helper function to get color based on status.
  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return status == 'Pass' ? theme.secondary : theme.tertiary;
  }

  // Helper function to get a color for the progress bar based on marks.
  Color _getProgressBarColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (marks >= 75) return theme.secondary; // Green for high marks
    if (marks >= 50) return theme.primary; // Blue for medium marks
    return theme.tertiary; // Orange/Red for low marks
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Subject and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                // New: A "badge" for the status.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row for Marks and Progress Bar
            Row(
              children: [
                Text(
                  'Marks: $marks',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(width: 10),
                // New: A LinearProgressIndicator to visualize the score.
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: marks / 100.0,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(_getProgressBarColor(context)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}