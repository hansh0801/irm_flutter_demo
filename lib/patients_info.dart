import 'package:flutter/material.dart';
import 'irm_auth.dart';




class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("patient test"),),
      body: Center(
        child: Text("page moving test"),
      ),

    );
  }
}
