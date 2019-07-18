import 'package:flutter/material.dart';
import 'irm_auth.dart';


class Medical_Record extends StatefulWidget {
  @override
  _Medical_RecordState createState() => _Medical_RecordState();
}

class _Medical_RecordState extends State<Medical_Record> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Medical_Record"),),
      body: Center(
        child: Text("Medical_Record test"),
      ),

    );
  }
}
