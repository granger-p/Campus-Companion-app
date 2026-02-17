// import 'package:cs_project_frontend/Admin%20Part/models/student.dart';
// import 'package:cs_project_frontend/Authentication/services/studentservices.dart';
// import 'package:cs_project_frontend/Faculty%20Part/Facultyformpage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'classes_page.dart';
// import 'assignment_page.dart';
// import 'notice_page.dart';
// import 'profile_page.dart';
// import 'call_page.dart';
// import 'report_pages.dart';
// import 'package:cs_project_frontend/Authentication/services/studentservices.dart'; // Path to your ApiServices
// import 'package:cs_project_frontend/Admin Part/models/Student1.dart'; // Path to your Student model
//
//
// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});
//
//   @override
//   State<AdminDashboard> createState() => _AdminPageState();
// }
//
// class _AdminPageState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
//   final List<Student> students = [];
//   // String searchQuery = "";
//   late Future<List<Student>> _studentsFuture;
//   String searchQuery = "";
//
//   late final AnimationController _controller;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   // Create Dropdown
//   final GlobalKey _createBtnKey = GlobalKey();
//   OverlayEntry? _menu;
//   bool _menuHovered = false;
//   bool _buttonHovered = false;
//
//   // Faculty Dropdown
//   final GlobalKey _facultyBtnKey = GlobalKey();
//   OverlayEntry? _facultyMenu;
//   bool _facultyBtnHovered = false;
//   bool _facultyMenuHovered = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _studentsFuture = ApiServices.getAllStudents();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       reverseDuration: const Duration(milliseconds: 150),
//     );
//     _slide = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//   }
//
//   @override
//   void dispose() {
//     _hideMenu();
//     _hideFacultyMenu();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Offset _buttonGlobalOffsetFor(GlobalKey key) {
//     final renderBox = key.currentContext!.findRenderObject() as RenderBox;
//     return renderBox.localToGlobal(Offset.zero);
//   }
//
//   Size _buttonSizeFor(GlobalKey key) {
//     final renderBox = key.currentContext!.findRenderObject() as RenderBox;
//     return renderBox.size;
//   }
//
//   // ================= CREATE Dropdown =================
//   void _showMenu() {
//     if (_menu != null) return;
//
//     final overlay = Overlay.of(context);
//     final btnOffset = _buttonGlobalOffsetFor(_createBtnKey);
//     final btnSize = _buttonSizeFor(_createBtnKey);
//
//     _menu = OverlayEntry(
//       builder: (ctx) {
//         return Positioned(
//           left: btnOffset.dx,
//           top: btnOffset.dy + btnSize.height + 6,
//           child: Material(
//             color: Colors.transparent,
//             child: MouseRegion(
//               onEnter: (_) => _menuHovered = true,
//               onExit: (_) {
//                 _menuHovered = false;
//                 _scheduleHideIfNotHovered();
//               },
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF161B22),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.tealAccent.withOpacity(0.3),
//                           blurRadius: 12,
//                           spreadRadius: 1,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 6),
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(minWidth: 220),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _menuItem(
//                             text: "Create Assignment",
//                             icon: Icons.assignment_add,
//                             iconColor: Theme.of(context).colorScheme.primary,
//                             onTap: () {
//                               _hideMenu();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const AssignmentPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                           _divider(),
//                           _menuItem(
//                             text: "Create Notice",
//                             icon: Icons.notifications_active,
//                             iconColor: Theme.of(context).colorScheme.tertiary,
//                             onTap: () {
//                               _hideMenu();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const NoticePage(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//
//     overlay.insert(_menu!);
//     _controller.forward(from: 0);
//   }
//
//   void _hideMenu() {
//     if (_menu != null) {
//       _menu?.remove();
//       _menu = null;
//       _controller.value = 0;
//     }
//   }
//
//   void _scheduleHideIfNotHovered() {
//     Future.delayed(const Duration(milliseconds: 120), () {
//       if (!_menuHovered && !_buttonHovered) {
//         _hideMenu();
//       }
//     });
//   }
//
//   // ================= FACULTY Dropdown =================
//   void _showFacultyMenu() {
//     if (_facultyMenu != null) return;
//
//     final overlay = Overlay.of(context);
//     final btnOffset = _buttonGlobalOffsetFor(_facultyBtnKey);
//     final btnSize = _buttonSizeFor(_facultyBtnKey);
//
//     _facultyMenu = OverlayEntry(
//       builder: (_) {
//         return Positioned(
//           left: btnOffset.dx,
//           top: btnOffset.dy + btnSize.height + 6,
//           child: Material(
//             color: Colors.transparent,
//             child: MouseRegion(
//               onEnter: (_) => _facultyMenuHovered = true,
//               onExit: (_) {
//                 _facultyMenuHovered = false;
//                 _scheduleFacultyHide();
//               },
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF161B22),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.tealAccent.withOpacity(0.3),
//                           blurRadius: 12,
//                           spreadRadius: 1,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 6),
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(minWidth: 220),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _menuItem(
//                             text: "Add Faculty",
//                             icon: Icons.person_add,
//                             iconColor: Theme.of(context).colorScheme.primary,
//                             onTap: () {
//                                _hideFacultyMenu();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Add Faculty")),
//                               );
//                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>Facultyformpage()));
//                             },
//                           ),
//                           _divider(),
//                           _menuItem(
//                             text: "Update Faculty",
//                             icon: Icons.edit,
//                             iconColor: Theme.of(context).colorScheme.secondary,
//                             onTap: () {
//                               _hideFacultyMenu();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Update Faculty")),
//                               );
//                             },
//                           ),
//                           _divider(),
//                           _menuItem(
//                             text: "Faculty Profile",
//                             icon: Icons.person,
//                             iconColor: Theme.of(context).colorScheme.tertiary,
//                             onTap: () {
//                               _hideFacultyMenu();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Faculty Profile")),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//
//     overlay.insert(_facultyMenu!);
//     _controller.forward(from: 0);
//   }
//
//   void _hideFacultyMenu() {
//     if (_facultyMenu != null) {
//       _facultyMenu?.remove();
//       _facultyMenu = null;
//     }
//   }
//
//   void _scheduleFacultyHide() {
//     Future.delayed(const Duration(milliseconds: 150), () {
//       if (!_facultyBtnHovered && !_facultyMenuHovered) {
//         _hideFacultyMenu();
//       }
//     });
//   }
//
//   Widget _divider() => Container(
//     height: 1,
//     margin: const EdgeInsets.symmetric(vertical: 2),
//     color: Colors.white24,
//   );
//
//   Widget _menuItem({
//     required String text,
//     required IconData icon,
//     required Color iconColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18, color: iconColor),
//             const SizedBox(width: 10),
//             Text(text,
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // void _deleteStudent(int index) {
//   //   setState(() {
//   //     students.removeAt(index);
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // final filteredStudents = students
//     //     .where((s) => s.name.toLowerCase().contains(searchQuery.toLowerCase()))
//     //     .toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Admin",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               final result = await showSearch<Student?>(
//                 context: context,
//                 delegate: StudentSearchDelegate([]),
//               );
//
//               if (result != null) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfilePage(student: result),
//                   ),
//                 );
//               }
//             },
//             icon: const Icon(Icons.search),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Buttons row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: Row(
//               children: [
//                 // Create Button
//                 Expanded(
//                   child: MouseRegion(
//                     onEnter: (_) {
//                       _buttonHovered = true;
//                       _showMenu();
//                     },
//                     onExit: (_) {
//                       _buttonHovered = false;
//                       _scheduleHideIfNotHovered();
//                     },
//                     child: _animatedButton(
//                       key: _createBtnKey,
//                       color: Theme.of(context).colorScheme.secondary,
//                       icon: Icons.add,
//                       label: "Create",
//                       onTap: () {
//                         if (_menu == null) {
//                           _showMenu();
//                         } else {
//                           _hideMenu();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Add Student
//                 Expanded(
//                   child: _animatedButton(
//                     color: Theme.of(context).colorScheme.primary,
//                     icon: Icons.group_add,
//                     label: "Add Student",
//                     onTap: () async {
//                       final newStudent = await Navigator.push<Student>(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ClassesPage(),
//                         ),
//                       );
//
//                       if (newStudent != null) {
//                         setState(() {
//                           _studentsFuture = ApiServices.getAllStudents();
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Faculty Button
//                 Expanded(
//                   child: MouseRegion(
//                     onEnter: (_) {
//                       _facultyBtnHovered = true;
//                       _showFacultyMenu();
//                     },
//                     onExit: (_) {
//                       _facultyBtnHovered = false;
//                       _scheduleFacultyHide();
//                     },
//                     child: _animatedButton(
//                       key: _facultyBtnKey,
//                       color: Theme.of(context).colorScheme.tertiary,
//                       icon: Icons.school,
//                       label: "Faculty",
//                       onTap: () {
//                         if (_facultyMenu == null) {
//                           _showFacultyMenu();
//                         } else {
//                           _hideFacultyMenu();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 6),
//
//           // Student List
//           // Expanded(
//           //   child: ListView.builder(
//           //     itemCount: filteredStudents.length,
//           //     itemBuilder: (context, index) {
//           //       final student = filteredStudents[index];
//           //       return Padding(
//           //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           //         child: Card(
//           //           child: Padding(
//           //             padding: const EdgeInsets.all(14.0),
//           //             child: Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   student.name,
//           //                   style: const TextStyle(
//           //                     fontWeight: FontWeight.bold,
//           //                     fontSize: 16,
//           //                     color: Colors.white,
//           //                   ),
//           //                 ),
//           //                 const SizedBox(height: 12),
//           //                 Row(
//           //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //                   children: [
//           //                     _actionIcon("Profile", student),
//           //                     _actionIcon("Call", student),
//           //                     _actionIcon("Report", student),
//           //                     _actionIcon("Edit", student, index: index),
//           //                     _actionIcon("Delete", student, index: index),
//           //                   ],
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //       );
//           //     },
//           //   ),
//           // ),
//           // REPLACE THE EXISTING Expanded WIDGET WITH THIS CODE
//           Expanded(
//             child: FutureBuilder<List<Student>>(
//               future: _studentsFuture,
//               builder: (context, snapshot) {
//                 // 1. Loading State
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 // 2. Error State
//                 if (snapshot.hasError) {
//                   // You can show a more descriptive error message
//                   return Center(child: Text("Error fetching data: ${snapshot.error}"));
//                 }
//
//                 // 3. No Data State
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No students found."));
//                 }
//
//                 // 4. Success State (Data is available)
//                 final students = snapshot.data!;
//                 final filteredStudents = students
//                     .where((s) => s.name.toLowerCase().contains(searchQuery.toLowerCase()))
//                     .toList();
//
//                 // Pass the fetched student list to the search delegate
//                 // This makes the search icon work correctly
//                 // Note: This part is a bit tricky to update directly inside build.
//                 // For now, the previous fix of passing an empty list will prevent errors.
//                 // A more robust solution involves a state management package.
//
//                 return ListView.builder(
//                   itemCount: filteredStudents.length,
//                   itemBuilder: (context, index) {
//                     final student = filteredStudents[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       child: Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(14.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 student.name,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   _actionIcon("Profile", student),
//                                   _actionIcon("Call", student),
//                                   _actionIcon("Report", student),
//                                   _actionIcon("Edit", student, index: index),
//                                   _actionIcon("Delete", student, index: index),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _animatedButton({
//     Key? key,
//     required Color color,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return AnimatedScale(
//       key: key,
//       duration: const Duration(milliseconds: 120),
//       scale: 1.0,
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 6,
//           shadowColor: color.withOpacity(0.6),
//         ),
//         onPressed: onTap,
//         icon: Icon(icon, color: Colors.white),
//         label: Text(label,
//             style: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
//
//   Widget _actionIcon(String action, Student student, {int? index}) {
//     IconData iconData;
//
//     switch (action) {
//       case "Profile":
//         iconData = Icons.person;
//         break;
//       case "Call":
//         iconData = Icons.call;
//         break;
//       case "Report":
//         iconData = Icons.receipt_long;
//         break;
//       case "Edit":
//         iconData = Icons.edit;
//         break;
//       case "Delete":
//         iconData = Icons.delete;
//         break;
//       default:
//         iconData = Icons.help_outline;
//     }
//
//     return InkWell(
//       onTap: () async {
//         if (action == "Report") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ReportPage(
//                 studentName: student.name,
//                 isAdmin: true,
//               ),
//             ),
//           );
//         } else if (action == "Profile") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProfilePage(student: student),
//             ),
//           );
//         } else if (action == "Call") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CallPage(student: student),
//             ),
//           );
//         } else if (action == "Edit" && index != null) {
//           final updatedStudent = await Navigator.push<Student>(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ClassesPage(student: student),
//             ),
//           );
//           if (updatedStudent != null) {
//             setState(() {
//               students[index] = updatedStudent;
//             });
//           }
//         } else if (action == "Delete" && index != null) {
//           _deleteStudent(index);
//         }
//       },
//       borderRadius: BorderRadius.circular(12),
//       splashColor: Colors.blue.withOpacity(0.25),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.blue.withOpacity(0.15),
//             child: Icon(iconData, color: Colors.white, size: 20),
//           ),
//           const SizedBox(height: 5),
//           Text(action,
//               style: const TextStyle(fontSize: 11, color: Colors.white70)),
//         ],
//       ),
//     );
//   }
// }
//
// class StudentSearchDelegate extends SearchDelegate<Student?> {
//   final List<Student> students;
//
//   StudentSearchDelegate(this.students);
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     final results = students
//         .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//
//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final student = results[index];
//         return ListTile(
//           title: Text(student.name),
//           subtitle: Text(student.email),
//           onTap: () => close(context, student),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = students
//         .where((s) => s.name.toLowerCase().startsWith(query.toLowerCase()))
//         .toList();
//
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final student = suggestions[index];
//         return ListTile(
//           title: Text(student.name),
//           onTap: () {
//             query = student.name;
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }

