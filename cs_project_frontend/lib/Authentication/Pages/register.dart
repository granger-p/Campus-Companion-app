import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:cs_project_frontend/Authentication/Pages/studentdetail.dart';
import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class RegisterPage extends StatefulWidget{
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
          MaterialPageRoute(builder: (context) => LoginPage()),
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

  /*void _submit() {
    if (_formKey.currentState!.validate()) {
      // Collect data
      final data = {
        'name' : _name.text,
        'email': _email.text,
        'number': _number.text,
        'password': _password.text,
        'secrekey':_secretkey.text,
      };
      debugPrint('Form data: $data');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentDetail()),
      );
    }
  }*/

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
                child: Text('Create Account',style: TextStyle(fontSize: 50,color: Colors.white54 ,fontWeight: FontWeight.w500),),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.41,
                    right: 35,
                    left: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            hintText: 'Name',
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
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
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
                              borderSide: BorderSide(color: Colors.white30, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your email';
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _number,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            hintText: 'Number',
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
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value == null || value.length != 10) return 'Enter a valid 10-digit number';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
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
                              borderSide: BorderSide(color: Colors.white30, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your Password';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _secretkey,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            hintText: 'SecretKey',
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
                          keyboardType: TextInputType.name,
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sign Up',
                              style: TextStyle(color: Colors.white54,fontSize: 27,fontWeight: FontWeight.w700),),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white30,
                              child: _isLoading
                                  ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CircularProgressIndicator(
                                  color: Colors.black87,
                                  strokeWidth: 3,
                                ),
                              )
                                  : IconButton(
                                onPressed: _isLoading ? null : _submit,
                                icon: Icon(Icons.arrow_forward, color: Colors.black87),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                            }, child: Text('Sign In',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.white54,
                                fontWeight: FontWeight.w800
                              ),)),
                          ],
                        ),
                        if(_errorMsg != null) ... [
                          SizedBox(height: 16,),
                          Text(
                            _errorMsg!,
                            style: TextStyle(color: Colors.redAccent,
                            fontSize: 16),
                          )
                        ],
                        SizedBox(height: 40,),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}