/*
import 'package:flutter/material.dart';

class FacultyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        title: Text(
          'Faculty Dashboard',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Faculty Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
*/

import 'package:cs_project_frontend/Faculty%20Part/FacultyComplainPage.dart';
import 'package:cs_project_frontend/Faculty%20Part/FacultyProfilePage.dart';
import 'package:flutter/material.dart';

class FacultyDashboard extends StatelessWidget {
  // final Map<String, dynamic> facultyData;

  // const FacultyDashboard({super.key, required this.facultyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Faculty Info
            // Card(
            //   elevation: 5,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12)),
            //   child: ListTile(
            //     leading: const CircleAvatar(
            //       radius: 28,
            //       backgroundColor: Colors.blue,
            //       child: Icon(Icons.person, size: 32, color: Colors.white),
            //     ),
            //     title: Text(
            //       "Name : XYZ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //     subtitle: Text('Subject: subject | department: department'),
            //     // title: Text(
            //     //   facultyData['name'] ?? 'Faculty Name',
            //     //   style: const TextStyle(
            //     //       fontSize: 20, fontWeight: FontWeight.bold),
            //     // ),
            //     // subtitle: Text(
            //     //   "${facultyData['subject'] ?? 'Subject'} | ${facultyData['department'] ?? 'Department'}",
            //     // ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacultyProfilePage()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  title: const Text(
                    "Name : XYZ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Subject: subject | department: department'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Timetable / Classes
            const Text(
              "Class Schedule",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text("Mon - 10:00 AM: Data Structures"),
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text("Wed - 2:00 PM: Algorithms"),
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text("Fri - 11:00 AM: Operating Systems"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Courses Assigned
            const Text(
              "Courses Assigned",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text("Data Structures (CSE201)"),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text("Algorithms (CSE301)"),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text("Operating Systems (CSE401)"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Complaint Section
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FacultyComplaintPage()));
                },
                icon: const Icon(Icons.report_problem),
                label: const Text("Raise a Complaint"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
