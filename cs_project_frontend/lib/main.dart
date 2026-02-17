import 'package:cs_project_frontend/homepage.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  final customColorScheme = const ColorScheme.dark(
    primary: Color(0xFF1F6FEB),
    secondary: Color(0xFF00C896),
    tertiary: Color(0xFFF78166),
    surface: Color(0xFF161B22),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white70,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Companion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: customColorScheme,
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
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1F6FEB),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
                inherit: true,
                fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
