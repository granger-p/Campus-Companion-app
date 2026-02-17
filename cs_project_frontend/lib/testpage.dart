import 'package:cs_project_frontend/Admin%20Part/AdminDashboard.dart';
import 'package:cs_project_frontend/Faculty%20Part/FacultyDashboard.dart';
import 'package:cs_project_frontend/Student%20Part/StudentDashboard.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget{
  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('TestPage',style: TextStyle(color: Colors.yellowAccent,fontSize: 35,fontWeight: FontWeight.w800),),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey,
        padding: EdgeInsets.all(140),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
            }
            , child: Text('Admin',style: TextStyle(fontSize: 30,color: Colors.black87),)),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>FacultyDashboard()));
            }
            , child: Text('Faculty',style: TextStyle(fontSize: 30,color: Colors.black87),)),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDashboard()));
            }
            , child: Text('Student',style: TextStyle(fontSize: 30,color: Colors.black87),)),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDashboard()));
            }
                , child: Text('Batch stats',style: TextStyle(fontSize: 30,color: Colors.black87),)),
          ],
        ),
      ),
    );
  }
}