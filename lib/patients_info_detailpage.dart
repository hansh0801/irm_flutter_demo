import 'package:flutter/material.dart';
import 'get_patient_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'irm_auth.dart';
import 'patient_info_detail_modify.dart';
import 'dart:typed_data';

// ignore_for_file: non_constant_identifier_names

class DetailPage extends StatefulWidget {
  final Patientlist patientinfo;
  final groupName;
  DetailPage({Key key, this.patientinfo, this.groupName}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var imagedata;

  Future getimage() async {
    imagedata = await getPatientPhoto(widget.patientinfo.patient_key);
    print(imagedata);
    return imagedata;
  }

  Widget PatientData() => DataTable(
        columns: <DataColumn>[
          DataColumn(
              label: Text(" Property"),
              numeric: false,
              onSort: (i, b) {},
              tooltip: "irm company jowa"),
          DataColumn(
              label: Text("Patient Data"),
              numeric: false,
              onSort: (i, b) {},
              tooltip: "Patient data")
        ],
        rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(Text("Group")),
            DataCell(
              Text(widget.groupName != null ? widget.groupName : ""),
              showEditIcon: false,
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Name")),
            DataCell(
              Text(widget.patientinfo.patient_name != null
                  ? widget.patientinfo.patient_name
                  : ""),
              showEditIcon: false,
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Sex")),
            DataCell(
              Text(widget.patientinfo.patient_sex != null
                  ? widget.patientinfo.patient_sex
                  : ""),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Birth")),
            DataCell(
              Text(widget.patientinfo.patient_birth_dttm != null
                  ? widget.patientinfo.patient_birth_dttm
                  : ""),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Phone")),
            DataCell(
              Text(widget.patientinfo.patient_phone != null
                  ? widget.patientinfo.patient_phone
                  : ""),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Address")),
            DataCell(
              Text(widget.patientinfo.patient_address != null
                  ? widget.patientinfo.patient_address
                  : ""),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Guardian")),
            DataCell(
              Text(widget.patientinfo.patient_guardian != null
                  ? widget.patientinfo.patient_guardian
                  : ""),
            ),
          ]),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Detailed info"), actions: <Widget>[
        new FlatButton(
            child: new Text(
              "Edit Info",
              style: new TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InfoModify(
                            patientinfo: widget.patientinfo,
                            imageData: imagedata,
                          )));
            })
      ]),
      body: SingleChildScrollView(
        child: Container(
            child: Center(
          child: new Column(
            children: <Widget>[
              SizedBox(height: 60, ),
              FutureBuilder(
                future: getimage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //print(snapshot.data);
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                          child: SizedBox(
                        height: 180,
                        width: 180,
                        child: Center(
                            child: SpinKitWave(
                          color: Colors.lightBlueAccent,
                          size: 50,
                        )),
                      )),
                    );
                  } else {
                    return Container(
                      child: snapshot.data.toString() !=
                              Uint8List.fromList('null'.codeUnits).toString()
                          ? new Image.memory(
                              imagedata,
                              height: 180,
                              //width: 180,
                            )
                          : Image.asset(
                              "images/gray.png",
                              height: 150,
                            ),
                    );
                  }
                },
              ),
              SizedBox(height: 40, ),
              SizedBox(
                width: 400,
                height: 400,
                child: PatientData(),
              )
            ],
          ),
        )),
      ),
    );
  }
}



