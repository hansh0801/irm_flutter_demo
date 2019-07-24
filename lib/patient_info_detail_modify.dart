import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'patients_info_detailpage.dart';
import 'get_patient_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
Patientlist return_patientinfo;
String name, sex, birth, phone, address, guardian;

class InfoModify extends StatefulWidget {
  final Patientlist patientinfo;

  InfoModify({Key key, this.patientinfo}) : super(key: key);

  @override
  _InfoModifyState createState() => _InfoModifyState();
}

class _InfoModifyState extends State<InfoModify> {
  Widget PatientData() => DataTable(
        columns: <DataColumn>[
          DataColumn(
              label: Text(" Property"),
              numeric: false,
              onSort: (i, b) {},
              tooltip: "irm company"),
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
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_name,
                onSaved: (input) => name = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
            // stateless와 다르게 statefuld에서 ,paraameter 받을 때 widget.param 이렇게 써야함.
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient sex")),
            DataCell(
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_sex,
                onSaved: (input) => sex = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Birth")),
            DataCell(
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_birth_dttm,
                onSaved: (input) => birth = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Phone")),
            DataCell(
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_phone,
                onSaved: (input) => phone = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Address")),
            DataCell(
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_address,
                onSaved: (input) => address = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("Guardian")),
            DataCell(
              TextFormField(
                decoration: InputDecoration(),
                initialValue: widget.patientinfo.patient_guardian,
                onSaved: (input) => guardian = input,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  return null;
                },
              ),
            ),
          ]),
        ],
      );

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //return_patientinfo = widget.patientinfo ;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("modify"),
      ),
      body: new Container(
        child: Center(
            child: new Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Flexible(child: PatientData()),
                      SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("title"),
                                      content:
                                          new Text("are you sure to modify?"),
                                      actions: <Widget>[
                                        new FlatButton(
                                            onPressed:
                                                Navigator.of(context).pop,
                                            child: Text("No")),
                                        new FlatButton(
                                            onPressed: () async {

                                              formKey.currentState.save();
                                              return_patientinfo = Patientlist(
                                                  widget.patientinfo.vgroup_key,
                                                  widget
                                                      .patientinfo.patient_key,
                                                  widget.patientinfo
                                                      .patient_id_value,
                                                  name,
                                                  sex,
                                                  address,
                                                  birth,
                                                  guardian,
                                                  phone);
                                              var result =await putPatientData(
                                                  return_patientinfo
                                                      .patient_key,
                                                  return_patientinfo
                                                      .patient_name,
                                                  return_patientinfo
                                                      .patient_sex,
                                                  return_patientinfo
                                                      .patient_birth_dttm,
                                                  return_patientinfo
                                                      .patient_phone,
                                                  return_patientinfo
                                                      .patient_address,
                                                  return_patientinfo
                                                      .patient_guardian);
                                              print(result);

                                              if(result["status_code"]==200){


                                                Flushbar(
                                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                                  message: "Request Successfully Saved",
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  backgroundColor: Colors.blueAccent,
                                                  duration: Duration(seconds: 2),
                                                  leftBarIndicatorColor: Colors.blueAccent,

                                                )
                                                  ..show(context).then((r)=> Navigator.popUntil(context, ModalRoute.withName('patients_info')));


                                              }
                                              else{
                                                Flushbar(
                                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                                  message: "Request failed! check out what you did",
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.redAccent,
                                                  ),
                                                  backgroundColor: Colors.redAccent,
                                                  duration: Duration(seconds: 2),
                                                  leftBarIndicatorColor: Colors.redAccent,

                                                )
                                                  ..show(context).then((r)=>  Navigator.pop(context));



                                              }

                                            },
                                            child: Text("Yes"))
                                      ],
                                    );
                                  });
                            }
                          },
                          padding: EdgeInsets.all(12),
                          color: Colors.lightBlueAccent,
                          child: Text('수정하기',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
