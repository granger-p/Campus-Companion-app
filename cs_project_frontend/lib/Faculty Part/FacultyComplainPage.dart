import 'package:flutter/material.dart';

//==============================================================================
// FACULTY COMPLAINT PAGE (STATEFUL)
//==============================================================================

class FacultyComplaintPage extends StatefulWidget {
  const FacultyComplaintPage({super.key});

  @override
  State<FacultyComplaintPage> createState() => _FacultyComplaintPageState();
}

class _FacultyComplaintPageState extends State<FacultyComplaintPage> {
  late Future<List<Complaint>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    // initialize the future once
    _complaintsFuture = MockComplaintService.getComplaints();
  }

  // Reload complaints and refresh UI
  Future<void> _loadComplaints() async {
    setState(() {
      _complaintsFuture = MockComplaintService.getComplaints();
    });
    await _complaintsFuture;
  }

  // Show modal bottom sheet to update a complaint status
  void _showUpdateStatusModal(Complaint complaint) {
    ComplaintStatus selectedStatus = complaint.status;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctxInner, StateSetter setModalState) {
            final titleStyle = Theme.of(context).textTheme.titleLarge ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
            final subtitleStyle = Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.white70) ??
                const TextStyle(color: Colors.white70);

            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update Status", style: titleStyle),
                  const SizedBox(height: 8),
                  Text(complaint.title, style: subtitleStyle),
                  const Divider(height: 32),

                  // Radio buttons for each status
                  ...ComplaintStatus.values.map((status) {
                    return RadioListTile<ComplaintStatus>(
                      title: Text(_statusName(status)),
                      value: status,
                      groupValue: selectedStatus,
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => selectedStatus = value);
                        }
                      },
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save_alt_rounded),
                      label: const Text('Save Status'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        await MockComplaintService.updateComplaintStatus(
                            complaint.id, selectedStatus);
                        Navigator.pop(ctx); // close modal
                        await _loadComplaints(); // refresh list
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Complain Box'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _loadComplaints(),
            tooltip: 'Refresh Complaints',
          ),
        ],
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No complaints found."));
          }

          final complaints = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return FacultyComplaintCard(
                complaint: complaint,
                onTap: () => _showUpdateStatusModal(complaint),
              );
            },
          );
        },
      ),
    );
  }
}

//==============================================================================
// FACULTY COMPLAINT CARD
//==============================================================================

class FacultyComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback onTap;

  const FacultyComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  // Return status color and icon as a small data object
  StatusInfo _getStatusInfo(BuildContext context) {
    switch (complaint.status) {
      case ComplaintStatus.Pending:
        return StatusInfo(
            color: Theme.of(context).colorScheme.tertiary,
            icon: Icons.pending_actions_rounded);
      case ComplaintStatus.InProgress:
        return StatusInfo(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            icon: Icons.hourglass_top_rounded);
      case ComplaintStatus.Resolved:
        return StatusInfo(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icons.check_circle_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: statusInfo.color.withOpacity(0.15),
          child: Icon(statusInfo.icon, color: statusInfo.color, size: 22),
        ),
        title: Text(
          complaint.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${complaint.category} • ${formatDate(complaint.date)}',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
        ),
        trailing: Text(
          complaint.status.name,
          style: TextStyle(
              color: statusInfo.color, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        onTap: onTap,
      ),
    );
  }
}

// Simple structure to hold status color+icon
class StatusInfo {
  final Color color;
  final IconData icon;
  StatusInfo({required this.color, required this.icon});
}

//==============================================================================
// DATA MODELS AND MOCK SERVICE
//==============================================================================

String formatDate(DateTime date) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}

enum ComplaintStatus { Pending, InProgress, Resolved }

class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  ComplaintStatus status;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.status = ComplaintStatus.Pending,
  });
}

class MockComplaintService {
  static final List<Complaint> _complaints = [
    Complaint(
      id: 'C001',
      title: 'Wi-Fi not working in Block C Hostel',
      description: 'The Wi-Fi has been down for the past 3 days in the C-Block hostel...',
      category: 'Hostel',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: ComplaintStatus.Pending,
    ),
    Complaint(
      id: 'C002',
      title: 'Incorrect Marks for Mid-Term Exam',
      description: 'My mid-term marks for the CS101 course seem to be incorrect...',
      category: 'Academics',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: ComplaintStatus.InProgress,
    ),
    Complaint(
      id: 'C003',
      title: 'Library Book Not Available',
      description: 'The "Introduction to Algorithms" book is listed as available...',
      category: 'Library',
      date: DateTime.now().subtract(const Duration(days: 8)),
      status: ComplaintStatus.Resolved,
    ),
  ];

  static Future<List<Complaint>> getComplaints() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _complaints.sort((a, b) => b.date.compareTo(a.date));
    // return a copy to avoid external mutation surprises
    return List<Complaint>.from(_complaints);
  }

  static Future<void> updateComplaintStatus(
      String id, ComplaintStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final complaint = _complaints.firstWhere((c) => c.id == id);
    complaint.status = newStatus;
  }
}

// Helper to show readable enum names
String _statusName(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.Pending:
      return 'Pending';
    case ComplaintStatus.InProgress:
      return 'In Progress';
    case ComplaintStatus.Resolved:
      return 'Resolved';
  }
}