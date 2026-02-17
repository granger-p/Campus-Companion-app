import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'classes_page.dart';
import 'assignment_page.dart';
import 'notice_page.dart';
import 'profile_page.dart';
import 'call_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117), // Dark BG
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1F6FEB),   // Neon Blue
          secondary: Color(0xFF00C896), // Neon Teal
          tertiary: Color(0xFFF78166),  // Warning Orange
          surface: Color(0xFF161B22),   // Card BG
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white70,
        ),
        cardTheme: CardThemeData(
          color: Color(0xFF161B22),
          elevation: 6,
          shadowColor: Color(0xFF1F6FEB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF1F6FEB),
          selectedColor: const Color(0xFF00C896),
          labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      home: const StudentPage(),
    );
  }
}

class Student {
  final String name;
  final String image;

  Student({required this.name, required this.image});
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  final List<Student> students = [
    Student(name: "Duraisingam", image: "https://i.pravatar.cc/150?img=1"),
    Student(name: "Prabakaran", image: "https://i.pravatar.cc/150?img=2"),
    Student(name: "Bharanitharan", image: "https://i.pravatar.cc/150?img=3"),
    Student(name: "Dhinesh Pugal", image: "https://i.pravatar.cc/150?img=4"),
    Student(name: "Pasupathi", image: "https://i.pravatar.cc/150?img=5"),
    Student(name: "Ashok Raj", image: "https://i.pravatar.cc/150?img=6"),
  ];

  // Animation for dropdown
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  // Overlay handling
  final GlobalKey _createBtnKey = GlobalKey();
  OverlayEntry? _barrier;
  OverlayEntry? _menu;
  bool _menuHovered = false;
  bool _buttonHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _removeMenu(immediate: true);
    _controller.dispose();
    super.dispose();
  }

  Offset _buttonGlobalOffset() {
    final renderBox =
    _createBtnKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _buttonSize() {
    final renderBox =
    _createBtnKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void _showMenu() {
    if (_menu != null) return;

    final overlay = Overlay.of(context);
    final btnOffset = _buttonGlobalOffset();
    final btnSize = _buttonSize();

    _barrier = OverlayEntry(
      builder: (_) =>
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideMenu,
            ),
          ),
    );

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
                            iconColor: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            onTap: () {
                              _hideMenu();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AssignmentPage(),
                                ),
                              );
                            },
                          ),
                          _divider(),
                          _menuItem(
                            text: "Create Notice",
                            icon: Icons.notifications_active,
                            iconColor: Theme
                                .of(context)
                                .colorScheme
                                .tertiary,
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

    overlay.insertAll([_barrier!, _menu!]);
    _controller.forward(from: 0);
  }

  void _hideMenu() {
    if (_menu == null) return;
    _controller.reverse().then((_) => _removeMenu());
  }

  void _removeMenu({bool immediate = false}) {
    if (_menu == null) return;
    _menu?.remove();
    _menu = null;
    _barrier?.remove();
    _barrier = null;
    if (immediate) _controller.value = 0;
  }

  void _scheduleHideIfNotHovered() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_menuHovered && !_buttonHovered) {
        _hideMenu();
      }
    });
  }

  Widget _divider() =>
      Container(
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

  void _deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  // ---- UI ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Chip(
                  avatar:
                  const Icon(Icons.people, color: Colors.white, size: 18),
                  label: const Text("Students: 6"),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  elevation: 4,
                  shadowColor:
                  Theme
                      .of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.7),
                ),
                const SizedBox(width: 10),
                Chip(
                  avatar:
                  const Icon(Icons.sort, color: Colors.white, size: 18),
                  label: const Text("Sort by Name"),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  elevation: 4,
                  shadowColor:
                  Theme
                      .of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.7),
                ),
              ],
            ),
          ),

          // Buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) {
                      _buttonHovered = true;
                      if (kIsWeb ||
                          {
                            TargetPlatform.windows,
                            TargetPlatform.linux,
                            TargetPlatform.macOS,
                          }.contains(defaultTargetPlatform)) {
                        _showMenu();
                      }
                    },
                    onExit: (_) {
                      _buttonHovered = false;
                      _scheduleHideIfNotHovered();
                    },
                    child: _animatedButton(
                      key: _createBtnKey,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
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
                Expanded(
                  child: _animatedButton(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    icon: Icons.group_add,
                    label: "Add Student",
                    onTap: () async {
                      final newStudent = await Navigator.push<Student>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassesPage(),
                        ),
                      );

                      if (newStudent != null) {
                        setState(() {
                          students.add(newStudent);
                        });
                      }
                    },

                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Student List
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return TweenAnimationBuilder(
                  tween: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ),
                  duration: Duration(milliseconds: 450 + index * 90),
                  curve: Curves.easeOut,
                  builder: (context, Offset offset, child) {
                    return Transform.translate(
                      offset: offset * 48,
                      child: Opacity(
                        opacity: 1 - offset.dx,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(student.image),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              crossAxisCount: 5,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _actionIcon(Icons.person, "Profile",
                                    Theme.of(context).colorScheme.primary,
                                    student: student),
                                _actionIcon(
                                  Icons.call,
                                  "Call",
                                  Theme.of(context).colorScheme.secondary,
                                  student: student,
                                ),

                                _actionIcon(
                                    Icons.article, "Report", Colors.blueAccent,
                                    studentName: student.name),
                                _actionIcon(Icons.edit, "Edit",
                                    Theme
                                        .of(context)
                                        .colorScheme
                                        .tertiary),
                                _actionIcon(
                                    Icons.delete, "Delete", Colors.redAccent,
                                    deleteIndex: index),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedButton({
    Key? key,
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return AnimatedScale(
      key: key,
      duration: const Duration(milliseconds: 120),
      scale: 1.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: color.withOpacity(0.6),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }


  Widget _actionIcon(IconData icon, String label, Color color,
      {String? studentName, int? deleteIndex, Student? student}) {
    return InkWell(
      onTap: () {
        if (label == "Report" && studentName != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportPage(studentName: studentName),
            ),
          );
        } else if (label == "Profile" && student != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(student: student),
            ),
          );
        } else if (label == "Call" && student != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallPage(student: student),
            ),
          );
        }
        else if (label == "Delete" && deleteIndex != null) {
          _deleteStudent(deleteIndex);
        } else if (label == "Profile" && student != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(student: student),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: color.withOpacity(0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

}
// ---------------- REPORT PAGE ----------------
class ReportPage extends StatelessWidget {
  final String studentName;

  const ReportPage({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grades = [
      {"subject": "Mathematics", "grade": "A"},
      {"subject": "Physics", "grade": "B+"},
      {"subject": "Chemistry", "grade": "A-"},
      {"subject": "English", "grade": "A"},
      {"subject": "Computer Science", "grade": "A+"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("$studentName - Report"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(
              color: Colors.blueAccent,
              width: 1.2,
            ),
            columns: const [
              DataColumn(
                label: Text("Subject",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              DataColumn(
                label: Text("Grade",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
            rows: grades
                .map(
                  (grade) => DataRow(
                cells: [
                  DataCell(Text(grade["subject"])),
                  DataCell(Text(grade["grade"])),
                ],
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
