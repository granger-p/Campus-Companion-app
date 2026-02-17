// lib/services/api_services.dart
import 'dart:convert';
import 'package:cs_project_frontend/Admin%20Part/models/Student1.dart';
import 'package:http/http.dart' as http;


class ApiServices {
  // Base root for dashboard routes; append paths below
  static const String _baseRoot = 'http://10.0.2.2:3000/api/v1';

  /// GET /students
  static Future<List<Student>> getAllStudents() async {
    final uri = Uri.parse('$_baseRoot/students');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List raw = (body is List) ? body : (body['data'] ?? body);
      return raw.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to load students: ${res.statusCode}');
  }

  static Future<bool> deleteStudent(String id) async {
    final uri = Uri.parse('$_baseRoot/student/$id');
    try {
      final res = await http.delete(uri, headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Student> updateStudent(String id, Map<String, dynamic> updates) async {
    final uri = Uri.parse('$_baseRoot/student/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updates),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      // backend responds: { message: 'Student updated successfully', student: { ...mapped... } }
      final studentJson = body['student'] as Map<String, dynamic>? ?? body;
      return Student.fromJson(studentJson);
    }

    // try to extract server message when available
    String msg = 'Failed to update student: ${res.statusCode}';
    try {
      final err = jsonDecode(res.body);
      if (err is Map && err['message'] != null) msg = err['message'];
    } catch (_) {}
    throw Exception(msg);
  }


}