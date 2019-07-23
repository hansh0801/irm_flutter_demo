import 'package:flutter/material.dart';

class InfoModify extends StatefulWidget {
  @override
  _InfoModifyState createState() => _InfoModifyState();
}

class _InfoModifyState extends State<InfoModify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("modify"),),
      body: new Container(
        child: Center(child: new Text("modify")),
      ),
    );
  }
}
