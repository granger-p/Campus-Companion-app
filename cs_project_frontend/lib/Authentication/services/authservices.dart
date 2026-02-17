import 'dart:convert';
import 'package:cs_project_frontend/Admin%20Part/AdminDashboard.dart';
import 'package:cs_project_frontend/Authentication/Pages/studentdetail.dart';
import 'package:cs_project_frontend/Faculty%20Part/FacultyDashboard.dart';
import 'package:cs_project_frontend/Student%20Part/StudentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'http://10.0.2.2:3000/api/v1/auth';
  static const _redirectUrl = 'http://10.0.2.2:3000/api/v1/redirect';
  static const _profileUrl = 'http://10.0.2.2:3000/api/v1/profile/student';
  static String? authToken;
  static String? userId;
  static int? userRole;

  //New login method
  static Future<bool> login(BuildContext context, String email, String password) async{
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password':password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authToken = data['token'];
      userId = data['user']['_id'];
      userRole = data['user']['role'];

      return await _handleRedirect(context);
    }

    return false;
  }

  static Future<bool> _handleRedirect(BuildContext context) async {
    if (authToken == null) return false;

    final uri = Uri.parse(_redirectUrl);
    final response = await http.get(
      uri,
      headers: {'Authorization': authToken!},
    );

    final data = jsonDecode(response.body);

    if (data.containsKey('redirect')) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentDetail()));
    } else if (data.containsKey('path')) {
      final path = data['path'].toString().toLowerCase().trim();
      if (path.contains('student')) {
        print('Navigating to student Dashboard');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentDashboard()));
      } else if (path.contains('faculty')) {
        print('Navigating to faculty Dashboard');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FacultyDashboard()));
      } else if (path.contains('admin')) {
        print('Navigating to admin Dashboard');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown role or redirect path')),
      );
      return false;
    }

    return true;
  }


// Existing login method
  /*
  static Future<bool> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      authToken = jsonDecode(response.body)['token'] as String?;
      return authToken != null;
    }
    return false;
  }*/


  /// New register method
  static Future<bool> register(
      String name, String email, String password, int number, String secretkey) async {
    final uri = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'number': number,
        'secretkey': secretkey
      }),
    );
    if (response.statusCode == 201) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final wasOk = map['success'] == true;
      debugPrint('REGISTER success flag: $wasOk');
      return wasOk;
    }
    return false;
  }

  static Future<bool> createfaculty(
      String department, List<String> courseTeaching) async {
    final uri = Uri.parse('$_baseUrl/createfaculty');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'department': department,
        'course': courseTeaching

      }),
    );
    if (response.statusCode == 201) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final wasOk = map['success'] == true;
      debugPrint('REGISTER success flag: $wasOk');
      return wasOk;
    }
    return false;
  }
  static Future<bool> submitStudentProfile({
    required int enrollmentId, // Number
    required String course,
    required DateTime DOB,     // Date
    required String Gender,
    required int Year,         // Number
    required String Nationality,
    required String Religion,
    required String State,
  }) async {
final uri = Uri.parse(_profileUrl);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken!,
      },
      body: jsonEncode({
        'enrollmentId': enrollmentId,
        "course": course,
        "DOB": DOB.toIso8601String(), // Converts DateTime to ISO string
        "Gender": Gender,
        "Year": Year,
        "Nationality": Nationality,
        "Religion": Religion,
        "State": State,
      }),
    );

if (response.statusCode == 201) {
  final map = jsonDecode(response.body) as Map<String, dynamic>;
  final wasOk = map['success'] == true;
  debugPrint('REGISTER success flag: $wasOk');
  return wasOk;
}
    return false;
  }


    static Future<bool> forgotpassword(String email, String newpassword, String secretkey) async {
    final uri = Uri.parse('$_baseUrl/forgot-password');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
      'email': email,
      'newpassword': newpassword,
      'secretkey':secretkey
      }),)
    .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final wasOk = data['success'] == true;
      debugPrint('FORGOT PASSWORD success flag: $wasOk');
      return wasOk;
    }
    return false;
  }

}

