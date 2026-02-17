import 'package:cs_project_frontend/Authentication/Pages/studentdetail.dart';
import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:cs_project_frontend/testpage.dart';
import 'package:flutter/material.dart';
import 'package:cs_project_frontend/Authentication/Pages/register.dart';
import 'package:cs_project_frontend/Authentication/Pages/ResetPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey    = GlobalKey<FormState>();
  final _email      = TextEditingController();
  final _password   = TextEditingController();

  bool   _isLoading = false;
  String? _errorMsg;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMsg  = null;
    });

    final email    = _email.text.trim();
    final password = _password.text;

    try {
      final success = await ApiService.login(context,email, password);

      if (!success){
        setState(() {
          _errorMsg = 'Invalid email or Password';
        });
      }
    } catch (_) {
      setState(() {
        _errorMsg = 'Network error – please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Title
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 275),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Form
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.45,
                    right: 35,
                    left: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email field
                        TextFormField(
                          controller: _email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white30,
                            hintText: 'Email',
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
                              borderSide: BorderSide(
                                color: Colors.white24,
                                width: 3.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter your email';
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value))
                              return 'Enter a valid email';
                            return null;
                          },
                        ),
                        SizedBox(height: 50),

                        // Password field
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white30,
                            hintText: 'Password',
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
                              borderSide: BorderSide(
                                color: Colors.white24,
                                width: 3.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter your password';
                            return null;
                          },
                        ),
                        SizedBox(height: 50),

                        // Sign In button + loading spinner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white38,
                              child: _isLoading
                                  ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CircularProgressIndicator(
                                  color: Colors.black87,
                                  strokeWidth: 3,
                                ),
                              )
                                  : IconButton(
                                onPressed: _submit,
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Error message
                        if (_errorMsg != null) ...[
                          SizedBox(height: 16),
                          Text(
                            _errorMsg!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                        ],
                        SizedBox(height: 40),

                        // Links: Register & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                );
                              },
                              child: Text(
                                'Register Here',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()),
                                );
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
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