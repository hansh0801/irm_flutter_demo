import 'package:flutter/material.dart';
import 'patients_info.dart';
import 'get_patient_data.dart';

var imagedata;

class DetailPage extends StatefulWidget {
  final Patientlist patientinfo;

  DetailPage({Key key, this.patientinfo}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future getimage() async {
    imagedata = await getPatientPhoto(widget.patientinfo.patient_key);
    print(imagedata);
    return imagedata;
  }

/*
  void initState(){

    getimage();

    super.initState();
  }*/

  @override
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
            DataCell(Text("Name")),
            DataCell(
                Text(widget.patientinfo.patient_name != null
                    ? widget.patientinfo.patient_name
                    : "default"),
                showEditIcon:
                    true), // stateless와 다르게 statefuld에서 ,paraameter 받을 때 widget.param 이렇게 써야함.
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient sex")),
            DataCell(
                Text(widget.patientinfo.patient_sex != null
                    ? widget.patientinfo.patient_sex
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient id value")),
            DataCell(
                Text(widget.patientinfo.patient_id_value != null
                    ? widget.patientinfo.patient_id_value
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("group key")),
            DataCell(
                Text(widget.patientinfo.vgroup_key.toString() != null
                    ? widget.patientinfo.vgroup_key.toString()
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient birth")),
            DataCell(
                Text(widget.patientinfo.patient_birth_dttm != null
                    ? widget.patientinfo.patient_birth_dttm
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient phone")),
            DataCell(
                Text(widget.patientinfo.patient_phone != null
                    ? widget.patientinfo.patient_phone
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient address")),
            DataCell(
                Text(widget.patientinfo.patient_address != null
                    ? widget.patientinfo.patient_address
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient guardian")),
            DataCell(
                Text(widget.patientinfo.patient_guardian != null
                    ? widget.patientinfo.patient_guardian
                    : "default"),
                showEditIcon: true),
          ]),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("patient Detailed info"),
      ),
      body: Container(
          child: Center(
        child: new Column(
          children: <Widget>[
            FutureBuilder(
              future: getimage(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("loading images",),
                    ),
                  );
                } else {
                  return Container(
                    child: new Image.memory(imagedata,height: 200,width: 200,),
                  );
                }
              },
            ),
            PatientData(),
          ],
        ),
      )),
    );
  }
}
