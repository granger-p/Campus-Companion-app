import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // UNCOMMENT AFTER adding package to pubspec.yaml

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // UNCOMMENT IF you add Firebase initialization here
  runApp(const AcademiaFlowApp());
}

class AcademiaFlowApp extends StatelessWidget {
  const AcademiaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Dashboard',
      theme: tistheme,
      home: const StudentDashboard(),
    );
  }
}

// ---------------- THEME ----------------
final ThemeData tistheme = ThemeData(
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
  cardTheme: const CardThemeData(
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
);

// ---------------- DASHBOARD (CONVERTED TO STATEFULWIDGET) ----------------
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // 1. STATE VARIABLE to track the count
  int _notificationCount = 5; // Start with 5 for testing the badge appearance

  // Placeholder for Firebase/FCM Listener
  void _setupNotificationListener() {
    // 2. Start listening for incoming messages in the foreground
    // UNCOMMENT AND COMPLETE THIS SECTION AFTER adding FirebaseMessaging setup in main.dart
    /*
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in Dashboard: ${message.notification?.title}');
      // setState is crucial to update the badge count immediately
      setState(() {
        _notificationCount++;
      });
    });
    */
  }

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();

    // 3. TOKEN REGISTRATION PLACEHOLDER:
    // CALL YOUR FUNCTION HERE to get the FCM Token and send it to your backend API
    // for user registration.
    // Example: _registerUserForPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Portal"),
        // 4. Use the custom badge widget instead of the simple icon button
        actions: [
          _NotificationBadge(
            count: _notificationCount,
            onTap: () {
              // Action when the bell is tapped (e.g., navigate to a notification list)
              // And reset the count
              setState(() {
                _notificationCount = 0; // Reset the count when the user clicks the bell
              });
              // Navigate to the notifications page here:
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
          ),
        ],
      ),

      // ✅ ListView is the main scroll container
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // WELCOME CARD
          DashboardCard(
            title: "Welcome back, John! 👋",
            subtitle: "Here's what's happening in your academic life today",
            child: Column(
              children: const [
                InfoTile(label: "Enrolled Courses", value: "5"),
                InfoTile(label: "Pending Work", value: "5"),
                InfoTile(label: "Course Progress", value: "80%"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // QUICK ACTIONS
          DashboardCard(
            title: "Quick Actions",
            child: Column(
              children: const [
                QuickActionButton(icon: Icons.assignment, label: "View Assignments"),
                QuickActionButton(icon: Icons.schedule, label: "Check Schedule"),
                QuickActionButton(icon: Icons.grade, label: "View Grades"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // GRADES
          DashboardCard(
            title: "Recent Grades",
            child: Column(
              children: const [
                GradeTile(course: "CS101", grade: "A-", credits: "3"),
                GradeTile(course: "MATH201", grade: "B+", credits: "4"),
                GradeTile(course: "ENG102", grade: "A", credits: "3"),
                GradeTile(course: "PHYS151", grade: "B", credits: "4"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ANNOUNCEMENTS
          DashboardCard(
            title: "Recent Announcements",
            child: Column(
              children: [
                // for (var notice in notices)
                //   AnnouncementTile(
                //     title: notice["title"] ?? "",
                //     level: "normal", // or you can add "level" field in notice_data
                //     date: notice["date"] ?? "",
                //   ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------- REUSABLE WIDGETS ----------------

class DashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const DashboardCard({super.key, required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: const TextStyle(color: Colors.white70)),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: Text(value,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18)),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickActionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}

class GradeTile extends StatelessWidget {
  final String course;
  final String grade;
  final String credits;

  const GradeTile({super.key, required this.course, required this.grade, required this.credits});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(course, style: const TextStyle(color: Colors.white)),
      subtitle: Text("$credits credits"),
      trailing: Chip(
        label: Text(grade, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  final String title;
  final String level;
  final String date;

  const AnnouncementTile({super.key, required this.title, required this.level, required this.date});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    if (level == "urgent") {
      badgeColor = Theme.of(context).colorScheme.tertiary;
    } else if (level == "high") {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Theme.of(context).colorScheme.secondary;
    }

    return ListTile(
      dense: true,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(date, style: const TextStyle(color: Colors.white70)),
      trailing: Chip(
        label: Text(level.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12)),
        backgroundColor: badgeColor,
      ),
    );
  }
}

// ---------------- NOTIFICATION WIDGET (NEW) ----------------

class _NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NotificationBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        children: [
          const Icon(Icons.notifications),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary, // Warning color (Orange)
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  count > 99 ? '99+' : count.toString(), // Limit display to 99+
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}