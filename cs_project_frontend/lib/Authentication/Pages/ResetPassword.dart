import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:cs_project_frontend/Authentication/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget{
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  final _secretkey = TextEditingController();

  final _email = TextEditingController();

  final _newpassword = TextEditingController();

  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose(){
    _email.dispose();
    _newpassword.dispose();
    _secretkey.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    if(!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    final email = _email.text.trim();
    final newpassword = _newpassword.text.trim();
    final secretkey = _secretkey.text.trim();

    try{
      final sucess = await ApiService.forgotpassword(email, newpassword, secretkey);

      if (sucess){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
      }
      else{
        setState(() {
          _errorMsg = 'Invalid Details';
        });
      }
    }
    catch(_){
      setState(() {
        _errorMsg = 'Network error = please try again';
      });
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }


  /*
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Collect data
      final data = {
        'name' : _secretkey.text,
        'email': _email.text,
        'new password': _newpassword.text,
      };
      debugPrint('Form data: $data');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
  }
   */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/login.png'),fit: BoxFit.cover)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 275),
                child: Text('Reset Password',style: TextStyle(fontSize: 41,color: Colors.white,fontWeight: FontWeight.w500),),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.43,
                    right: 35,
                    left: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                              borderSide: BorderSide(color: Colors.white24, width: 3.0),
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
                          height: 35,
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
                              borderSide: BorderSide(color: Colors.white24, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value){
                            if (value == null || value.isEmpty) return 'Please enter your name';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        TextFormField(
                          controller: _newpassword,
                          obscureText: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            hintText: 'New Password',
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
                              borderSide: BorderSide(color: Colors.white24, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue, width: 3.0),
                            ),
                          ),
                          validator: (value){
                            if (value == null || value.isEmpty) return 'Please enter your Password';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Reset Password',
                              style: TextStyle(color: Colors.white38,fontSize: 27,fontWeight: FontWeight.w800),),
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
                          height: 20,
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
                                fontWeight: FontWeight.w800,
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