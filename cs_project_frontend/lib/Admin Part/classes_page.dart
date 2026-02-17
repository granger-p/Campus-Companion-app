import 'package:cs_project_frontend/Admin%20Part/AdminDashboard.dart';
import 'package:cs_project_frontend/Admin%20Part/models/Student1.dart';

import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatefulWidget {
  final Student? student; // null → add, not null → edit

  const ClassesPage({super.key, this.student});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  // final _formKey = GlobalKey<FormState>();
  //
  // late TextEditingController nameCtrl;
  // late TextEditingController emailCtrl;
  // late TextEditingController phoneCtrl;
  // // late TextEditingController ageCtrl;
  // // late TextEditingController deptCtrl;
  // // late TextEditingController imageCtrl;
  // // late TextEditingController rollCtrl; // <-- new controller
  //
  // @override
  // void initState() {
  //   super.initState();
  //   nameCtrl = TextEditingController(text: widget.student?.name ?? "");
  //   emailCtrl = TextEditingController(text: widget.student?.email ?? "");
  //   phoneCtrl = TextEditingController(text: widget.student?.phone ?? "");
  //   // ageCtrl = TextEditingController(text: widget.student?.age ?? "");
  //   // deptCtrl = TextEditingController(text: widget.student?.department ?? "");
  //   // imageCtrl = TextEditingController(
  //   //     text: widget.student?.image ?? ""); // optional image
  //   // rollCtrl = TextEditingController(text: widget.student?.rollNumber ?? ""); // <-- init roll
  // }
  //
  // @override
  // void dispose() {
  //   nameCtrl.dispose();
  //   emailCtrl.dispose();
  //   phoneCtrl.dispose();
  //   // ageCtrl.dispose();
  //   // deptCtrl.dispose();
  //   // imageCtrl.dispose();
  //   // rollCtrl.dispose(); // <-- dispose roll
  //   super.dispose();
  // }
  //
  // void _saveStudent() {
  //   if (_formKey.currentState!.validate()) {
  //     final student = Student(
  //       name: nameCtrl.text,
  //       email: emailCtrl.text,
  //       phone: phoneCtrl.text,
  //       // age: ageCtrl.text,
  //       // department: deptCtrl.text,
  //       // image: imageCtrl.text.isEmpty
  //       //     ? "https://ui-avatars.com/api/?name=${nameCtrl.text}"
  //       //     : imageCtrl.text,
  //       // rollNumber: rollCtrl.text, // <-- save roll number
  //     );
  //     Navigator.pop(context, student);
  //   }
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() {
  //     _isLoading = true;
  //     _errorMsg  = null;
  //   });
  // }
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _number = TextEditingController();
  final _password = TextEditingController();
  final _secretkey = TextEditingController();

  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose(){
    _email.dispose();
    _name.dispose();
    _number.dispose();
    _password.dispose();
    _secretkey.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg  = null;
    });
    final email = _email.text.trim();
    final password = _password.text;
    final name = _name.text.trim();
    final secretkey = _secretkey.text;
    final numInt = int.parse(_number.text.trim());

    try{
      final success = await ApiService.register(name, email, password, numInt,secretkey);

      if (success) {
        print('done');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
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
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Student" : "Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TextFormField(
              //   controller: rollCtrl, // <-- roll field
              //   decoration: const InputDecoration(labelText: "Roll Number"),
              //   validator: (v) => v!.isEmpty ? "Enter roll number" : null,
              // ),
              TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (v) => v!.isEmpty ? "Enter name" : null),
              TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Email")),
              TextFormField(
                  controller: _number,
                  decoration: const InputDecoration(labelText: "Phone")),
              TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: "Password")),
              TextFormField(
                  controller: _secretkey,
                  decoration: const InputDecoration(labelText: "SecretKey")),
              // TextFormField(
              //     controller: imageCtrl,
              //     decoration: const InputDecoration(labelText: "Image URL")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? "Update Student" : "Add Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}