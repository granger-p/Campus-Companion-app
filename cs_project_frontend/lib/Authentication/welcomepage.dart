import 'package:cs_project_frontend/Authentication/Pages/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget{
  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController  _controller;
  late Animation<Offset>  _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,);
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0,0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward(); // Start slide animation
    });
    _controller.addStatusListener((status){
      if (status == AnimationStatus.completed){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginPage()));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/welcome screen.png',fit: BoxFit.cover,),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Padding(padding: EdgeInsets.only(top: 10),
                child: Text('Welcome',style: TextStyle(
                  fontSize: 70,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),),
                ),
              ),
            )
          ],
        ),
        /*child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/welcome screen.png'),fit: BoxFit.cover)
          ),
          child: Center(
            child: Text('Welcome',style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),),
          ),
        ),*/
      ),
    );
  }
}

