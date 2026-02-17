// lib/models/student.dart
class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String age;
  final String department;
  final String image;
  final String rollNumber;

  Student({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.department,
    required this.image,
    required this.rollNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) {
      if (v == null) return '';
      return v.toString();
    }

    return Student(
      id: parseString(json['_id'] ?? json['id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      phone: parseString(json['number'] ?? json['phone']),
      age: parseString(json['age']),
      department: parseString(json['department']),
      image: parseString(json['image']),
      rollNumber: parseString(json['rollNumber'] ?? json['roll'] ?? json['enrollmentId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'name': name,
      'email': email,
      'number': phone,
      'age': age,
      'department': department,
      'image': image,
      'rollNumber': rollNumber,
    };
  }
}