import 'package:cs_project_frontend/Admin%20Part/models/Student1.dart';
import 'package:cs_project_frontend/Authentication/services/studentservices.dart';
import 'package:flutter/material.dart';
import 'classes_page.dart';
import 'assignment_page.dart';
import 'notice_page.dart';
import 'profile_page.dart';
import 'call_page.dart';
import 'report_pages.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  // This list will hold the fetched student data to be passed to the search delegate.
  List<Student> _students = [];

  // This Future will drive the FutureBuilder to display the student list.
  late Future<List<Student>> _studentsFuture;

  // Controller and animations for dropdown menus.
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  // Global keys for positioning the dropdown menus.
  final GlobalKey _createBtnKey = GlobalKey();
  final GlobalKey _facultyBtnKey = GlobalKey();

  // State for dropdown menus.
  OverlayEntry? _menu;
  bool _menuHovered = false;
  bool _buttonHovered = false;

  OverlayEntry? _facultyMenu;
  bool _facultyBtnHovered = false;
  bool _facultyMenuHovered = false;

  @override
  void initState() {
    super.initState();
    // Initial fetch of student data.
    _studentsFuture = _fetchStudents();

    // Initialize animations.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  // A helper method to fetch students and update the local list.
  Future<List<Student>> _fetchStudents() async {
    final students = await ApiServices.getAllStudents();
    if (mounted) {
      setState(() {
        _students = students;
      });
    }
    return students;
  }

  // A method to refresh the student list from the API.
  void _refreshStudentList() {
    setState(() {
      _studentsFuture = _fetchStudents();
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _hideFacultyMenu();
    _controller.dispose();
    super.dispose();
  }

  Offset _buttonGlobalOffsetFor(GlobalKey key) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _buttonSizeFor(GlobalKey key) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  // ================= CREATE Dropdown =================
  void _showMenu() {
    if (_menu != null) return;

    final overlay = Overlay.of(context);
    final btnOffset = _buttonGlobalOffsetFor(_createBtnKey);
    final btnSize = _buttonSizeFor(_createBtnKey);

    _menu = OverlayEntry(
      builder: (ctx) {
        return Positioned(
          left: btnOffset.dx,
          top: btnOffset.dy + btnSize.height + 6,
          child: Material(
            color: Colors.transparent,
            child: MouseRegion(
              onEnter: (_) => _menuHovered = true,
              onExit: (_) {
                _menuHovered = false;
                _scheduleHideIfNotHovered();
              },
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _menuItem(
                            text: "Create Assignment",
                            icon: Icons.assignment_add,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              _hideMenu();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssignmentPage(),
                                ),
                              );
                            },
                          ),
                          _divider(),
                          _menuItem(
                            text: "Create Notice",
                            icon: Icons.notifications_active,
                            iconColor: Theme.of(context).colorScheme.tertiary,
                            onTap: () {
                              _hideMenu();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NoticePage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_menu!);
    _controller.forward(from: 0);
  }

  void _hideMenu() {
    if (_menu != null) {
      _menu?.remove();
      _menu = null;
      _controller.value = 0;
    }
  }

  void _scheduleHideIfNotHovered() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_menuHovered && !_buttonHovered) {
        _hideMenu();
      }
    });
  }

  // ================= FACULTY Dropdown =================
  void _showFacultyMenu() {
    if (_facultyMenu != null) return;

    final overlay = Overlay.of(context);
    final btnOffset = _buttonGlobalOffsetFor(_facultyBtnKey);
    final btnSize = _buttonSizeFor(_facultyBtnKey);

    _facultyMenu = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: btnOffset.dx,
          top: btnOffset.dy + btnSize.height + 6,
          child: Material(
            color: Colors.transparent,
            child: MouseRegion(
              onEnter: (_) => _facultyMenuHovered = true,
              onExit: (_) {
                _facultyMenuHovered = false;
                _scheduleFacultyHide();
              },
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _menuItem(
                            text: "Add Faculty",
                            icon: Icons.person_add,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              _hideFacultyMenu();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Add Faculty Tapped")),
                              );
                            },
                          ),
                          _divider(),
                          _menuItem(
                            text: "Update Faculty",
                            icon: Icons.edit,
                            iconColor: Theme.of(context).colorScheme.secondary,
                            onTap: () {
                              _hideFacultyMenu();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Update Faculty Tapped")),
                              );
                            },
                          ),
                          _divider(),
                          _menuItem(
                            text: "Faculty Profile",
                            icon: Icons.person,
                            iconColor: Theme.of(context).colorScheme.tertiary,
                            onTap: () {
                              _hideFacultyMenu();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Faculty Profile Tapped")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_facultyMenu!);
    _controller.forward(from: 0);
  }

  void _hideFacultyMenu() {
    if (_facultyMenu != null) {
      _facultyMenu?.remove();
      _facultyMenu = null;
    }
  }

  void _scheduleFacultyHide() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!_facultyBtnHovered && !_facultyMenuHovered) {
        _hideFacultyMenu();
      }
    });
  }

  Widget _divider() => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 2),
    color: Colors.white24,
  );

  Widget _menuItem({
    required String text,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 10),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Search Icon
          IconButton(
            onPressed: () async {
              // Pass the locally stored student list to the search delegate.
              final result = await showSearch<Student?>(
                context: context,
                delegate: StudentSearchDelegate(_students),
              );

              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(student: result),
                  ),
                );
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                // Create Button
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) {
                      _buttonHovered = true;
                      _showMenu();
                    },
                    onExit: (_) {
                      _buttonHovered = false;
                      _scheduleHideIfNotHovered();
                    },
                    child: _animatedButton(
                      key: _createBtnKey,
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icons.add,
                      label: "Create",
                      onTap: () {
                        if (_menu == null) {
                          _showMenu();
                        } else {
                          _hideMenu();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Add Student Button
                Expanded(
                  child: _animatedButton(
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.group_add,
                    label: "Add Student",
                    onTap: () async {
                      final newStudent = await Navigator.push<Student>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassesPage(),
                        ),
                      );

                      // If a student was added, refresh the list.
                      if (newStudent != null) {
                        _refreshStudentList();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Faculty Button
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) {
                      _facultyBtnHovered = true;
                      _showFacultyMenu();
                    },
                    onExit: (_) {
                      _facultyBtnHovered = false;
                      _scheduleFacultyHide();
                    },
                    child: _animatedButton(
                      key: _facultyBtnKey,
                      color: Theme.of(context).colorScheme.tertiary,
                      icon: Icons.school,
                      label: "Faculty",
                      onTap: () {
                        if (_facultyMenu == null) {
                          _showFacultyMenu();
                        } else {
                          _hideFacultyMenu();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Student List using FutureBuilder
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. No Data State
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No students found."));
                }

                // 4. Success State (Data is available)
                final students = snapshot.data!;
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  _actionIcon("Profile", student),
                                  _actionIcon("Call", student),
                                  _actionIcon("Report", student),
                                  _actionIcon("Edit", student, index: index),
                                  _actionIcon("Delete", student), // Pass student, not index
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for action icons below student name
  Widget _actionIcon(String action, Student student, {int? index}) {
    IconData icon;
    switch (action) {
      case "Profile":
        icon = Icons.person;
        break;
      case "Call":
        icon = Icons.call;
        break;
      case "Report":
        icon = Icons.report;
        break;
      case "Edit":
        icon = Icons.edit;
        break;
      case "Delete":
        icon = Icons.delete;
        break;
      default:
        icon = Icons.error;
    }

    return InkWell(
      onTap: () async {
        if (action == "Profile") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(student: student)));
        } else if (action == "Call") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CallPage(student: student)));
        } else if (action == "Report") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReportPage(studentName: student.name)));
        } else if (action == "Edit" && index != null) {
          final updatedStudent = await Navigator.push<Student>(
            context,
            MaterialPageRoute(
              builder: (context) => ClassesPage(student: student),
            ),
          );
          if (updatedStudent != null) {
            _refreshStudentList();
          }
        } else if (action == "Delete") {
          // Show confirmation dialog before deleting
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Deletion"),
                content:
                Text("Are you sure you want to delete ${student.name}?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close dialog
                      // Call delete API
                      await ApiServices.deleteStudent(student.id);
                      // Refresh the list
                      _refreshStudentList();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(height: 4),
          Text(action,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget for the main animated buttons (Create, Add Student, etc.)
  Widget _animatedButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Key? key,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// =======================================================================
// CLASS DEFINITION FOR THE SEARCH DELEGATE
// =======================================================================

class StudentSearchDelegate extends SearchDelegate<Student?> {
  final List<Student> students;

  StudentSearchDelegate(this.students);

  // Clears the search query
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  // Builds the leading icon (a back button)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search view, return null
      },
    );
  }

  // Builds the search results based on the query
  @override
  Widget buildResults(BuildContext context) {
    final results = students
        .where((student) =>
        student.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final student = results[index];
        return ListTile(
          title: Text(student.name),
          subtitle: Text('ID: ${student.id}'),
          onTap: () {
            close(context, student); // Close search and return selected student
          },
        );
      },
    );
  }

  // Builds suggestions as the user types
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = students
        .where((student) =>
        student.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final student = suggestions[index];
        return ListTile(
          title: Text(student.name),
          onTap: () {
            query = student.name;
            showResults(context); // Show results for the tapped suggestion
          },
        );
      },
    );
  }
}
