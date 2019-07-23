import 'package:flutter/material.dart';
import 'patients_info.dart';




class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:new Text("patient detail"),)
    );
  }
}
