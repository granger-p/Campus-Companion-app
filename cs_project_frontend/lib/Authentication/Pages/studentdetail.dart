/*import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/register.png'),fit: BoxFit.cover)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 50),
                child: Text('Student Form',style: TextStyle(fontSize: 50,color: Colors.white54 ,fontWeight: FontWeight.w500),),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.16,
                    right: 35,
                    left: 35,
                  ),
                  child: Column(
                    children: [

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:cs_project_frontend/Student%20Part/StudentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentDetail extends StatefulWidget {
  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _idController = TextEditingController();
  final _dobController        = TextEditingController();
  final _yearController       = TextEditingController();
  final _nationalityController = TextEditingController();
  final _religionController   = TextEditingController();
  final _stateController      = TextEditingController();

  // Dropdown state
  String? _selectedGender;
  String? _selectedCourse;
  DateTime? _selectedDOB;


  final _genderOptions = ['Male', 'Female', 'Other'];
  final _courseOptions = [
    'Computer Science',
    'Mechanical',
    'Civil',
    'Electrical',
    'Other'
  ];

  @override
  void dispose() {
    _idController.dispose();
    _dobController.dispose();
    _yearController.dispose();
    _nationalityController.dispose();
    _religionController.dispose();
    _stateController.dispose();
    super.dispose();
  }
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final hundredYearsAgo = DateTime(now.year - 100, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: hundredYearsAgo,
      lastDate: now,
    );

    if (picked != null) {
      // Format as dd-MM-yyyy with leading zeros
      _selectedDOB = picked;
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      _dobController.text = '$day-$month-$year';
    }
  }

  bool _isLoading = false;
  String? _errorMsg;

  Future<void> _submit() async{
    if(!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
  final enrollmentId= int.parse(_idController.text.trim());
  final DOB = _selectedDOB!;
  final Gender = _selectedGender!;
  final course = _selectedCourse!;
  final Year = int.parse(_yearController.text.trim());
  final Nationality = _nationalityController.text;
  final Religion = _religionController.text;
  final State = _stateController.text;

  try{
 final success = await ApiService.submitStudentProfile(
   enrollmentId: enrollmentId,
   course: course!,
   DOB: DOB,
   Gender: Gender!,
   Year: Year,
   Nationality: Nationality,
   Religion: Religion,
   State: State,
 );

 if(success){
   print('done');
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentDashboard()));
 }
 else{
   setState(() {
     _errorMsg = 'Invalid details';
   });
 }
  }
  catch(_){
   setState(() {
     _errorMsg = 'Network error - please try again';
   });
  }
  finally{
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
                  'Student Form',
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
                    top: MediaQuery.of(context).size.height * 0.22,
                    right: 35,
                    left: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _idController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Enrollment ID',
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
                        // Date of Birth
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            hintText: 'Date of Birth',
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
                            suffixIcon: const Icon(Icons.calendar_today,color: Colors.white70,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white30, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          onTap: _pickDate,
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required field' : null,
                        ),

                        const SizedBox(height: 16),

                        // Gender
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white30,
                            hint: Text('Gender', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 18,
                            ),),
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
                          items: _genderOptions
                              .map((g) =>
                              DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedGender = v),
                          validator: (v) =>
                          v == null ? 'Please select gender' : null,
                        ),

                        const SizedBox(height: 16),

                        // Course
                        DropdownButtonFormField<String>(
                          value: _selectedCourse,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hint: Text('Course', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 18,
                            ),),
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
                          items: _courseOptions
                              .map((c) =>
                              DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCourse = v),
                          validator: (v) =>
                          v == null ? 'Please select course' : null,
                        ),

                        const SizedBox(height: 16),

                        // Year
                        TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Year',
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

                        // Nationality
                        TextFormField(
                          controller: _nationalityController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Nationality',
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
                          controller: _religionController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'Religion',
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

                        // State
                        TextFormField(
                          controller: _stateController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white24,
                            hintText: 'State',
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