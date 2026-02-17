import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:cs_project_frontend/Student%20Part/StudentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Facultyformpage extends StatefulWidget {
  @override
  _FacultyformpageState createState() => _FacultyformpageState();
}

class _FacultyformpageState extends State<Facultyformpage > {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _departmentController = TextEditingController();
  final _courseController   = TextEditingController();


  @override
  void dispose() {
    _departmentController.dispose();
    _courseController.dispose();
    super.dispose();
  }


  bool _isLoading = false;
  String? _errorMsg;

  // Future<void> _submit() async{
  //   if(!_formKey.currentState!.validate()) return;
  //   setState(() {
  //     _isLoading = true;
  //     _errorMsg = null;
  //   });
  //
  //   final department = _departmentController.text;
  //   final Course = _courseController.text;
  //
  //
  //   try{
  //     final success = await ApiService.createfaculty(
  //       department: department,
  //       courseTeaching: Course,
  //     );
  //
  //     if(success){
  //       print('done');
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentDashboard()));
  //     }
  //     else{
  //       setState(() {
  //         _errorMsg = 'Invalid details';
  //       });
  //     }
  //   }
  //   catch(_){
  //     setState(() {
  //       _errorMsg = 'Network error - please try again';
  //     });
  //   }
  //   finally{
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final department = _departmentController.text.trim();
    final courseText = _courseController.text.trim();

    // Convert comma-separated courses into List<String>
    final courses = courseText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    try {
      // Call createfaculty with positional arguments
      final success = await ApiService.createfaculty(department, courses);

      if (success) {
        print('done');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDashboard()),
        );
      } else {
        setState(() {
          _errorMsg = 'Invalid details';
        });
      }
    } catch (_) {
      setState(() {
        _errorMsg = 'Network error - please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Header
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 50),
                child: const Text(
                  'Faculty Form',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Form
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.42,
                    right: 35,
                    left: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Department
                        TextFormField(
                          controller: _departmentController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Department',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white30, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required field' : null,
                        ),

                        const SizedBox(height: 16),

                        // Religion
                        TextFormField(
                          controller: _courseController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Courses (comma separated)',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white30, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required field' : null,
                        ),

                        const SizedBox(height: 24),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white38, // Replace with your desired color
                              foregroundColor: Colors.black87, // Text/icon color
                              elevation: 4, // Optional: tweak elevation
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25), // Optional: rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class FacultyFormPage extends StatefulWidget {
//   final Map<String, String>? facultyData;
//   final Function(Map<String, String>)? onSave;
//
//   const FacultyFormPage({super.key, this.facultyData, this.onSave});
//
//   @override
//   State<FacultyFormPage> createState() => _FacultyFormPageState();
// }
//
// class _FacultyFormPageState extends State<FacultyFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _idCtrl = TextEditingController();
//   final TextEditingController _deptCtrl = TextEditingController();
//   final TextEditingController _desigCtrl = TextEditingController();
//   final TextEditingController _dojCtrl = TextEditingController();
//   final TextEditingController _emailCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _officeCtrl = TextEditingController();
//   final TextEditingController _qualCtrl = TextEditingController();
//   final TextEditingController _expCtrl = TextEditingController();
//   final TextEditingController _passwordCtrl = TextEditingController();
//   final TextEditingController _subjectCtrl = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.facultyData != null) {
//       _nameCtrl.text = widget.facultyData!['name'] ?? '';
//       _idCtrl.text = widget.facultyData!['id'] ?? '';
//       _deptCtrl.text = widget.facultyData!['department'] ?? '';
//       _subjectCtrl.text = widget.facultyData!['subject'] ?? '';
//     }
//   }
//
//   void _saveFaculty() {
//     if (_formKey.currentState!.validate()) {
//       final updatedData = {
//         'name': _nameCtrl.text.trim(),
//         'subject': _subjectCtrl.text.trim(),
//         'department': _deptCtrl.text.trim(),
//         'id': _idCtrl.text.trim(),
//       };
//       if (widget.onSave != null) widget.onSave!(updatedData);
//
//       Navigator.pop(context);
//     }
//   }
//
//   Widget _buildField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscure = false,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscure,
//         validator: validator ??
//                 (value) => (value == null || value.trim().isEmpty)
//                 ? 'Enter $label'
//                 : null,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: const Color(0xFF161B22),
//           labelStyle: const TextStyle(color: Colors.white70),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.facultyData != null;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEdit ? "Edit Faculty" : "Add Faculty"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _buildField(controller: _nameCtrl, label: "Full Name"),
//               _buildField(controller: _idCtrl, label: "Faculty ID"),
//               _buildField(controller: _deptCtrl, label: "Department"),
//               _buildField(controller: _subjectCtrl, label: "Subject"),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveFaculty,
//                 child: Text(isEdit ? "Update Faculty" : "Save Faculty"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }