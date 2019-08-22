import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

List<String> patientDataList = [];
List<Map> patientData = [];
List<String> dataList = [];

Map splitData(stringData) {
  List<String> splitString = stringData.split('|');
  Map mapData = {
    'Device number': splitString[0],
    'Date': splitString[1],
    'User ID': splitString[2],
    'Patient ID': splitString[3],
    'Age': splitString[4],
    'Gender': splitString[5],
    'Test name': splitString[6],
    'Lot name': splitString[7],
    'Expire date': splitString[8],
    'Result 1': splitString[9],
    'Result 2': splitString[10],
    'Result 3': splitString[11],
    'Result 4': splitString[12],
    'Result 5': splitString[13],
    'Unit 1': splitString[14],
    'Unit 2': splitString[15],
    'Unit 3': splitString[16],
    'Unit 4': splitString[17],
    'Unit 5': splitString[18],
    'Result flag': splitString[19],
    'Test type': splitString[20],
    'Tip type': splitString[21],
    'Slot number': splitString[22],
    'Control name': splitString[23],
    'Control lot name': splitString[24],
    'Control Exp': splitString[25],
    'Control Flag': splitString[26],
    'Reserved 1': splitString[27],
    'Reserved 2': splitString[28],
    'Reserved 3': splitString[29],
    'Reserved 4': splitString[30],
    'Reserved 5': splitString[31],
  };

  print('mapData $mapData');

  return mapData;
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(BuildContext context,
          {bool rebuildOnChange = false}) =>
      ScopedModel.of<BackgroundCollectingTask>(context,
          rebuildOnChange: rebuildOnChange);

  final BluetoothConnection _connection;
  List<int> buffer = List<int>();

  bool inProgress;

  //데이터를 출력하기 쉽게 변환
  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input.listen((data) {
      buffer = data;

      String stringData = String.fromCharCodes(buffer);
      print(stringData);

      dataList = stringData.split('\$1|');

      /// $1|A6RLG100006|20150120100700|CHOI|JOHN|30|Male|PSA|PSLYC69|2017.06.26|12.45|||||ng/mL||||||G|G|0|||||||||

      patientData.add(splitData(dataList[1]));
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    buffer.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }
}
