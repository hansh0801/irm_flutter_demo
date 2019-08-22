import 'package:flutter/material.dart';
import 'BackgroundCollectingTask.dart';
import 'package:json_table/json_table.dart';

class BackgroundCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (patientData != null) {
      //데이터를 받았으면 표 형식으로 출력
      return Scaffold(
          appBar: AppBar(title: Text('Data')),
          body: JsonTable(
            patientData,
            tableHeaderBuilder: (String header) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5), color: Colors.grey[300]),
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display1.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      color: Colors.black87),
                ),
              );
            },
            tableCellBuilder: (value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5))),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontSize: 14.0, color: Colors.grey[900]),
                ),
              );
            },
          ));
    } else {
      //데이터가 없으면 빈 화면 출력
      return Scaffold(
        appBar: AppBar(
          title: Text('Data'),
        ),
        body: Container(),
      );
    }
  }
}
