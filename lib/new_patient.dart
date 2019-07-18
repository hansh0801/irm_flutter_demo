import 'package:flutter/material.dart';
import 'irm_auth.dart';



class New_Patient extends StatefulWidget {
  @override
  _New_PatientState createState() => _New_PatientState();
}

class _New_PatientState extends State<New_Patient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("New_Patient"),),
      body: Center(
        child: Text("New_Patient "),
      ),

    );
  }
}
