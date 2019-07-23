import 'package:flutter/material.dart';
import 'patients_info.dart';
import 'get_patient_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'irm_auth.dart';
import 'patient_info_detail_modify.dart';


var imagedata;




class DetailPage extends StatefulWidget {
  final Patientlist patientinfo;

  DetailPage({Key key,this.patientinfo}):super
      (key:key);


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
                    false), // stateless와 다르게 statefuld에서 ,paraameter 받을 때 widget.param 이렇게 써야함.
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
            DataCell(Text("Birth")),
            DataCell(
                Text(widget.patientinfo.patient_birth_dttm != null
                    ? widget.patientinfo.patient_birth_dttm
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Phone")),
            DataCell(
                Text(widget.patientinfo.patient_phone != null
                    ? widget.patientinfo.patient_phone
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Address")),
            DataCell(
                Text(widget.patientinfo.patient_address != null
                    ? widget.patientinfo.patient_address
                    : "default"),
                showEditIcon: true),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Guardian")),
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
        title: new Text("Detailed info"),
          actions: <Widget>[
            new FlatButton(
                child: new Text(
                  "Edit Info",
                  style: new TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoModify()));

                })
          ]
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
                      child: SizedBox(
                        height: 180,
                        width: 180,
                        child: Center(child: SpinKitWave(
                          color: Colors.lightBlueAccent,
                          size: 50,

                        )),
                      )
                    ),
                  );
                } else {
                  return Container(
                    child: new Image.memory(imagedata,height: 180,width: 180,),
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
