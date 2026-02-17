class Student {
  final String name;
  final String email;
  final String phone;
  final String age;
  final String department;
  final String image; // profile picture URL or asset
  final String rollNumber; // <-- new field

  Student({
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.department,
    required this.image,
    required this.rollNumber, // <-- add roll number
  });
}