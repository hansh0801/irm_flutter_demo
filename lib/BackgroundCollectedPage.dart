import 'package:flutter/material.dart';
import './BackgroundCollectingTask.dart';

class BackgroundCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data')),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        if (index < patientData.length) {
          return ListTile(title: Text(patientData[index].toString()));
        } else {
          return ListTile();
        }
      }),
    );
  }
}
